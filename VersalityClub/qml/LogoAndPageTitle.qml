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

//logo and page title footer
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

RowLayout
{
    property bool showInfoButton: false
    property bool infoClicked: false
    property string pageTitleText

    id: logoAndPageTitle
    anchors.top: parent.top
    height: Vars.screenHeight*0.15
    width: Vars.screenWidth

    Image
    {
        id: logo
        clip: true
        source: "../icons/logo_white_fill.png"
        Layout.preferredWidth: Vars.screenHeight*0.1
        Layout.preferredHeight: Vars.screenHeight*0.1
        Layout.alignment: Qt.AlignRight
    }

    FontLoader
    {
        id: boldText;
        source: Vars.boldFont
    }

    Label
    {
        id: pageTitle
        text: pageTitleText
        color: Vars.backgroundWhite
        height: Vars.screenHeight*0.1
        Layout.alignment: Qt.AlignHCenter
        font.family: boldText.name
        font.bold: true
        font.pixelSize: Helper.toDp(14, Vars.dpi)
    }

    Rectangle
    {
        id: infoButtonField
        visible: showInfoButton
        width: Vars.screenHeight*0.065
        height: Vars.screenHeight*0.065
        Layout.alignment: Qt.AlignTop
        Layout.topMargin: parent.height*0.25
        Layout.rightMargin: parent.height*0.25
        radius: height*0.5
        color: infoClicked ? Vars.backgroundWhite : "transparent"

        IconedButton
        {
            id: infoButton
            width: Vars.screenHeight*0.05
            height: Vars.screenHeight*0.05
            anchors.centerIn: parent
            buttonIconSource: infoClicked ? "../icons/app_info_on.png" :
                                            "../icons/app_info_off.png"
            clickArea.onClicked:
            {
                if(infoClicked)
                {
                    appWindowLoader.source = "profileSettingsPage.qml";
                    infoClicked = false;
                }
                else
                {
                    appWindowLoader.source = "appInfoPage.qml";
                    PageNameHolder.push("profileSettingsPage.qml")
                    infoClicked = true;
                }
            }
        }
    }
}
