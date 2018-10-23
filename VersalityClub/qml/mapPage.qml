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
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.4

Page
{
    readonly property real footerButtonsHeight: Style.screenWidth*0.1
    readonly property real footerButtonsSpacing: Style.screenWidth*0.05

    id: mapPage
    height: Style.screenHeight
    width: Style.screenWidth

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Style.mainPurple
    }

    //footer color fill
    Rectangle
    {
        id: rowLayoutBackground
        height: parent.height*0.125
        width: parent.width
        anchors.bottom: parent.bottom
        color: Style.backgroundWhite

        //footer buttons
        RowLayout
        {
            id: footerButtonsLayout
            anchors.fill: parent
            spacing: footerButtonsSpacing

            RoundButton
            {
                id: userSettingsButton
                height: footerButtonsHeight
                width: height
                Layout.alignment: Qt.AlignHCenter
                radius: height/2
                text: "S"
                onClicked:
                {
                    PageNameHolder.push("mapPage.qml");
                    mapPageLoader.setSource("xmlHttpRequest.qml",
                                            { "serverUrl": 'http://patrick.ga:8080/api/user/info?',
                                              "functionalFlag": 'user/info'
                                            });
                }
            }

            RoundButton
            {
                id: mainButton
                height: footerButtonsHeight
                width: height
                Layout.alignment: Qt.AlignHCenter
                radius: height/2
                text: "M"
            }

            RoundButton
            {
                id: favouritesButton
                height: footerButtonsHeight
                width: height
                Layout.alignment: Qt.AlignHCenter
                radius: height/2
                text: "F"
            }
        }
    }

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

            if(pageName === "")
                appWindow.close();
            else mapPageLoader.source = pageName;

            mapPageLoader.reload();
        }
    }

    Loader
    {
        id: mapPageLoader
        anchors.fill: parent

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }
}
