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
import QtQuick.Controls 2.4

Page
{
    property string promResp: ''

    id: mapPage
    height: Style.screenHeight
    width: Style.screenWidth

    background: Rectangle
    {
        id: background
        anchors.fill: parent
        color: "YELLOW"
    }

    Image
    {
        id: remoteImage
        width: parent.width
        height: parent.height * 0.5
        anchors.top: parent.top
        fillMode: Image.PreserveAspectFit
        source: "https://cosmeticlik.ru/wp-content/uploads/2017/06/icon_2.png";
        onStatusChanged: console.log("Loading image status: " + status)
    }

    ScrollView
    {
        id: scrollViewOfTextArea
        height: parent.height * 0.5
        width: parent.width
        contentHeight: promotionsInfo.text.length
        contentWidth: parent.width
        anchors.bottom: parent.bottom

        TextArea
        {
            id: promotionsInfo
            width: parent.width
            height: parent.height * 0.5
            anchors.fill: parent
            text: promResp
            wrapMode: Text.WordWrap
        }
    }

    Loader
    {
        id: mapPageLoader
        anchors.fill: parent
    }

    Component.onCompleted: console.log("Promotion info: " + promResp);
}
