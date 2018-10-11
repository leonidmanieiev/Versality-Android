# includes openssl libs onto android build
android {
#  ANDROID_EXTRA_LIBS += /Developer/android-openssl-qt/prebuilt/armeabi-v7a/libcrypto.so
#  ANDROID_EXTRA_LIBS += /Developer/android-openssl-qt/prebuilt/armeabi-v7a/libssl.so
  ANDROID_EXTRA_LIBS += $$PWD/libcrypto.so
  ANDROID_EXTRA_LIBS += $$PWD/libssl.so
}
