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

//main page in list view
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

Page
{
    property bool allGood: false

    id: listViewPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Vars.listViewGrey
    }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        listViewPage.forceActiveFocus();
        //start capturing user location and getting promotions
        listViewPageLoader.setSource("userLocation.qml",
                                     {"callFromPageName": 'listViewPage',
                                      "api": Vars.allPromsListViewModel,
                                      "isTilesApi": false});
    }

    function runParsing()
    {
        if(Vars.allUniquePromsData.substring(0, 6) !== 'PROM-1'
           && Vars.allUniquePromsData.substring(0, 6) !== '[]')
        {
            try {
                var promsJSON = JSON.parse(Vars.allUniquePromsData);
                allGood = true;
                notifier.visible = false;
                //applying promotions at list model
                Helper.promsJsonToListModel(promsJSON);
            } catch (e) {
                allGood = false;
                notifier.notifierText = Vars.smthWentWrong;
                notifier.visible = true;
            }
        }
        else
        {
            notifier.notifierText = Vars.noSuitablePromsNearby;
            notifier.visible = true;
        }
    }

    StaticNotifier { id: notifier }

    ToastMessage { id: toastMessage }

    Timer
    {
        id: waitForResponse
        running: Vars.allUniquePromsData === '' ? false : true
        interval: 1
        onTriggered: runParsing()
    }

    ListView
    {
        id: promsListView
        visible: allGood
        clip: true
        width: Vars.screenWidth
        height: Vars.screenHeight
        contentHeight: promsDelegate.height
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        model: ListModel { id: promsModel }
        delegate: promsDelegate
    }

    Component
    {
        id: promsDelegate
        Column
        {
            width: Vars.screenWidth*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: Vars.screenHeight*0.1
            Rectangle
            {
                id: promsItem
                height: Vars.screenHeight*0.25
                width: Vars.screenWidth*0.8
                radius: Vars.listItemRadius
                color: "transparent"

                //rounding promotion item background image
                ImageRounder
                {
                    imageSource: picture
                    roundValue: Vars.listItemRadius
                }

                Rectangle
                {
                    id: companyLogoItem
                    height: parent.width*0.2
                    width: height
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: -height*0.5
                    radius: height*0.5
                    color: "transparent"

                    //rounding company logo item background image
                    ImageRounder
                    {
                        imageSource: company_logo
                        roundValue: parent.height*0.5
                    }
                }

                //on promotion clicked
                MouseArea
                {
                    id: promsClickableArea
                    anchors.fill: parent
                    onClicked:
                    {
                        PageNameHolder.push("listViewPage.qml");
                        listViewPageLoader.setSource("xmlHttpRequest.qml",
                                                { "api": Vars.promFullViewModel,
                                                  "functionalFlag": 'user/fullprom',
                                                  "promo_id": id,
                                                  "promo_desc": description
                                                });
                    }
                }
            }//Rectangle
        }//Column
    }//Component

    //switch to mapPage (proms on map view)
    TopControlButton
    {
        id: showOnMapButton
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Vars.dpi)
        buttonWidth: Vars.screenWidth*0.5
        buttonText: Vars.showOnMap
        onClicked: listViewPageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'listViewPage.qml' }

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
            else listViewPageLoader.source = pageName;

            //to avoid not loading bug
            listViewPageLoader.reload();
        }
    }

    Loader
    {
        id: listViewPageLoader
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
