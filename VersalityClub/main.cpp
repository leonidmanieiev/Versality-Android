/****************************************************************************
**
** Copyright (C) 2019 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality.
**
** Versality is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Versality. If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/

#include <QQmlApplicationEngine>
#include <QtWebView/QtWebView>
#include <QTextStream>
#include <QSslSocket>
#include <QDebug>
#include <QFile>

#include "appsettings.h"
#include "networkinfo.h"
#include "geolocationinfo.h"
#include "pagenameholder.h"
#include "promotionclusters.h"
#include "cppmethodcall.h"
#ifdef __ANDROID__
#include <QGuiApplication>
#include <QtAndroid>
#include "jni.h"
#include "qonesignal.h"
#else
#include "QApplication"
#endif

bool CppMethodCall::locationServiceStarted = false;

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef __ANDROID__
    QGuiApplication app(argc, argv);
#else
    QApplication app(argc, argv);
#endif

    QtWebView::initialize();
#ifdef __ANDROID__
    QOneSignal::registerQMLTypes();
#endif
    qmlRegisterType<NetworkInfo>("Network", 0, 6, "NetworkInfo");
    qmlRegisterType<GeoLocationInfo>("GeoLocation", 0, 6, "GeoLocationInfo");
    qmlRegisterType<CppMethodCall>("CppCall", 0, 6, "CppMethodCall");
    qmlRegisterType<AppSettings>("org.versalityclub", 0, 6, "AppSettings");
    qmlRegisterType<PageNameHolder>("org.versalityclub", 0, 6, "PageNameHolder");
    qmlRegisterType<PromotionClusters>("org.versalityclub", 0, 6, "PromotionClusters");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

#ifdef __ANDROID__
    CppMethodCall cppCall;
    //saving hash to file
    cppCall.saveHashToFile();
    //starting location service
    cppCall.startLocationService();
#endif
    return app.exec();
}
