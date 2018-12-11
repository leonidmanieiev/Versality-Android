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

import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    //for pass encryption
    readonly property string xorStr: "8fdda158eeb8c0ed9d151991aff3c84c"

    id: passInputPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    ColumnLayout
    {
        id: middleLayout
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        Label
        {
            id: passLabel
            clip: true
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            text: Vars.pass
            font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                        Vars.dpi)
            color: Vars.mainPurple
        }

        TextField
        {
            id: passField
            implicitWidth: parent.width*0.9
            horizontalAlignment: Text.AlignHCenter
            Layout.alignment: Qt.AlignHCenter
            background: ControlBackground { }
            font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                        Vars.dpi)
            color: Vars.backgroundBlack
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            selectByMouse: false
        }

        ControlButton
        {
            id: enterButton
            padding: middleLayout.spacing*2
            Layout.fillWidth: true
            buttonText: Vars.login
            labelContentColor: Vars.backgroundWhite
            backgroundColor: Vars.mainPurple
            onClicked:
            {
                var encryptedPass = Helper.encryptPassword(passField.text,
                                                           xorStr);
                AppSettings.beginGroup("user");
                AppSettings.setValue("password", encryptedPass);
                AppSettings.endGroup();
                passwordInputPageLoader.setSource("xmlHttpRequest.qml",
                                                  { "api": Vars.userLogin,
                                                    "functionalFlag": 'login'
                                                  });
            }
        }
    }//ColumnLayout

    ToastMessage { id: toastMessage }

    Loader
    {
        id: passwordInputPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
