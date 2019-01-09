/****************************************************************************
**
** Copyright (C) 2018 Leonid Manieiev.
** Contact: leonid.manieiev@gmail.com
**
** This file is part of Versality Club.
**
** Versality Club is free software: you can redistribute it and/or modify
** it under the terms of the GNU General Public License as published by
** the Free Software Foundation, either version 3 of the License, or
** (at your option) any later version.
**
** Versality Club is distributed in the hope that it will be useful,
** but WITHOUT ANY WARRANTY; without even the implied warranty of
** MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
** GNU General Public License for more details.
**
** You should have received a copy of the GNU General Public License
** along with Foobar.  If not, see <https://www.gnu.org/licenses/>.
**
****************************************************************************/

#include <QQmlApplicationEngine>
#include <QSslSocket>
#include <QtWebView/QtWebView>
#include "appsettings.h"
#include "networkinfo.h"
#include "geolocationinfo.h"
#include "pagenameholder.h"
#include "promotionclusters.h"
#ifdef __ANDROID__
#include <QGuiApplication>
#include "qonesignal.h"
#else
#include "QApplication"
#endif

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

#ifdef __ANDROID__
    QGuiApplication app(argc, argv);
    QOneSignal::registerQMLTypes();
#else
    QApplication app(argc, argv);
#endif

    QtWebView::initialize();

    qmlRegisterType<AppSettings>("org.versalityclub", 1, 0, "AppSettings");
    qmlRegisterType<NetworkInfo>("Network", 1, 0, "NetworkInfo");
    qmlRegisterType<GeoLocationInfo>("GeoLocation", 1, 0, "GeoLocationInfo");
    qmlRegisterType<PageNameHolder>("org.versalityclub", 1, 0, "PageNameHolder");
    qmlRegisterType<PromotionClusters>("org.versalityclub", 1, 0, "PromotionClusters");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
