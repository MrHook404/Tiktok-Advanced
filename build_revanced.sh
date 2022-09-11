#!/bin/bash
#F1R3W4LL404_Version

declare -A artifacts

artifacts["revanced-cli.jar"]="revanced/revanced-cli revanced-cli .jar"
artifacts["revanced-integrations.apk"]="revanced/revanced-integrations app-release-unsigned .apk"
artifacts["revanced-patches.jar"]="revanced/revanced-patches revanced-patches .jar"

get_artifact_download_url () {
    local api_url="https://api.github.com/repos/$1/releases/latest"
    local result=$(curl $api_url | jq ".assets[] | select(.name | contains(\"$2\") and contains(\"$3\") and (contains(\".sig\") | not)) | .browser_download_url")
    echo ${result:1:-1}
}

for artifact in "${!artifacts[@]}"; do
    if [ ! -f $artifact ]; then
        echo "Downloading $artifact"
        curl -L -o $artifact $(get_artifact_download_url ${artifacts[$artifact]})
    fi
done

echo "************************************"
echo "Building Tiktok APK"
echo "************************************"

mkdir -p build

if [ -f "com.zhiliaoapp.musically.apk" ]
then
    echo "Building Non-root APK"
    java -jar revanced-cli.jar -m revanced-integrations.apk -b revanced-patches.jar  \
                               -a com.zhiliaoapp.musically.apk -o build/Tiktok-nonroot.apk
else
    echo "Cannot find Tiktok APK, skipping build"
fi
