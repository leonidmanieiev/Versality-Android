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
    property string serverUrl: 'http://patrick.ga:8080/api/promotions?'
    property string secret: UserSettings.value("user_security/user_hash")
    property real lat: UserSettings.value("user_data/lat")
    property real lon: UserSettings.value("user_data/lon")
    readonly property real footerButtonsHeight: Style.screenWidth*0.1
    readonly property real footerButtonsSpacing: Style.screenWidth*0.05

    id: mapPage
    height: Style.screenHeight
    width: Style.screenWidth

    //request promotion info
    function xhr()
    {
        var request = new XMLHttpRequest();
        var params = 'secret='+secret+'&lat='+lat+'&lon='+lon;

        request.open('POST', serverUrl);

        request.onreadystatechange = function()
        {
            if(request.readyState === XMLHttpRequest.DONE)
            {
                if(request.status === 200)
                    promotionsInfo.text = request.responseText;
                else toastMessage.setTextAndRun(qsTr("HTTP error: " + request.status +
                                                     ". Проверьте интернет соединение"));
            }
            else console.log("Pending: " + request.readyState);
        }

        request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.send(params);
    }

    ToastMessage { id: toastMessage }

    background: Rectangle
    {
        id: background
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
                onClicked: mapPageLoader.setSource("xmlHttpRequest.qml",
                                                   { "serverUrl": 'http://patrick.ga:8080/api/user/info?',
                                                     "functionalFlag": 'user/info'
                                                   }
                                                  );
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


    Loader
    {
        id: mapPageLoader
        anchors.fill: parent
    }
}
