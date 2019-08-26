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

//main page in map view
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQml 2.11
import QtWebView 1.1
import QtQuick.Controls 2.4
import QtLocation 5.9
import QtPositioning 5.12
import QtQuick.Layouts 1.3
//import OneSignal 1.0
import CppMethodCall 0.9
import Network 0.9
import EnableLocation 0.9

Page
{
    property bool locButtClicked: false
    property real defaultZoomLevel: 11
    readonly property int minZoomLevel: 8
    readonly property int maxZoomLevel: 19
    property real defaultLat: 59.933284
    property real defaultLon: 30.343614
    property real userLat: AppSettings.value("user/lat") === undefined ? 0.0 : AppSettings.value("user/lat")
    property real userLon: AppSettings.value("user/lon") === undefined ? 0.0 : AppSettings.value("user/lon")
    property bool allGood: false
    property bool requestFromCompany: false
    property string pressedFrom: requestFromCompany ? 'companyPage.qml' : 'mapPage.qml'
    readonly property string tilesHost: "http://tiles.maps.sputnik.ru/"
    readonly property string mapCopyright: 'Tiles style by <a href="http://corp.sputnik.ru/maps"'
                                           +' style="color: '+Vars.purpleTextColor+'">Cпутник</a> © '
                                           +'<a href="https://www.rt.ru/" style="color: '+
                                           Vars.purpleTextColor+'">Ростелеком</a>'
    readonly property string mapDataCopyright: ' Data © <a href="https://www.openstreetmap.org/'
                                               +'copyright" style="color: '+Vars.purpleTextColor+'">'
                                               +'OpenStreetMap</a>'
    readonly property int markerSize: Vars.screenWidth*0.15
    readonly property int fromButtonZoomLevel: 16
    readonly property int promsTilesItemHeight: popupWindow.height/3

    //popup window vars
    property bool isPopupOpened: false
    readonly property int popupWindowHeight: height*0.3
    readonly property int popupWindowDurat: 400
    readonly property real popupWindowOpacity: 0.8
    readonly property int popupShowTo: height-Vars.footerButtonsFieldHeight-popupWindowHeight*0.9
    readonly property int yToHide: height-Vars.footerButtonsFieldHeight-popupWindowHeight/2
    readonly property int yToInvisible: height-Vars.footerButtonsFieldHeight

    //nearest store vars
    property bool showingNearestStore: false
    property string nearestPromId: ''
    property string nearestPromIcon: ''

    //alias
    property alias shp: settingsHelperPopup
    property alias fb: footerButton

    function setUserLocationMarker(lat, lon, _zoomLevel, follow)
    {
        if(locButtClicked)
        {
            console.log("setUserLocationMarker");
            userLocationMarker.coordinate = QtPositioning.coordinate(lat, lon);
            userLocationMarker.visible = true;

            if(follow) mainMap.center = userLocationMarker.coordinate;

            if(_zoomLevel !== 0) mainMap.zoomLevel = _zoomLevel;
        }
    }

    //clusterization and model appling
    function clusterizeAndApply()
    {
        //clusterization accounding to current zoom level
        var jsonFromServer =
                requestFromCompany ? JSON.stringify(AppSettings.value("company/promos")) : Vars.allPromsData;

        var clustersTextJson =
                PromotionClusters.clustering(jsonFromServer, mainMap.zoomLevel);

        // clusterization was unsuccessful
        // check console log
        if(clustersTextJson.substring(0, 5) === "Error")
        {
            allGood = false;
            notifier.notifierText = Vars.smthWentWrong;
            notifier.visible = true;
            //console.log("Parsing response " + clustersTextJson);
        }

        try {
            var promsJSON = JSON.parse(clustersTextJson);
            allGood = true;
            notifier.visible = false;
            //applying promotions at markers model
            Helper.promsJsonToListModelForMarkers(promsJSON);
        } catch (e) {
            allGood = false;
            notifier.notifierText = Vars.smthWentWrong;
            notifier.visible = true;
            console.log("Parsing response error");
        }
    }

    //apply only nearest promotion to model
    function applyNearestPromOnly()
    {
        allGood = true;
        promsMarkersModel.append({
                                    "id": nearestPromId,
                                    "icon": nearestPromIcon,
                                    "lat": defaultLat,
                                    "lon": defaultLon,
                                    "childs": [],
                                    "cntOfChilds": 0
                                });
    }

    id: mapPage
    enabled: Vars.isConnected
    height: requestFromCompany ? Vars.companyPageHeight : Vars.pageHeight
    width: Vars.screenWidth

    StaticNotifier { id: notifier }

    ToastMessage { id: toastMessage }

    Network { id: network }

    FontLoader
    {
        id: regulatText
        source: Vars.regularFont
    }

    FontLoader
    {
        id: boldText
        source: Vars.boldFont
    }

    Map
    {
        id: mainMap
        minimumZoomLevel: minZoomLevel
        maximumZoomLevel: maxZoomLevel
        anchors.fill: parent
        width: Vars.screenWidth
        anchors.bottomMargin: Vars.footerButtonsFieldHeight
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
            anchorPoint.x: userMarkerIcon.width*0.5
            anchorPoint.y: userMarkerIcon.height
            sourceItem: Image
            {
                id: userMarkerIcon
                source: "../icons/user_location_marker_icon.svg"
                sourceSize.width: markerSize*0.6
                sourceSize.height: markerSize*1.05
            }
        }

        //displays multiple promotion markers
        MapItemView
        {
            id: promMarkersView
            model: ListModel { id: promsMarkersModel }
            delegate: MapQuickItem
            {
                id: promMarkersDelegate
                //wait until get coords
                visible: allGood && lat
                anchorPoint.x: markerSize*0.5
                anchorPoint.y: markerSize
                coordinate: QtPositioning.coordinate(lat, lon)
                sourceItem: Loader {
                    sourceComponent: cntOfChilds > 1 ? clusterMarker : promotionMarker
                }

                Component
                {
                    id: clusterMarker
                    ClusterMarker
                    {
                        height: markerSize
                        width: markerSize
                        amountOfChilds: cntOfChilds
                    }
                }

                Component
                {
                    id: promotionMarker
                    PromotionMarker
                    {
                        iconId: icon
                        sourceSize.height: markerSize
                        sourceSize.width: markerSize
                    }
                }

                //show promotion preview after click on mark
                MouseArea
                {
                    id: clickableMarkerArea
                    anchors.fill: parent
                    onClicked:
                    {
                        if(cntOfChilds > 1)
                        {
                            promsTilesListView.model = childs;
                            popupWindow.show();
                        }
                        else
                        {
                            PageNameHolder.push(pressedFrom);

                            AppSettings.beginGroup("promo");
                            AppSettings.setValue("id", id);
                            AppSettings.endGroup();

                            if(requestFromCompany)
                            {
                                appWindowLoader.setSource("xmlHttpRequest.qml",
                                                        { "api": Vars.promPreViewModel,
                                                          "functionalFlag": 'user/preprom'
                                                        });
                            }
                            else
                            {
                                mapPageLoader.setSource("xmlHttpRequest.qml",
                                                        { "api": Vars.promPreViewModel,
                                                          "functionalFlag": 'user/preprom'
                                                        });
                            }
                        }
                    }
                }
            }//promMarkersDelegate
        }//promMarkersView

        onZoomLevelChanged:
        {
            if(!showingNearestStore)
            {
                //check if server responded
                if(Vars.allPromsData.length > 0)
                    clusterizeAndApply()
                else if(requestFromCompany)
                    clusterizeAndApply()
            }
        }
    }//mainMap

    Rectangle
    {
        id: copyrightTextBackground
        radius: Vars.defaultRadius
        width: copyrightText.width*1.05
        height: copyrightText.height
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: footerButton.top
        color: Vars.copyrightBackgroundColor

        Text
        {
            id: copyrightText
            anchors.centerIn: parent
            color: Vars.blackColor
            textFormat: Text.RichText;
            text: mapCopyright+mapDataCopyright
            font.pixelSize: Helper.applyDpr(5, Vars.dpr)
            font.family: regulatText.name
            onLinkActivated: Qt.openUrlExternally(link)
        }
    }//copyrightTextBackground

    Rectangle
    {
        id: popupWindow
        visible: false
        width: parent.width
        height: popupWindowHeight
        color: Vars.mapPromsPopupColor
        anchors.horizontalCenter: parent.horizontalCenter

        NumberAnimation
        {
            id: popupAnim
            target: popupWindow
            property: "y"
            duration: popupWindowDurat
        }

        function show()
        {
            popupAnim.from = Vars.screenHeight;
            popupAnim.to = popupShowTo;
            popupAnim.start();
        }

        function hide()
        {
            popupAnim.from = popupWindow.y;
            popupAnim.to = Vars.screenHeight;
            popupAnim.start();
        }

        Rectangle
        {
            id: dragerLine
            width: parent.width*0.3
            height: parent.height*0.05
            anchors.top: parent.top
            anchors.topMargin: Vars.defaultRadius*0.5
            radius: Vars.defaultRadius
            anchors.horizontalCenter: parent.horizontalCenter
            color: Vars.dragerLineColor
        }

        MouseArea
        {
            id: drager
            width: parent.width
            height: Vars.defaultRadius
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            drag.target: popupWindow
            drag.axis: Drag.YAxis
            drag.minimumY: popupShowTo
            drag.maximumY: Vars.screenHeight
        }

        onYChanged:
        {
            //set flag if entire popup shows
            if(y === popupShowTo)
            {
                isPopupOpened = true;
            }
            else if(isPopupOpened === true)
            {
                //if user swipes popup down enought to automaticly hide it
                if(y > yToHide)
                {
                    hide();
                }
                //if popup hides enought to make it invisible
                if(y > yToInvisible)
                {
                    popupWindow.visible = false;
                    isPopupOpened = false;
                }
            }
            else if(isPopupOpened === false)
            {
                //if popup shows enought to make it visible
                if(y <= yToInvisible)
                {
                    popupWindow.visible = true;
                }
            }
        }

        ListView
        {
            id: promsTilesListView
            clip: true
            width: parent.width
            height: parent.height*0.75
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Vars.defaultRadius + parent.height*0.05
            contentHeight: promsTilesItemHeight
            delegate: promsTilesDelegate
        }
    }//popupWindow

    Component
    {
        id: promsTilesDelegate
        Column
        {
            id: column
            width: popupWindow.width
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: markerSize*0.15
            Rectangle
            {
                id: parentCategoryIcon
                height: markerSize
                width: parent.width
                color: Vars.mapPromsPopupColor
                anchors.horizontalCenter: parent.horizontalCenter

                Image
                {
                    id: icon
                    smooth: true
                    antialiasing: true
                    source: "../icons/cat_"+cicon+".svg"
                    sourceSize.width: markerSize*0.6
                    sourceSize.height: markerSize*0.6
                    anchors.left: parent.left
                    anchors.leftMargin: parent.width*0.09
                    anchors.verticalCenter: parent.verticalCenter
                }

                Label
                {
                    id: promotionTitle
                    anchors.left: icon.right
                    anchors.leftMargin: icon.width*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    text: ctitle
                    font.pixelSize: Helper.applyDpr(9, Vars.dpr)
                    font.family: boldText.name
                    color: Vars.whiteColor
                }

                MouseArea
                {
                    id: promsTilesClickableArea
                    anchors.fill: parent
                    onClicked:
                    {
                        PageNameHolder.push(pressedFrom);
                        AppSettings.beginGroup("promo");
                        AppSettings.setValue("id", cid);
                        AppSettings.endGroup();
                        if(requestFromCompany)
                        {
                            appWindowLoader.setSource("xmlHttpRequest.qml",
                                                    { "api": Vars.promPreViewModel,
                                                      "functionalFlag": 'user/preprom'
                                                      });
                        }
                        else
                        {
                            mapPageLoader.setSource("xmlHttpRequest.qml",
                                                    { "api": Vars.promPreViewModel,
                                                      "functionalFlag": 'user/preprom'
                                                      });
                        }
                    }
                }
            }//parentCategoryIcon
        }//column
    }//promsTilesDelegate

    // to show user location when asked
    PositionSource
    {
        id: mapPositionSource
        active: false
        updateInterval: 1

        onSourceErrorChanged:
        {
            switch(sourceError)
            {
                case PositionSource.AccessError:
                    // hz kogda eto emititsja
                    locButtClicked = false;
                    mapPositionSource.stop();
                    console.log(Vars.noLocationPrivileges); break;
                case PositionSource.ClosedError:
                    // lication is off
                    locButtClicked = false;
                    mapPositionSource.stop();
                    console.log(Vars.turnOnLocationAndWait); break;
                case PositionSource.UnknownSourceError:
                    // no permission
                    locButtClicked = false;
                    mapPositionSource.stop();
                    console.log(Vars.unknownPosSrcErr); break;
                default: break;
            }
        }
    }

    //wait for user location to trigger
    Timer
    {
        id: waitForUserLocation
        running: !showingNearestStore &&
                 (!isNaN(mapPositionSource.position.coordinate.latitude) ||
                  AppSettings.value("user/lat") !== undefined)
        interval: 1
        onTriggered: saveUserLocationAndShowIcon()
    }

    function saveUserLocationAndShowIcon()
    {
        console.log("saveUserLocationAndShowIcon");
        var userLat = AppSettings.value("user/lat");
        var userLon = AppSettings.value("user/lon");

        if(!isNaN(mapPositionSource.position.coordinate.latitude)) {
            userLat = mapPositionSource.position.coordinate.latitude;
            userLon = mapPositionSource.position.coordinate.longitude;

            AppSettings.beginGroup("user");
            AppSettings.setValue("lat", userLat);
            AppSettings.setValue("lon", userLon);
            AppSettings.endGroup();
        }

        if(locButtClicked)
        {
            setUserLocationMarker(userLat, userLon, fromButtonZoomLevel, true)
            // user has seen his location, know we can stop getting updates
            mapPositionSource.stop();
            waitForUserLocation.running = false;
        }
    }

    IconedButton
    {
        id: geoLocationButton
        enabled: true
        width: Vars.footerButtonsHeight*0.9
        height: Vars.footerButtonsHeight*0.9
        buttonIconSource: "../icons/geo_location.svg"
        anchors.right: parent.right
        anchors.rightMargin: parent.width*0.02
        anchors.verticalCenter: parent.verticalCenter
        clickArea.onClicked:
        {
            if(EnableLocation.askEnableLocation())
            {
                console.log("askEnableLocation === true");
                locButtClicked = true;
                mapPositionSource.start();

                // force saveUserLocationAndShowIcon
                // because positionUpdate can be waited for too long
                if(!isNaN(mapPositionSource.position.coordinate.latitude) ||
                   AppSettings.value("user/lat") !== undefined) {
                    saveUserLocationAndShowIcon();
                }
            }
            else
            {
                console.log("askEnableLocation === false");
                mapPositionSource.stop();
            }
        }
    }

    // this thing does not allow to select/deselect subcat,
    // when it is under the settingsHelperPopup
    Rectangle
    {
        id: settingsHelperPopupStopper
        enabled: settingsHelperPopup.isPopupOpened
        width: parent.width
        height: settingsHelperPopup.height
        anchors.bottom: footerButton.top
        color: "transparent"

        MouseArea
        {
            anchors.fill: parent
            onClicked: settingsHelperPopupStopper.forceActiveFocus()
        }
    }

    SettingsHelperPopup
    {
        id: settingsHelperPopup
        currentPage: pressedFrom
        parentHeight: parent.height
    }

    //switch to listViewPage (proms as list) if does not came
    //from companyPage or promotionPage
    TopControlButton
    {
        id: showInListViewButton
        visible: (requestFromCompany || showingNearestStore) ? false : true
        buttonText: Vars.showListView
        buttonIconSource: "../icons/show_listview.svg"
        onClicked:
        {
            if(network.hasConnection())
            {
                toastMessage.close();
                PageNameHolder.push(pressedFrom);
                mapPageLoader.source = "listViewPage.qml";
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    //switch back to promotion if came from promotionPage
    //by clicked on 'show nearest store'
    TopControlButton
    {
        id: showPromotionButton
        visible: showingNearestStore ? true : false
        buttonText: Vars.backToPromotion
        buttonIconSource: "../icons/left_arrow.svg"
        iconAlias.sourceSize.width: height*0.5
        iconAlias.sourceSize.height: height*0.4
        onClicked:
        {
            if(network.hasConnection())
            {
                toastMessage.close();
                var pageName = PageNameHolder.pop();

                //if no pages in sequence
                if(pageName === "")
                    appWindow.close();
                else mapPageLoader.source = pageName;

                //to avoid not loading bug
                //mapPageLoader.reload();
            }
            else
            {
                toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
            }
        }
    }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: footerButton.bottom
        source: "../backgrounds/map_f.png"
    }

    FooterButtons
    {
        id: footerButton
        pressedFromPageName: pressedFrom
        Component.onCompleted: showSubstrateForHomeButton()
    }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        mapPage.forceActiveFocus();

        if(!requestFromCompany)
        {
            if(!showingNearestStore)
            {
                PageNameHolder.clear();
            }
            else
            {
                mainMap.center = QtPositioning.coordinate(defaultLat, defaultLon);
                setUserLocationMarker(userLat, userLon, defaultZoomLevel, false);
            }

            //start capturing user location and getting all promotions
            mapPageLoader.source = "userLocation.qml";
        }
    }

    function runParsing()
    {
        //QOneSignal.sendTag("hash", AppSettings.value("user/hash"));
        CppMethodCall.saveHashToFile();

        if(showingNearestStore)
        {
            applyNearestPromOnly();
        }
        else if((Vars.allPromsData.substring(0, 6) !== 'PROM-1'
                 && Vars.allPromsData.substring(0, 6) !== '[]')
                 || requestFromCompany)
        {
            clusterizeAndApply();
        }
        else
        {
            notifier.notifierText = Vars.noSuitablePromsNearby;
            notifier.visible = true;
        }
    }

    //workaround to wait until server sends pasponse
    Timer
    {
        id: waitForResponse
        running:
        {
            if(requestFromCompany || showingNearestStore)
                true;
            else Vars.allPromsData === '' ? false : true
        }
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

            if(requestFromCompany)
                appWindowLoader.source = "promotionPage.qml";
            else
            {
                //if no pages in sequence
                if(pageName === "")
                    appWindow.close();
                else mapPageLoader.source = pageName;

                //to avoid not loading bug
                mapPageLoader.reload();
            }
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
