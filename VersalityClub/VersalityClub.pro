QT += quick network webview svg positioning
CONFIG += c++17

DEFINES += QT_DEPRECATED_WARNINGS

SOURCES += \
        main.cpp \
    promotion.cpp \
    promotionclusters.cpp

RESOURCES += \
    versalityclub.qrc

HEADERS += \
    networkinfo.h \
    appsettings.h \
    geolocationinfo.h \
    promotion.h \
    pagenameholder.h \
    promotionclusters.h \
    cppmethodcall.h \
    sslsafenetworkaccessmanager.h \
    sslsafenetworkfactory.h

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    android/res/drawable-hdpi/ic_stat_onesignal_default.png \
    android/res/drawable-mdpi/ic_stat_onesignal_default.png \
    android/res/drawable-xhdpi/ic_stat_onesignal_default.png \
    android/res/drawable-xxhdpi/ic_stat_onesignal_default.png \
    android/res/drawable-xxxhdpi/ic_stat_onesignal_default.png \
    java/LocationService.java \
    java/HttpURLCon.java

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
ANDROID_JAVA_SOURCES.path = /src/org/versalityclub
ANDROID_JAVA_SOURCES.files = $$files($$PWD/java/*.java)
INSTALLS += ANDROID_JAVA_SOURCES

include(../thirdparty/onesignal/qtonesignal.pri)
include(openssl/openssl.pri)

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
