#!/bin/bash

iconParams="{
    imagePath: './media/icon.svg',
    outDir: './media/icons',
    sizes: [16, 32, 48, 96, 128]
}"

rollup=node_modules/@icetbr/rollup-config-webext/node_modules/.bin/rollup # using this transitive rollup because it uses other dependencies as well
concurrently=node_modules/.bin/concurrently
webExt=node_modules/.bin/web-ext
chromeWebstoreUpload=node_modules/.bin/chrome-webstore-upload

nodeSh     () { node -e "import('@icetbr/publish').then(m => m.$2(${3:- }))"   ;} # Usage: nodeSh fileName functionName params
# nodeSh       () { node -e "import('@icetbr/utils/$1').then(m => console.log(m.$1(${2:- })))"  ;}
# _nodeSh2      () { node -e "import('@icetbr/utils/$1').then(m => m.$2(${3:- }))"   ;}
createGithubRepo () {
    if [[ $# -eq 0 ]]; then echo "Usage: run newRepo repo-name"; exit 1; fi

    curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$1'"}'
    git init
    git branch -m main
    git remote add origin git@github.com:icetbr/$1.git
}

editIcon               () { ~/tools/inkscape media/icon.svg          ;}
generateManifestIcons  () { nodeSh generateIcons generateIcons "$iconParams"  ;}
syncMetadata           () { nodeSh syncMetadata syncMetadata                  ;} # Syncs `description`/`keywords` from `package.json` to Github's **description/topics** sections and README.md first line */
openuserReadme         () { nodeSh readme openOpenuserReadme                  ;}
firefoxReadme          () { nodeSh readme openFirefoxReadme                   ;}
chromeReadme           () { nodeSh readme openChromeReadme                    ;}

userscripts      () { git -C ../userscripts/ commit -a -m "new version" && git -C ../userscripts/ push ;}
uploadFf         () { $webExt sign --approval-timeout=0 --channel=listed --api-key=$FIREFOX_KEY --api-secret=$FIREFOX_SECRET                                                                  ;}
uploadChrome     () { chromeId=$(grep addonIds manifest.json | grep -Eo '/\w*'| cut -c2- || true) &&
                      $chromeWebstoreUpload upload --source dist --extension-id $chromeId --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN ;}
zipSrc           () { cd dist && zip -r -FS ../webext * && cd ..                                ;}
lint             () { $webExt lint                                                              ;} # lint is mandatory!
# copyFilesToDist  () { cp -R manifest.json src/options.html src/options.js src/state.js media/icons dist || true                                    ;} # 2>/dev/null
# copyFilesToDist  () { rsync -a --exclude=*.ts src/* manifest.json media/icons dist || true                                    ;} # 2>/dev/null
copyFilesToDist  () { rsync -a src/content.js manifest.json media/icons dist || true                                    ;} # 2>/dev/null
adjustManifestV3 () { sed -i '0,/2/s//3/' dist/manifest.json && sed -i '19,24d' dist/manifest.json && sed -i 's/browser_action/action/g' dist/manifest.json && sed -i 's/browser./chrome./g' dist/content.js && sed -i 's/browser./chrome./g' dist/options.js || true;}
dev      () { $rollup --config node:@icetbr/rollup-config-webext/dev --watch               ;}
prod             () { $rollup --config node:@icetbr/rollup-config-webext/prod                      ;}
watchBrowser     () { $webExt run --verbose --source-dir ./dist                                                             ;}
refreshBrowser() {
    wid=$(xdotool search --class chrome | tail -1)
    [ -n "$wid" ]
    xdotool windowactivate "$wid" key ctrl+r windowactivate "$(xdotool getactivewindow)"
}

# -p preserves attributes, /_ is the changed file, dist/ is the target
WATCH_ASSETS="ls src/*.html src/*.css manifest.json | entr cp -p /_ dist/"

devExt() {
    echo "Launching Dev Environment..."

    # --tag: Prefixes logs so you know which tool is talking
    # --line-buffer: Keeps logs from overlapping
    # ::: separates the commands
    parallel --tag --line-buffer --halt now,fail=1 ::: \
        "$rollup --config node:@icetbr/rollup-config-webext/dev --watch" \
        "$WATCH_ASSETS" \
        "$webExt run --verbose --source-dir ./dist"
}

## PUBLISH
cspell           () { pnpm dlx cspell node_modules/@icetbr/cspell-config/cspell.json                   ;}
build            () { prod && copyFilesToDist && lint                   ;}
firefoxFirst     () { build && zipSrc && firefoxReadme                    ;}
firefox          () { build && uploadFf                                   ;}
firstChrome      () { build && zipSrc && chromeReadme ;}
chrome           () { build && uploadChrome           ;}

## DEV
watch             () { $rollup --config node:@icetbr/rollup-config-webext --watch  ;}
updateDeps        () { npx run npm-check-updates -u                               ;}

# test        () { mocha "$@"                                       ;}

# bundler for config scripts? import like node?
