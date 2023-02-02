#!/bin/bash

iconParams="{
    imagePath: './media/icon.svg',
    outDir: './media/icons',
    sizes: [16, 32, 48, 96, 128]
}"

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

editIcon               () { ~/tools/Inkscape.AppImage media/icon.svg          ;}
generateManifestIcons  () { nodeSh generateIcons generateIcons "$iconParams"  ;}
syncMetadata           () { nodeSh syncMetadata syncMetadata                  ;} # Syncs `description`/`keywords` from `package.json` to Github's **description/topics** sections and README.md first line */
openuserReadme         () { nodeSh readme openOpenuserReadme                  ;}
firefoxReadme          () { nodeSh readme openFirefoxReadme                   ;}
chromeReadme           () { nodeSh readme openChromeReadme                    ;}

uploadFf         () { web-ext sign --channel=listed --api-key=$FIREFOX_KEY --api-secret=$FIREFOX_SECRET                                                                  ;}
uploadChrome     () { chrome-webstore-upload upload --source dist --extension-id $CHROME_ID --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN ;}
zipSrc           () { cd dist && zip -r -FS ../webext * && cd ..                                ;}
lint             () { web-ext lint                                                              ;} # lint is mandatory!
copyFilesToDist  () { cp -R manifest.json media/icons dist                                      ;}
adjustManifestV3 () { sed -i '0,/2/s//3/' dist/manifest.json && sed -i '18,24d' dist/manifest.json  ;}
bundle           () { rollup --config node:@icetbr/rollup-config-webext                      ;}

## PUBLISH
build            () { bundle && copyFilesToDist && lint                   ;}
firefoxFirst     () { build && zipSrc && firefoxReadme                    ;}
firefox          () { build && uploadFf                                   ;}
firstChrome      () { build && adjustManifestV3 && zipSrc && chromeReadme ;}
chrome           () { build && adjustManifestV3 && uploadChrome           ;}

# && zenity --info --text $PWD/$WEBEXT_ID

# --id=$WEBEXT_ID
ddv      () { _nodeSh2 'chromestore' 'upload'                    ;}
d      () { echo oka                  ;}
# publishChrome    () { build && adjustManifestV3 && chrome-webstore-upload upload --source dist --extension-id $WEBEXT_ID --client-id $CHROME_KEY --client-secret $CHROME_SECRET --refresh-token $CHROME_REFRESH_TOKEN           ;}
t () { curl -H "Authorization: Bearer 1//0hVs5EDy4WDnWCgYIARAAGBESNwF-L9IrFu4gBX3-MGjDXHxyIZsWgMXXM4OZSuBq5l19i2ZKGBYwV1XjJbWPdxbn5AVEZcDUVh8" -H "x-goog-api-version: 2" -X POST -T "${WEBEXT_ID}.zip" -v https://www.googleapis.com/upload/chromewebstore/v1.1/items ;}
x () { curl "https://accounts.google.com/o/oauth2/token" -d "client_id=$CHROME_KEY&client_secret=$CHROME_SECRET&code=$CHROME_CODE&grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob" ;}
y () { echo "https://accounts.google.com/o/oauth2/auth?response_type=code&scope=https://www.googleapis.com/auth/chromewebstore&client_id=$CHROME_KEY&redirect_uri=urn:ietf:wg:oauth:2.0:oob" ;}
z () { echo "client_id=$CHROME_KEY&client_secret=$CHROME_SECRET&code=$CHROME_REFRESH_TOKEN&grant_type=authorization_code&redirect_uri=urn:ietf:wg:oauth:2.0:oob" ;}
# zipSrc           () { cd dist && zip -r -FS ../$WEBEXT_ID *                                     ;}
## DEV
watch             () { rollup --config node:@icetbr/rollup-config-webext --watch  ;}

test        () { mocha "$@"                                       ;}
