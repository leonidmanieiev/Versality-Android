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
    id: favouritePage
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
        favouritePage.forceActiveFocus();

        //making request for favourites when getting to this page by pressing back button
        if(Vars.markedPromsData === '')
        {
            notifier.visible = false;
            favouritePageLoader.setSource("xmlHttpRequest.qml",
                                          { "api": Vars.userMarkedProms,
                                            "functionalFlag": 'user/marked'
                                         });
        }
        else if(Vars.markedPromsData !== '[]')
        {
            notifier.visible = false;
            var promsJSON = JSON.parse(Vars.markedPromsData);
            //applying promotions at ListModel
            Helper.promsJsonToListModel(promsJSON);
        }
        else notifier.visible = true;
    }

    StaticNotifier
    {
        id: notifier
        notifierText: Vars.noFavouriteProms
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
            else favouritePageLoader.source = pageName;

            //to avoid not loading bug
            favouritePageLoader.reload();
        }
    }

    ToastMessage { id: toastMessage }

    ListView
    {
        id: promsListView
        clip: true
        anchors.top: parent.top
        width: parent.width
        height: parent.height
        contentHeight: promsDelegate.height*1.3
        model: promsModel
        delegate: promsDelegate
    }

    ListModel { id: promsModel }

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
                        imageSource: 'https://fonsports.ru/wp-content/uploads/2018/07/logo-rpl.jpg'//company_logo
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
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Vars.dpi)
        buttonWidth: Vars.screenWidth*0.5
        buttonText: Vars.showOnMap
        onClicked: favouritePageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'favouritePage.qml' }

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
