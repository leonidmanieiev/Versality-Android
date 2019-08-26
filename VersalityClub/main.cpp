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

#include "appsettings.h"
#include "cppmethodcall.h"
#include "network.h"
#include "pagenameholder.h"
#include "promotionclusters.h"
#include "qonesignal.h"
#include "sslsafenetworkfactory.h"
#include "enablelocation.h"

#include <QDebug>
#include <QFile>
#include <QGuiApplication>
#include <QOperatingSystemVersion>
#include <QQmlApplicationEngine>
#include <QSslSocket>
#include <QTextStream>
#include <QtWebView/QtWebView>

bool AppSettings::needToRemovePromsAndComps = true;

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QGuiApplication app(argc, argv);
    QtWebView::initialize();

    //QOneSignal::registerQMLTypes();
    qmlRegisterType<Network>("Network", 0, 9, "Network");
    qmlRegisterType<AppSettings>("org.versalityclub", 0, 8, "AppSettings");
    qmlRegisterType<PageNameHolder>("org.versalityclub", 0, 8, "PageNameHolder");
    qmlRegisterType<PromotionClusters>("org.versalityclub", 0, 8, "PromotionClusters");
    qmlRegisterSingletonType<CppMethodCall>("CppMethodCall", 0, 9, "CppMethodCall", &CppMethodCall::singletonProvider);
    qmlRegisterSingletonType<CppMethodCall>("EnableLocation", 0, 9, "EnableLocation", &EnableLocation::singletonProvider);

    QQmlApplicationEngine engine;

    //workaround of "SSL handshake failed" issue on API LEVEL < 23
    if(QOperatingSystemVersion::current() < QOperatingSystemVersion::AndroidMarshmallow)
        engine.setNetworkAccessManagerFactory(new SSLSafeNetworkFactory);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    CppMethodCall::saveHashToFile();

    return app.exec();
}
