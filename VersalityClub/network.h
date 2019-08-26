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

// Wrapper, so I check internet connection
#ifndef NETWORK_H
#define NETWORK_H

#include <QtNetwork>

class Network : public QObject
{
    Q_OBJECT
public:
    explicit Network(QObject *parent = nullptr) : QObject(parent) { }

    Q_INVOKABLE bool hasConnection()
    {
        QNetworkAccessManager nam;
        QNetworkRequest request(QUrl("http://www.google.com"));
        QNetworkReply* reply = nam.get(request);
        QEventLoop loop;

        connect(reply, SIGNAL(finished()), &loop, SLOT(quit()));
        loop.exec();

        if (reply->bytesAvailable()) {
            return true;
        } else {
            return false;
        }
    }
};

#endif // NETWORK_H
