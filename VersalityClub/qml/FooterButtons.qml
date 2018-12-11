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
    height: Vars.footerButtonsFieldHeight
    width: parent.width
    anchors.bottom: parent.bottom
    color: Vars.backgroundWhite

    //footer buttons
    RowLayout
    {
        id: footerButtonsLayout
        anchors.fill: parent
        spacing: Vars.footerButtonsSpacing

        RoundButton
        {
            id: userSettingsButton
            height: Vars.footerButtonsHeight
            width: height
            Layout.alignment: Qt.AlignHCenter
            radius: height/2
            opacity: pressed ? Vars.defaultOpacity : 1
            text: "S"
            onClicked:
            {
                PageNameHolder.push(pressedFromPageName);
                appWindowLoader.setSource("xmlHttpRequest.qml",
                                          { "api": Vars.userInfo,
                                            "functionalFlag": 'user'
                                          });
            }
        }

        RoundButton
        {
            id: mainButton
            height: Vars.footerButtonsHeight
            width: height
            Layout.alignment: Qt.AlignHCenter
            radius: height/2
            opacity: pressed ? Vars.defaultOpacity : 1
            text: "M"
            onClicked: appWindowLoader.setSource("mapPage.qml");
            //need to clear data for getting fresh one
            Component.onCompleted: Vars.allPromsData = '';
        }

        RoundButton
        {
            id: favouritesButton
            height: Vars.footerButtonsHeight
            width: height
            Layout.alignment: Qt.AlignHCenter
            radius: height/2
            opacity: pressed ? Vars.defaultOpacity : 1
            text: "F"
            onClicked:
            {
                if(pressedFromPageName !== "favouritePage.qml")
                    PageNameHolder.push(pressedFromPageName);

                appWindowLoader.setSource("xmlHttpRequest.qml",
                                          { "api": Vars.userMarkedProms,
                                            "functionalFlag": 'user/marked'
                                          });
            }
        }
    }//RowLayout

    Loader
    {
        id: footerButtonsLoader
        asynchronous: true
        height: Vars.screenHeight
        width: Vars.screenWidth
        anchors.bottom: parent.bottom
        visible: status == Loader.Ready
    }
}
