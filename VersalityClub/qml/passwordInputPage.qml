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
            id: passField
            Layout.fillWidth: true
            setFillColor: Vars.backgroundWhite
            setBorderColor: Vars.fontsPurple
            setTextColor: Vars.backgroundBlack
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            selectByMouse: false
            placeholderText: Vars.enterYourPass
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

        ControlButton
        {
            id: forgerPassButton
            Layout.fillWidth: true
            labelText: Vars.forgetPass
            labelColor: Vars.backgroundWhite
            backgroundColor: Vars.forgetPassPurple
            borderColor: Vars.forgetPassPurple
            buttonClickableArea.onClicked:
            {
                passwordInputPageLoader.setSource("xmlHttpRequest.qml",
                                                  { "api": Vars.userResetPass,
                                                    "functionalFlag": 'user/reset-pass'
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
