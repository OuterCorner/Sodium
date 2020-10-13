#!/bin/bash

SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
PROJ_DIR="$SCRIPTS_DIR/.."

XCBUILD="xcrun xcodebuild"

$XCBUILD build -project "$PROJ_DIR/Sodium.xcodeproj" -scheme 'Sodium' -configuration Release -destination 'generic/platform=iOS' SYMROOT='build'
$XCBUILD build -project "$PROJ_DIR/Sodium.xcodeproj" -scheme 'Sodium' -configuration Release -destination 'generic/platform=iOS Simulator' SYMROOT='build'
$XCBUILD build -project "$PROJ_DIR/Sodium.xcodeproj" -scheme 'Sodium' -configuration Release -destination 'generic/platform=macOS' SYMROOT='build'

# remove bundled libsodium.a we already link it

rm -rf "$PROJ_DIR/build/Release/Sodium.framework/Versions/A/Frameworks"
rm -rf "$PROJ_DIR/build/Release-iphoneos/Sodium.framework/Frameworks"
rm -rf "$PROJ_DIR/build/Release-iphonesimulator/Sodium.framework/Frameworks"


$XCBUILD -create-xcframework \
	-framework "$PROJ_DIR/build/Release/Sodium.framework"\
	-debug-symbols "$PROJ_DIR/build/Release/Sodium.framework.dSYM"\
	-framework "$PROJ_DIR/build/Release-iphoneos/Sodium.framework"\
	-debug-symbols "$PROJ_DIR/build/Release-iphoneos/Sodium.framework.dSYM"\
	-framework "$PROJ_DIR/build/Release-iphonesimulator/Sodium.framework"\
	-debug-symbols "$PROJ_DIR/build/Release-iphonesimulator/Sodium.framework.dSYM" \
	-output "$PROJ_DIR/build/Sodium.xcframework"
