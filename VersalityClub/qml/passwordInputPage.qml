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

import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    property bool fromRegistration: false

    id: passInputPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

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
        source: "../icons/logo_full.svg"
        sourceSize.width: parent.width*0.40
        sourceSize.height: parent.width*0.08
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.09
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image
    {
        id: footer_logo
        clip: true
        source: "../icons/logo.svg"
        sourceSize.width: parent.width*0.25
        sourceSize.height: parent.width*0.25
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.08
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    ColumnLayout
    {
        id: middleLayout
        width: parent.width*0.8
        anchors.centerIn: parent
        spacing: parent.height*0.03

        CustomTextField
        {
            id: passField
            Layout.fillWidth: true
            setFillColor: Vars.whiteColor
            setBorderColor: Vars.purpleBorderColor
            setTextColor: Vars.purpleTextColor
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            selectByMouse: false
            placeholderText: Vars.enterYourPass
            placeholderTextColor: Vars.purpleTextColor

            onPressed:
            {
                noAutoCloseToastMessage.close();

                if(color === Vars.errorRed)
                {
                    text = '';
                    color = Vars.purpleTextColor;
                }
            }
        }

        ControlButton
        {
            id: enterButton
            Layout.fillWidth: true
            labelText: Vars.login
            labelColor: Vars.whiteColor
            backgroundColor: Vars.purpleBorderColor
            buttonClickableArea.onClicked:
            {
                // close keyboard
                Qt.inputMethod.hide();

                // if true -> we are on almostDonePage
                if(PageNameHolder.empty())
                {
                    passField.selectByMouse = false;
                    passField.readOnly = true;
                }

                AppSettings.beginGroup("user");
                AppSettings.setValue("password", passField.text);
                AppSettings.endGroup();
                passwordInputPageLoader.setSource("xmlHttpRequest.qml",
                                                  { "api": Vars.userLogin,
                                                    "functionalFlag": 'login'});
            }
        }

        ControlButton
        {
            id: forgerPassButton
            Layout.fillWidth: true
            labelText: Vars.forgetPass
            labelColor: Vars.whiteColor
            backgroundColor: Vars.forgetPassPurple
            borderColor: Vars.forgetPassPurple
            buttonClickableArea.onClicked:
            {
                // close keyboard
                Qt.inputMethod.hide();

                noAutoCloseToastMessage.close();

                passwordInputPageLoader.setSource("xmlHttpRequest.qml",
                                                  { "api": Vars.userResetPass,
                                                    "functionalFlag": 'user/reset-pass'
                                                  });
            }
        }

        ControlBackButton
        {
            id: backButton
            Layout.topMargin: -Vars.pageHeight*0.03//0.02
            onClicked:
            {
                noAutoCloseToastMessage.close();
                passwordInputPageLoader.source = "logInPage.qml";
            }
        }
    }//middleLayout

    ToastMessage
    {
        id: noAutoCloseToastMessage
        closePolicy: Popup.NoAutoClose
    }

    Component.onCompleted: if(fromRegistration) noAutoCloseToastMessage.setText(Vars.checkYourEmail);

    Loader
    {
        id: passwordInputPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
