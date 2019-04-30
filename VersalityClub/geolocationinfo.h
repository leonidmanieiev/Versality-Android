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

//Wrapper, so I can use functionality of QGeoPositionInfo in QML
#ifndef GEOLOCATIONINFO_H
#define GEOLOCATIONINFO_H

#include <QGeoPositionInfo>
#include <QGeoPositionInfoSource>

class GeoLocationInfo : public QObject
{
    Q_OBJECT
public:
    GeoLocationInfo(QObject *parent = nullptr)
        : QObject(parent)
    {
        QGeoPositionInfoSource *source = QGeoPositionInfoSource::createDefaultSource(this);
        if(source)
        {
            connect(source, SIGNAL(positionUpdated(QGeoPositionInfo)),
                    this, SLOT(positionUpdatedSlot(QGeoPositionInfo)));
            source->startUpdates();
        }
    }
    Q_INVOKABLE double getLat() const
    { return this->lat; }
    Q_INVOKABLE double getLon() const
    { return this->lon; }
private slots:
    void positionUpdatedSlot(const QGeoPositionInfo &info)
    {
        this->lat = info.coordinate().latitude();
        this->lon = info.coordinate().longitude();
        emit(positionUpdated(info));
    }
signals:
    void positionUpdated(const QGeoPositionInfo &update);
private:
    double lat;
    double lon;
};

#endif // GEOLOCATIONINFO_H
