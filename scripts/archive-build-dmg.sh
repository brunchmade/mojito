mkdir build
xcodebuild -scheme "Mojito" archive -archivePath build/mojito

export ARCHIVE_PATH=build/mojito.xcarchive
export APP_VERSION=$(/usr/libexec/PlistBuddy -c "Print :ApplicationProperties:CFBundleShortVersionString" "$ARCHIVE_PATH/Info.plist")
export APP_BUILD=$(/usr/libexec/PlistBuddy -c "Print :ApplicationProperties:CFBundleVersion" "$ARCHIVE_PATH/Info.plist")
export ARCHIVE_PRODUCTS_PATH=$ARCHIVE_PATH/Products
# You will need to install dmgbuild first, run "pip install dmgbuild"
/Library/Frameworks/Python.framework/Versions/2.7/bin/dmgbuild -s Mojito/dmg_settings.py \
    "Mojito installation" build/mojito.dmg
