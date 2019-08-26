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

#include "promotionclusters.h"

PromotionClusters::PromotionClusters(QObject *parent) :
    QObject(parent), clusters{QVector<QVector<Promotion>>()} { }

QVector<Promotion> PromotionClusters::getPromotions(const QString &jsonText) const
{
    QVector<Promotion> promotions;
    QJsonParseError* error = nullptr;
    QJsonDocument json = QJsonDocument::fromJson(jsonText.toUtf8(), error);

    if(!json.isNull() && json.isArray())
    {
        QJsonArray jsonArr = json.array();

        for(int i = 0; i < jsonArr.count(); ++i)
        {
            /* if true - this mean, that we call from companyPage and
               promo has several coordinates, i.e. more than one store
               of current company have this promo. so we need to parse coords */
            if(jsonArr.at(i)["lat"].isArray())
            {
                QJsonArray jsonLatArr = jsonArr.at(i)["lat"].toArray();
                QJsonArray jsonLonArr = jsonArr.at(i)["lon"].toArray();

                for(int j = 0; j < jsonLatArr.size(); ++j)
                {
                    promotions.push_back(Promotion(jsonArr.at(i), jsonLatArr.at(j).toDouble(),
                                                   jsonLonArr.at(j).toDouble()));
                }
            }
            else promotions.push_back(Promotion(jsonArr.at(i)));
        }
    }
    else
    {
        if(json.isNull())
            qDebug() << "json.isNull()";
        else qDebug() << "!json.isArray()";

        if(error != nullptr)
            throw std::invalid_argument(error->errorString().toStdString());
    }

    return promotions;
}

void PromotionClusters::addToCluster(const Promotion& currProm,
                                     unsigned short minDist)
{
    //taking each cluster
    for(auto& cluster : clusters)
    {
        if(!cluster.isEmpty())
        {
            //taking pivot promotion which is the first one
            Promotion pivotProm(cluster.first());

            //if currProm overlaps the pivot prom
            if(pivotProm.distTo(currProm) < minDist)
            {
                //add currProm ass a child of current custer
                cluster.push_back(currProm);
                return;
            }
        }
    }

    /*if currProm doesn't overlaps any of pivot proms
      then create a new cluster*/
    clusters.push_back({currProm});
}

QString PromotionClusters::clustering(const QString& jsonText,
                                      quint8 zoomLevel)
{
    if(!clusters.isEmpty())
        clusters.clear();

    QVector<Promotion> promotions;
    //trying to predict amount of promotions
    promotions.reserve(jsonText.length()/200);

    /*converts zoom level (zoomLevel-8) to min distance
      between to promotions in meters*/
    static constexpr std::array<unsigned short, 12> zoomLevelToDist =
        {{ 10240, 5120, 2560, 1280, 640, 320, 160, 80, 40, 20, 10, 5 }}; // {{ }} because of clang bug
        //{{ 6400, 3200, 1600, 800, 400, 200, 100, 50, 24, 12, 6, 3 }}; // {{ }} because of clang bug
    /*if dist (in meters) between two proms are less than this
      value, they should be clusterized*/
    const unsigned short currMinDist{zoomLevelToDist.at(zoomLevel-8)};

    try {
        promotions = getPromotions(jsonText);
    } catch (const std::invalid_argument& ia) {
        return {QString{"Error: "} + ia.what()};
    }

    for(const auto& promotion : promotions)
        addToCluster(promotion, currMinDist);

    return clustersToJsonText();
}

QString PromotionClusters::clustersToJsonText() const
{
    QJsonDocument json{};
    QJsonArray jsonArray{};

    for(const auto& cluster : clusters)
    {
        if(!cluster.isEmpty())
        {
            //taking pivot promotion and making it jsonObject
            QJsonObject pjo{cluster.first().toJsonObject()};
            QJsonArray clusterChilds{};

            //taking child promotions of pivot promotion
            for(const auto& child : cluster)
                clusterChilds.append(child.toJsonObject());

            pjo.insert("childs", clusterChilds);
            jsonArray.append(pjo);
        }
    }

    json.setArray(jsonArray);
    return json.toJson(QJsonDocument::Compact);
}
