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
            color: Vars.fontsPurple
        }

        CustomTextField
        {
            id: passField
            Layout.fillWidth: true
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.fontsPurple
            setTextColor: Vars.backgroundBlack
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            selectByMouse: false

            onPressed:
            {
                if(color === Vars.errorRed)
                {
                    text = '';
                    color = Vars.backgroundBlack;
                }
            }
        }

        ControlButton
        {
            id: enterButton
            //padding: middleLayout.spacing*2
            Layout.fillWidth: true
            labelText: Vars.login
            labelColor: Vars.backgroundWhite
            backgroundColor: Vars.fontsPurple
            buttonClickableArea.onClicked:
            {
                AppSettings.beginGroup("user");
                AppSettings.setValue("password", passField.text);
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
