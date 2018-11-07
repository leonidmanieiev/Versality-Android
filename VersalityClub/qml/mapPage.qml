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
    readonly property string mapCopyright: 'Tiles style by <a href="http://corp.sputnik.ru/maps"'
                                           +' style="color: '+Style.mainPurple+'">Cпутник</a> © '
                                           +'<a href="https://www.rt.ru/" style="color: '+
                                           Style.mainPurple+'">Ростелеком</a>'
    readonly property string mapDataCopyright: ' Data © <a href="https://www.openstreetmap.org/'
                                               +'copyright" style="color: '+Style.mainPurple+'">'
                                               +'OpenStreetMap</a>'

    id: mapPage
    enabled: Style.isConnected
    height: Style.pageHeight
    width: Style.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    Map
    {
        id: mainMap
        anchors.fill: parent
        width: Style.screenWidth
        anchors.bottomMargin: Style.footerButtonsFieldHeight
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

        MapQuickItem
        {
            id: userLocationMarker
            visible: false
            anchorPoint.x: userMarkerImage.width*0.5
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
                anchorPoint.x: promMarkersImage.width*0.5
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
                        //saving promotion info for further using
                        AppSettings.beginGroup("promotion");
                        AppSettings.setValue("id", id);
                        AppSettings.setValue("lat", lat);
                        AppSettings.setValue("lon", lon);
                        AppSettings.setValue("picture", picture);
                        AppSettings.setValue("title", title);
                        AppSettings.setValue("description", description);
                        AppSettings.setValue("is_marked", is_marked);
                        AppSettings.setValue("promo_code", promo_code);
                        AppSettings.setValue("store_hours", store_hours);
                        AppSettings.setValue("company_id", company_id);
                        AppSettings.setValue("company_logo", company_logo);
                        AppSettings.setValue("company_name", company_name);
                        AppSettings.endGroup();

                        PageNameHolder.push("mapPage.qml");
                        mapPageLoader.source = "previewPromotionPage.qml";
                    }
                }
            }//delegate: MapQuickItem
        }//MapItemView
    }//Map

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
            mainMap.center = QtPositioning.coordinate(AppSettings.value("user/lat"),
                                                      AppSettings.value("user/lon"));
            mainMap.zoomLevel = 16;
            userLocationMarker.coordinate = mainMap.center;
            userLocationMarker.visible = true;
        }
    }

    Rectangle
    {
        id: copyrightTextBackground
        width: childrenRect.width
        height: childrenRect.height
        anchors.left: parent.left
        anchors.bottom: footerButton.top
        color: Style.copyrightBackgroundColor

        Text
        {
            id: copyrightText
            color: Style.backgroundWhite
            textFormat: Text.RichText;
            text: mapCopyright+mapDataCopyright
            font.pixelSize: Helper.toDp(15, Style.dpi)
            onLinkActivated: Qt.openUrlExternally(link)
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

    FooterButtons { id: footerButton; pressedFromPageName: "mapPage.qml" }

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
        if(Style.promsResponse.substring(0, 6) !== 'PROM-1')
        {
            notifier.visible = false;
            var promsJSON = JSON.parse(Style.promsResponse);
            //applying promotions at ListModel
            Helper.promsJsonToListModelForMap(promsJSON);
        }
        else notifier.visible = true;
    }

    StaticNotifier
    {
        id: notifier
        notifierText: qsTr("No suitable promotions nearby.")
    }

    ToastMessage { id: toastMessage }

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
            event.accepted = true;
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
