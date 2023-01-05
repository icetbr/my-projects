#!/bin/bash

# -e stops on error
# -u stops on unset variable
# -o pipefail stops if any part of the pipeline fails
set -euo pipefail

set -a && . $RUN_PATH/../../.env && set +a    # load .env
PATH=$PATH:$RUN_PATH/node_modules/.bin        # enable calls like `mocha` instead of `node_modules/.bin/mocha`

################
## UTIL
################
map           () { read -r args && for f in $args; do $1 $f ; done                    ;}
_nodeSh       () { node -e "import('@icetbr/utils/$1').then(m => console.log(m.$1(${2:- })))"  ;}
_nodeSh2      () { node -e "import('@icetbr/utils/$1').then(m => m.$2(${3:- }))"   ;}

################
## DEV
################
_node       () { NODE_NO_WARNINGS=1 node --experimental-fetch "$@"       ;}
_nodei      () { _node --inspect=9231 "$@"                               ;}
_nodemon    () { _nodei nodemon -x "printf \"\033c\";${!1}"              ;}
test        () { _node _mocha "$@"                                       ;}
testi       () { _nodei _mocha "$@"                                      ;}


################
## MAINTAINANCE
################
_createGithubRepo () {
    if [ -z "$1" ]; then echo "Usage: run newRepo repo-name"; exit 1; fi

    curl -H "Authorization: token $GITHUB_TOKEN" https://api.github.com/user/repos -d '{"name":"'$1'"}'
    git init
    git branch -m main
    git remote add origin git@github.com:icetbr/$1.git
}

commonFiles=(rollup.config.js .eslintrc.json .gitignore run.sh LICENSE CONTRIBUTING.md .vscode/cspell.json jsconfig.json)
libs=(projects/dxest projects/utils)

editIcon               () { ~/tools/Inkscape.AppImage media/icon.svg                                                       ;}
generateManifestIcons  () { _nodeSh generateIcons "'./media/icon.svg', './media/icons', [16, 32, 48, 96, 128]"             ;}
listPackagesNames      () { _nodeSh 'listPackagesNames' "'./.vscode/packages-names.txt'"                                   ;}
spellcheck             () { touch ./.vscode/project-words.txt && cspell src/*.js README.md                                 ;}
createRepoOnGithub     () { _createRepoOnGithub "$@"                                                                       ;}
syncMetadata           () { _nodeSh 'syncMetadata'                                                                         ;} # Syncs `description`/`keywords` from `package.json` to Github's **description/topics** sections and README.md first line */
# publishOpenUserJs      () { _nodeSh2 'publishOpenUserJs' "{ path: 'scripts'}"                                              ;}
publishOpenUserJs      () { _nodeSh2 'openUserJs' 'publish'                                              ;}
getOpenUserJsReadme    () { _nodeSh2 'openUserJs' 'getReadme'                                                              ;}
readmeToHtml           () { _nodeSh 'readmeToHtml'                                                                   ;}
types                  () { npx -p typescript tsc src/*.js --declaration --allowJs --emitDeclarationOnly --outDir types    ;}
ncu                    () { ncu --workspaces                                                                               ;}

link                   () { rm -f $1 && mkdir -p .vscode && ln ../../$1 $1                                                 ;}
linkConfigs            () { echo ${commonFiles[*]} | map link                                                              ;} # hard linking for git

all                    () { base=$(pwd) && for d in projects/webext*/ ;{ echo $d && cd $base/$d && $1 ;}                   ;}
allLibs                () { base=$(pwd) && for d in ${libs[*]} ;{ echo $d && cd $base/$d && $1 ;}                          ;}

################
## WEBEXT
################
## NOTES
# - web-ext lint is always needed because if the extension doesn’t meet the standards, it is rejected by the browser store
# - I lint only the `dist`` folder because I rely on the IDE to lint the `src` folder


ffUploadUrl=https://addons.mozilla.org/en-US/developers/addon/submit/upload-listed

## TEMP
# - the code is not ready to be airbnb-lintable
_lintAirbnb     () { eslint dist && web-ext lint ;}
_lintJustWebext () { web-ext lint                ;}
# publishChrome    () { build && adjustManifestV3 && chrome-webstore-upload upload --source dist --extension-id $WEBEXT_ID --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN           ;}

# --id=$WEBEXT_ID
## SUPPORT
uploadFf         () { web-ext sign --channel=listed --api-key=$FIREFOX_KEY --api-secret=$FIREFOX_SECRET                                                                  ;}
uploadChrome     () { chrome-webstore-upload publish --source dist --extension-id $WEBEXT_ID --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN ;}
zipSrc           () { cd dist && zip -r -FS ../$WEBEXT_ID *                                     ;}
lint             () { _lintJustWebext "$@"                                                      ;} # see NOTES
copyFilesToDist  () { cp -R manifest.json media/icons dist                                      ;}
adjustManifestV3 () { sed -i 's/2/3/' dist/manifest.json && sed -i '18,23d' dist/manifest.json  ;}
bundle           () { rollup --config node:@icetbr/rollup-config-webext                      ;}
showInFirefox    () { firefox $ffUploadUrl && wmctrl -a firefox && zenity --info --text $PWD/$WEBEXT_ID  ;}

## PUBLISH
build            () { bundle && copyFilesToDist && lint          ;}
firstRun         () { build && zipSrc && showInFirefox           ;}
publishFirefox   () { build && uploadFf                          ;}
publishChrome    () { build && adjustManifestV3 && uploadChrome  ;}

## TODO sync readme firefox

## DEV
watch             () { rollup --config node:@icetbr/rollup-config-webext --watch  ;}
