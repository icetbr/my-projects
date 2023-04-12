#!/bin/bash

iconParams="{
    imagePath: './media/icon.svg',
    outDir: './media/icons',
    sizes: [16, 32, 48, 96, 128]
}"

chromeId=$(grep addonIds manifest.json | grep -Eo '/\w*'| cut -c2-)

nodeSh     () { node -e "import('@icetbr/utils/$1').then(m => m.$2(${3:- }))"   ;} # Usage: nodeSh fileName functionName params
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

uploadFf         () { web-ext sign --channel=listed --api-key=$FIREFOX_KEY --api-secret=$FIREFOX_SECRET                                                                  ;}
uploadChrome     () { chrome-webstore-upload upload --source dist --extension-id $chromeId --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN ;}
zipSrc           () { cd dist && zip -r -FS ../webext * && cd ..                                ;}
lint             () { web-ext lint                                                              ;} # lint is mandatory!
copyFilesToDist  () { cp -R manifest.json src/options.html src/options.js src/state.js media/icons dist 2>/dev/null                                     ;}
adjustManifestV3 () { sed -i '0,/2/s//3/' dist/manifest.json && sed -i '18,24d' dist/manifest.json && sed -i 's/browser_action/action/g' dist/manifest.json && sed -i 's/browser./chrome./g' dist/content.js && sed -i 's/browser./chrome./g' dist/options.js;}
bundle           () { rollup --config node:@icetbr/rollup-config-webext                      ;}

## PUBLISH
build            () { bundle && copyFilesToDist && lint                   ;}
firefoxFirst     () { build && zipSrc && firefoxReadme                    ;}
firefox          () { build && uploadFf                                   ;}
firstChrome      () { build && adjustManifestV3 && zipSrc && chromeReadme ;}
chrome           () { build && adjustManifestV3 && uploadChrome           ;}

## DEV
watch             () { rollup --config node:@icetbr/rollup-config-webext --watch  ;}

test        () { mocha "$@"                                       ;}
