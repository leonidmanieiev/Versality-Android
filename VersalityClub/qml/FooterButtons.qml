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

//footer buttons
import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

//footer color fill
Rectangle
{
    property string pressedFromPageName: ''

    id: rowLayoutBackground
    height: Style.footerButtonsFieldHeight
    width: parent.width
    anchors.bottom: parent.bottom
    color: Style.backgroundWhite

    //footer buttons
    RowLayout
    {
        id: footerButtonsLayout
        anchors.fill: parent
        spacing: Style.footerButtonsSpacing

        RoundButton
        {
            id: userSettingsButton
            height: Style.footerButtonsHeight
            width: height
            Layout.alignment: Qt.AlignHCenter
            radius: height/2
            opacity: pressed ? 0.8 : 1
            text: "S"
            onClicked:
            {
                PageNameHolder.push(pressedFromPageName);
                appWindowLoader.setSource("xmlHttpRequest.qml",
                                          { "serverUrl": 'http://patrick.ga:8080/api/user/info?',
                                            "functionalFlag": 'user/info'
                                          });
            }
        }

        RoundButton
        {
            id: mainButton
            height: Style.footerButtonsHeight
            width: height
            Layout.alignment: Qt.AlignHCenter
            radius: height/2
            opacity: pressed ? 0.8 : 1
            text: "M"
            onClicked: footerButtonsLoader.source = "mapPage.qml";
        }

        RoundButton
        {
            id: favouritesButton
            height: Style.footerButtonsHeight
            width: height
            Layout.alignment: Qt.AlignHCenter
            radius: height/2
            opacity: pressed ? 0.8 : 1
            text: "F"
            onClicked:
            {
                if(pressedFromPageName != "favouritePage.qml")
                    PageNameHolder.push(pressedFromPageName);

                footerButtonsLoader.source = "favouritePage.qml";
            }
        }
    }

    Loader
    {
        id: footerButtonsLoader
        asynchronous: true
        height: Style.screenHeight
        width: Style.screenWidth
        anchors.bottom: parent.bottom
        visible: status == Loader.Ready
    }
}