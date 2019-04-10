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

//favourites promotions in list view
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

Page
{
    property bool allGood: false
    readonly property int promItemHeight: Vars.screenHeight*0.25

    id: favouritePage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    background: Rectangle
    {
        id: backgroundColor
        anchors.fill: parent
        color: Vars.backgroundWhite
    }

    Component.onCompleted:
    {
        favouritePage.forceActiveFocus();

        //making request for favourites when getting to this page by pressing back button
        if(Vars.markedPromsData === '')
        {
            notifier.visible = false;
            favouritePageLoader.setSource("xmlHttpRequest.qml",
                                          { "api": Vars.userMarkedProms,
                                            "functionalFlag": 'user/marked',
                                            "isTilesApi": false});
        }
        else if(Vars.markedPromsData !== '[]')
        {
            try {
                var promsJSON = JSON.parse(Vars.markedPromsData);
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
            notifier.notifierText = Vars.noFavouriteProms;
            notifier.visible = true;
        }
    }

    StaticNotifier { id: notifier }

    ToastMessage { id: toastMessage }

    ListView
    {
        id: promsListView
        visible: allGood
        clip: true
        anchors.top: parent.top
        width: parent.width
        height: parent.height*0.9
        contentHeight: promItemHeight*3
        model: promsModel
        delegate: promsDelegate
    }

    ListModel { id: promsModel }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        source: "../backgrounds/map_f.png"
    }

    Image
    {
        id: background2
        clip: true
        anchors.fill: parent
        source: "../backgrounds/listview_hf.png"
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
                height: promItemHeight
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
                        PageNameHolder.push("previewPromotionPage.qml");
                        favouritePageLoader.setSource("xmlHttpRequest.qml",
                                                { "api": Vars.promFullViewModel,
                                                  "functionalFlag": 'user/fullprom',
                                                  "promo_id": id,
                                                  "promo_desc": description
                                                });
                    }
                }//MouseArea
            }//Rectangle
        }//Column
    }//Component

    //switch to mapPage (proms on map view)
    TopControlButton
    {
        id: showOnMapButton
        buttonWidth: Vars.screenWidth*0.47
        buttonText: Vars.showOnMap
        buttonIconSource: "../icons/on_map.png"
        iconAlias.width: height*0.56
        iconAlias.height: height*0.7
        onClicked: favouritePageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'favouritePage.qml' }

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
            else favouritePageLoader.source = pageName;

            //to avoid not loading bug
            favouritePageLoader.reload();
        }
    }

    Loader
    {
        id: favouritePageLoader
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
