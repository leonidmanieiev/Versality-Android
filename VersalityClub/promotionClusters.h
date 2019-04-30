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

/*object represent cluster of promotions*/

#ifndef PROMOTIONCLUSTERS_H
#define PROMOTIONCLUSTERS_H

#include "promotion.h"

#include <QDebug>
#include <QString>
#include <QObject>
#include <QVector>
#include <array>
#include <exception>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonParseError>

class PromotionClusters : public QObject
{
    Q_OBJECT
public:
    explicit PromotionClusters(QObject *parent = nullptr);
    /*constructs and stores all promotions in vector
      may throws std::invalid_argument*/
    QVector<Promotion> getPromotions(const QString& jsonText) const;
    void addToCluster(const Promotion& currProm, unsigned short minDist);
    //get jsonText of clusters for MapItemView model
    Q_INVOKABLE QString clustering(const QString& jsonText, quint8 zoomLevel);
    //converts clusters as object to json in text form
    QString clustersToJsonText() const;
private:
    //cluster
    QVector<QVector<Promotion>> clusters;
};

#endif // PROMOTIONCLUSTERS_H
