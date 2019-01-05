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

#include "promotion.h"

Promotion::Promotion() : id{QString()}, title{QString()}, icon{0},
                         lat{0.0}, lon{0.0} { }

Promotion::Promotion(const QJsonValue& jsonValue)
{
    this->id = jsonValue["id"].toString();
    this->title = jsonValue["title"].toString();
    this->icon = jsonValue["icon"].toInt();
    this->lat = jsonValue["lat"].toDouble();
    this->lon = jsonValue["lon"].toDouble();
}

void Promotion::print() const
{
    qDebug() << "id:" << id << "\ntitle:" << title
             << "\nicon:" << icon << "\nlat:" << lat
             << "\nlon:" << lon << '\n';
}

QJsonObject Promotion::toJsonObject() const
{
    QJsonObject jsonPromObj{};

    jsonPromObj.insert("id", id);
    jsonPromObj.insert("title", title);
    jsonPromObj.insert("icon", icon);
    jsonPromObj.insert("lat", lat);
    jsonPromObj.insert("lon", lon);

    return jsonPromObj;
}

double Promotion::distTo(const Promotion &prom) const
{
    QGeoCoordinate prom1GeoCoord{this->lat, this->lon};
    QGeoCoordinate prom2GeoCoord{prom.lat, prom.lon};

    return prom1GeoCoord.distanceTo(prom2GeoCoord);
}
