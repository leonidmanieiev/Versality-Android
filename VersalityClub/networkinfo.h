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

// Wrapper, so I can use functionality of QNetworkAccessManager in QML
// For checking valid internet connection
#ifndef NETWORKINFO_H
#define NETWORKINFO_H

#include <QNetworkAccessManager>

class NetworkInfo : public QNetworkAccessManager
{
    Q_OBJECT

public:
    explicit NetworkInfo(QObject *parent = nullptr) :
        QNetworkAccessManager(parent)
    {
        //workaround for initial network flag setting
        QNetworkAccessManager::NetworkAccessibility currNetworkStatus =
            QNetworkAccessManager::networkAccessible();
        oldNetworkStatus = currNetworkStatus == QNetworkAccessManager::Accessible ?
                                                QNetworkAccessManager::NotAccessible :
                                                QNetworkAccessManager::Accessible;
        startTimer(1000);
    }
    void timerEvent([[maybe_unused]] QTimerEvent *e)
    {
        QNetworkAccessManager::NetworkAccessibility currNetworkStatus =
            QNetworkAccessManager::networkAccessible();

        if(oldNetworkStatus != currNetworkStatus)
        {
            oldNetworkStatus = currNetworkStatus;
            triggerEvent(currNetworkStatus);
        }
    }
    Q_INVOKABLE void triggerEvent(QNetworkAccessManager::NetworkAccessibility networkStatus)
    { emit networkStatusChanged(networkStatus); }
    Q_INVOKABLE QNetworkAccessManager::NetworkAccessibility networkStatus() const
    { return QNetworkAccessManager::networkAccessible(); }
signals:
    void networkStatusChanged(QNetworkAccessManager::NetworkAccessibility accessible);
private:
    QNetworkAccessManager::NetworkAccessibility oldNetworkStatus;
};

#endif // NETWORKINFO_H
