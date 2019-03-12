SODIUM_TARBALL="$SRCROOT/libsodium-$SODIUM_VERSION.tar.gz"
SODIUM_SRC="$TARGET_TEMP_DIR/sodium/"
SODIUM_INSTALL="$TARGET_TEMP_DIR/sodium_install/"
LIB_PRODUCT_NAME="$FULL_PRODUCT_NAME"


if [ "$PLATFORM_NAME" == "" ]; then
echo "PLATFORM_NAME not defined"
fi

# check whether libcrypto.a already exists - we'll only build if it does not
if [ -f  "$TARGET_BUILD_DIR/$LIB_PRODUCT_NAME" ]; then
    echo "Using previously-built libary $TARGET_BUILD_DIR/$LIB_PRODUCT_NAME - skipping build"
    echo "To force a rebuild clean project and clean dependencies"
    exit 0;
else
    echo "No previously-built libary present at $TARGET_BUILD_DIR/$LIB_PRODUCT_NAME - performing build"
fi


if [ ! -f "$SODIUM_TARBALL" ]; then
    echo "Downloading libsodium-$SODIUM_VERSION.tar.gz"
    curl -O "https://download.libsodium.org/libsodium/releases/libsodium-$SODIUM_VERSION.tar.gz" || exit 1
fi


echo "Extracting $SODIUM_TARBALL..."
mkdir -p "$SODIUM_SRC"
tar -C "$SODIUM_SRC" --strip-components=1 -zxf "$SODIUM_TARBALL" || exit 1
cd "$SODIUM_SRC"

if [ -z "$LIBSODIUM_FULL_BUILD" ]; then
	LIBSODIUM_ENABLE_MINIMAL_FLAG="--enable-minimal"
else
	LIBSODIUM_ENABLE_MINIMAL_FLAG=""
fi

SODIUM_OPTIONS="$LIBSODIUM_ENABLE_MINIMAL_FLAG --prefix=$SODIUM_INSTALL"

NPROCESSORS=$(getconf NPROCESSORS_ONLN 2>/dev/null || getconf _NPROCESSORS_ONLN 2>/dev/null)
PROCESSORS=${NPROCESSORS:-3}

echo "Creating $LIB_PRODUCT_NAME with $SODIUM_OPTIONS for architectures: $ARCHS"

for BUILDARCH in $ARCHS
do
    echo "Building $BUILDARCH"
	
	make distclean > /dev/null
	
	CFLAGS="-arch $BUILDARCH -O2"
	LDFLAGS="-arch $BUILDARCH"
	
	if [ "$PLATFORM_NAME" = "macosx" ]; then
		CONFIGURE_OPTIONS="$SODIUM_OPTIONS"

	elif [ "$PLATFORM_NAME" = "iphoneos" ]; then
				
		if [[ "$BUILDARCH" = "armv"* ]]; then
			CFLAGS="$CFLAGS -fembed-bitcode -mthumb -isysroot $SDKROOT -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
			LDFLAGS="$LDFLAGS -fembed-bitcode -mthumb -isysroot $SDKROOT -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
		elif [ "$BUILDARCH" = "arm64" ]; then
			CFLAGS="$CFLAGS -fembed-bitcode -isysroot $SDKROOT -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
			LDFLAGS="$LDFLAGS -fembed-bitcode -isysroot $SDKROOT -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
		fi

		CONFIGURE_OPTIONS="$SODIUM_OPTIONS --host=arm-apple-darwin10 --disable-shared"

	elif [ "$PLATFORM_NAME" = "iphonesimulator" ]; then
		# Build for the simulator
		CFLAGS="$CFLAGS -isysroot $SDKROOT -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
		LDFLAGS="$LDFLAGS -isysroot $SDKROOT -mios-version-min=${IPHONEOS_DEPLOYMENT_TARGET}"
		
		if [ "$BUILDARCH" = "i386" ]; then
			CONFIGURE_OPTIONS="$SODIUM_OPTIONS --host=i686-apple-darwin10 --disable-shared"
		elif [ "$BUILDARCH" = "x86_64" ]; then
			CONFIGURE_OPTIONS="$SODIUM_OPTIONS --host=x86_64-apple-darwin10 --disable-shared"
		fi

	else
		echo "Unsupported platform $PLATFORM_NAME"
		exit 1
	fi
	
	rm -rf "$SODIUM_INSTALL"
	mkdir -p "$SODIUM_INSTALL"
	
	export CFLAGS="$CFLAGS"
	export LDFLAGS="$LDFLAGS"
	export PATH="$PLATFORM_DEVELOPER_BIN_DIR:$PLATFORM_DEVELOPER_USR_DIR/sbin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
	export CC="xcrun -sdk $PLATFORM_NAME cc $CFLAGS"
    ./configure $CONFIGURE_OPTIONS


	make -j${PROCESSORS} install || exit 1

	echo "Creating $LIB_PRODUCT_NAME for $BUILDARCH in $TARGET_TEMP_DIR"
	cp "$SODIUM_INSTALL/lib/libsodium.a" "$TARGET_TEMP_DIR/$BUILDARCH-$LIB_PRODUCT_NAME"
done


echo "Creating universal archive in $TARGET_BUILD_DIR"
mkdir -p "$TARGET_BUILD_DIR"
lipo -create "$TARGET_TEMP_DIR/"*-$LIB_PRODUCT_NAME -output "$TARGET_BUILD_DIR/$LIB_PRODUCT_NAME"

echo "Executing ranlib"
ranlib "$TARGET_BUILD_DIR/$LIB_PRODUCT_NAME"

echo "Copying Headers"
mkdir -p "$TARGET_BUILD_DIR/headers"
cp -RLf "$SODIUM_INSTALL/include/" "$TARGET_BUILD_DIR/headers"

make distclean > /dev/null
