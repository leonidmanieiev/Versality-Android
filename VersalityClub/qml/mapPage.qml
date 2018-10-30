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
import QtWebView 1.1
import QtQuick.Controls 2.4

Page
{
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

    WebView
    {
        id: myMap
        anchors.fill: parent
        Component.onCompleted: myMap.loadHtml(Style.mapHTML);
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
        mapPageLoader.source = "userLocation.qml"
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
