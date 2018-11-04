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

//main page in map view
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQml 2.11
import QtWebView 1.1
import QtQuick.Controls 2.4
import QtLocation 5.9
import QtPositioning 5.8

Page
{
    readonly property int defaultZoomLevel: 11
    readonly property real defaultLat: 59.933284
    readonly property real defaultLon: 30.343614
    readonly property string tilesHost: "http://tiles.maps.sputnik.ru/"
    readonly property string mapCopyright: "<a href='http://corp.sputnik.ru/maps'>Cпутник</a>"
                                           +" © <a href='https://www.rt.ru/'>Ростелеком</a>"
    readonly property string mapDataCopyright: "<a href='https://www.openstreetmap.org/copyright'>"
                                           +"OpenStreetMap</a>"

    id: mapPage
    height: Style.pageHeight
    width: Style.screenWidth
    anchors.top: parent.top

    background: Rectangle
    {
        id: pageBackground
        height: Style.pageHeight
        width: Style.screenWidth
        color: Style.backgroundWhite
    }

    Map
    {
        id: mainMap
        anchors.fill: parent
        center: QtPositioning.coordinate(defaultLat, defaultLon)
        zoomLevel: defaultZoomLevel
        plugin: Plugin
        {
            name: "osm"
            PluginParameter
            {
                id: param
                name: "osm.mapping.custom.host"
                value: tilesHost
            }
            PluginParameter
            {
                name: "osm.mapping.highdpi_tiles"
                value: "true"
            }
            PluginParameter
            {
                name: "osm.mapping.custom.mapcopyright"
                value: mapCopyright
            }
            PluginParameter
            {
                name: "osm.mapping.custom.datacopyright"
                value: mapDataCopyright
            }
            PluginParameter
            {
                name: "osm.useragent"
                value: "VersalityClub"
            }
        }
        //necessary to display custom tiles
        Component.onCompleted:
        {
            for(var i_type in supportedMapTypes)
                if(supportedMapTypes[i_type].name.localeCompare("Custom URL Map") === 0)
                    activeMapType = supportedMapTypes[i_type];
        }
        onCopyrightLinkActivated: Qt.openUrlExternally(link)

        MapQuickItem
        {
            id: userLocationMarker
            visible: false
            anchorPoint.x: userMarkerImage.width/2
            anchorPoint.y: userMarkerImage.height
            sourceItem: Image
            {
                id: userMarkerImage
                source: "../icons/userLocationMarkerIcon.svg"
                sourceSize.width: Style.mapButtonSize
                sourceSize.height: Style.mapButtonSize
            }
        }


        //displays multiple promotion marks
        MapItemView
        {
            id: promMarkersView
            model: promMarkersModel
            delegate: MapQuickItem
            {
                id: promMarkersDelegate
                //wait until get coords
                visible: lat ? true : false
                anchorPoint.x: promMarkersImage.width/2
                anchorPoint.y: promMarkersImage.height
                coordinate: QtPositioning.coordinate(lat, lon)
                sourceItem: Image
                {
                    id: promMarkersImage
                    source: "../icons/promotionMarkerIcon.svg"
                    sourceSize.width: Style.mapButtonSize
                    sourceSize.height: Style.mapButtonSize
                }

                //show promotion preview after click on mark
                MouseArea
                {
                    id: clickableArea
                    anchors.fill: parent
                    onClicked:
                    {
                        PageNameHolder.push("mapPage.qml");
                        mapPageLoader.setSource("previewPromotionPage.qml",
                                               {"p_id": id,
                                                "p_lat": lat,
                                                "p_lon": lon,
                                                "p_picture": picture,
                                                "p_title": title,
                                                "p_description": description,
                                                "p_is_marked": is_marked,
                                                "p_promo_code": promo_code,
                                                "p_store_hours": store_hours,
                                                "p_company_id": company_id,
                                                "p_company_logo": company_logo,
                                                "p_company_name": company_name
                                               });
                    }
                }
            }

        }
    }

    ListModel { id: promMarkersModel }

    RoundButton
    {
        id: userLocationButton
        opacity: pressed ? 0.8 : 1
        icon.height: Style.mapButtonSize
        icon.width: Style.mapButtonSize
        icon.color: "transparent"
        icon.source: "../icons/geoLocationIcon.svg"
        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: parent.width*0.02
        background: Rectangle
        {
            id: buttonBackground
            anchors.fill: parent
            radius: parent.radius
            color: "transparent"
            border.color: "transparent"
        }
        onClicked:
        {
            mainMap.center = QtPositioning.coordinate(UserSettings.value("user_data/lat"),
                                                      UserSettings.value("user_data/lon"));
            mainMap.zoomLevel = 16;
            userLocationMarker.coordinate = mainMap.center;
            userLocationMarker.visible = true;
        }
    }


    //switch to listViewPage (proms as list)
    TopControlButton
    {
        id: showInListViewButton
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Style.dpi)
        buttonWidth: Style.screenWidth*0.6
        buttonText: qsTr("Показать в виде списка")
        onClicked:
        {
            PageNameHolder.push("mapPage.qml");
            mapPageLoader.source = "listViewPage.qml";
        }
    }

    FooterButtons { pressedFromPageName: "mapPage.qml" }

    Component.onCompleted:
    {
        PageNameHolder.clear();
        //setting active focus for key capturing
        mapPage.forceActiveFocus();
        //start capturing user location and getting promotions
        mapPageLoader.source = "userLocation.qml";
    }

    function runParsing()
    {
        var promsJSON = JSON.parse(Style.promsResponse);
        //applying promotions at ListModel
        Helper.promsJsonToListModelForMap(promsJSON);
    }

    //workaround to wait until server sends pasponse
    Timer
    {
        id: waitForResponse
        running: Style.promsResponse === '' ? false : true
        interval: 1
        onTriggered: runParsing()
    }

    Keys.onReleased:
    {
        //back button pressed for android and windows
        if (event.key === Qt.Key_Back || event.key === Qt.Key_B)
        {
            event.accepted = true
            var pageName = PageNameHolder.pop();

            //if no pages in sequence
            if(pageName === "")
                appWindow.close();
            else mapPageLoader.source = pageName;

            //to avoid not loading bug
            mapPageLoader.reload();
        }
    }

    Loader
    {
        id: mapPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }
}
