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
    enabled: Style.isConnected
    height: Style.pageHeight
    width: Style.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Style.listViewGrey
    }

    Component.onCompleted:
    {
        favouritePage.forceActiveFocus();

        //making request for favourites when getting to this page by pressing back button
        if(Style.promsResponse === '')
        {
            notifier.visible = false;
            favouritePageLoader.setSource("xmlHttpRequest.qml",
                                          { "serverUrl": 'http://patrick.ga:8080/api/user/marked?',
                                            "functionalFlag": 'user/marked'
                                         });
        }
        else if(Style.promsResponse !== '[]')
        {
            notifier.visible = false;
            var promsJSON = JSON.parse(Style.promsResponse);
            //applying promotions at ListModel
            Helper.promsJsonToListModel(promsJSON);
        }
        else notifier.visible = true;
    }

    StaticNotifier
    {
        id: notifier
        notifierText: qsTr("No favourite promotions.")
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
            width: Style.screenWidth*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            bottomPadding: Style.screenHeight*0.1
            Rectangle
            {
                id: promsItem
                height: Style.screenHeight*0.25
                width: Style.screenWidth*0.8
                radius: Style.listItemRadius
                color: "transparent"

                //rounding promotion item background image
                ImageRounder
                {
                    imageSource: picture
                    roundValue: Style.listItemRadius
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
                        //saving promotion info for further using
                        AppSettings.beginGroup("promotion");
                        AppSettings.setValue("id", id);
                        AppSettings.setValue("lat", 0.0);//CHANGE AFTER
                        AppSettings.setValue("lon", 0.0);//CHANGE AFTER
                        AppSettings.setValue("picture", picture);
                        AppSettings.setValue("title", title);
                        AppSettings.setValue("description", description);
                        AppSettings.setValue("is_marked", is_marked);
                        AppSettings.setValue("promo_code", promo_code);
                        AppSettings.setValue("store_hours", '');//CHANGE AFTER
                        AppSettings.setValue("company_id", company_id);
                        AppSettings.setValue("company_logo", company_logo);
                        AppSettings.setValue("company_name", company_name);
                        AppSettings.endGroup();

                        PageNameHolder.push("favouritePage.qml");
                        favouritePageLoader.source = "promotionPage.qml"
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
        anchors.topMargin: Helper.toDp(parent.height/20, Style.dpi)
        buttonWidth: Style.screenWidth*0.5
        buttonText: qsTr("Показать на карте")
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
