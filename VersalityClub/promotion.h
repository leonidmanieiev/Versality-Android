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

/*using this object to implement clustering of promotions*/

#ifndef PROMOTION_H
#define PROMOTION_H

#include <QDebug>
#include <QString>
#include <QJsonValue>
#include <QJsonObject>
#include <QGeoCoordinate>

class Promotion
{
public:
    Promotion();
    Promotion(const QJsonValue& jsonValue);
    void print() const;
    QJsonObject toJsonObject() const;
    //distance between two promotions in meters
    double distTo(const Promotion& prom) const;
private:
    QString id;
    QString title;
    int icon;
    double lat;
    double lon;
};

#endif // PROMOTION_H
