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
    id: changePassPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/init_page_bg.png"
    }

    Image
    {
        id: header_logo_full
        clip: true
        source: "../icons/logo_full.png"
        width: parent.width
        height: parent.height*0.06
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.1
        fillMode: Image.PreserveAspectFit
    }

    Image
    {
        id: footer_logo
        clip: true
        source: "../icons/logo.png"
        width: parent.width
        height: parent.height*0.15
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.08
        fillMode: Image.PreserveAspectFit
    }

    ColumnLayout
    {
        id: middleLayout
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.05

        CustomTextField
        {
            id: codeField
            Layout.fillWidth: true
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.fontsPurple
            setTextColor: Vars.backgroundBlack
            selectByMouse: false
            placeholderText: Vars.enterCode
            placeholderTextColor: Vars.fontsPurple

            onPressed:
            {
                if(color === Vars.errorRed)
                {
                    text = '';
                    color = Vars.backgroundBlack;
                }
            }
        }

        CustomTextField
        {
            id: newPassField
            Layout.fillWidth: true
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.fontsPurple
            setTextColor: Vars.backgroundBlack
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            selectByMouse: false
            placeholderText: Vars.enterNewPass
            placeholderTextColor: Vars.fontsPurple

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
            id: submitButton
            Layout.fillWidth: true
            labelText: Vars.submit
            labelColor: Vars.backgroundWhite
            backgroundColor: Vars.fontsPurple
            buttonClickableArea.onClicked:
            {
                AppSettings.beginGroup("user");
                AppSettings.setValue("password", newPassField.text);
                AppSettings.endGroup();
                changePasswordPageLoader.setSource("xmlHttpRequest.qml",
                                                  { "api": Vars.userChangePass,
                                                    "functionalFlag": 'user/set-pass',
                                                    "code": codeField.text
                                                  });
            }
        }
    }//ColumnLayout

    ToastMessage { id: toastMessage }

    Loader
    {
        id: changePasswordPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
