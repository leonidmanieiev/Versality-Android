contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/arm/libcrypto.so \
        $$PWD/arm/libssl.so
}

contains(ANDROID_TARGET_ARCH,arm64-v8a) {
    ANDROID_EXTRA_LIBS += \
        $$PWD/aarch64/libcrypto.so \
        $$PWD/aarch64/libssl.so
}