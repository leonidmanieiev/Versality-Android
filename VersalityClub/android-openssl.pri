# includes openssl libs into android build
android {
  ANDROID_EXTRA_LIBS += $$PWD/libcrypto.so
  ANDROID_EXTRA_LIBS += $$PWD/libssl.so
}
