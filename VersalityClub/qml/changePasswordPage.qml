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
    id: changePassPage
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
        spacing: parent.height*0.05

        CustomTextField
        {
            id: codeField
            Layout.fillWidth: true
            setFillColor: Vars.whiteColor
            setBorderColor: Vars.purpleBorderColor
            setTextColor: Vars.purpleTextColor
            selectByMouse: false
            placeholderText: Vars.enterCode
            placeholderTextColor: Vars.purpleTextColor

            onPressed:
            {
                toastMessage.close();

                if(color === Vars.errorRed)
                {
                    text = '';
                    color = Vars.purpleTextColor;
                }
            }
        }

        CustomTextField
        {
            id: newPassField
            Layout.fillWidth: true
            setFillColor: Vars.whiteColor
            setBorderColor: Vars.purpleBorderColor
            setTextColor: Vars.purpleTextColor
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhSensitiveData
            selectByMouse: false
            placeholderText: Vars.enterNewPass
            placeholderTextColor: Vars.purpleTextColor

            onPressed:
            {
                if(color === Vars.errorRed)
                {
                    text = '';
                    color = Vars.purpleTextColor;
                }
            }
        }

        ControlButton
        {
            id: submitButton
            Layout.fillWidth: true
            labelText: Vars.submit
            labelColor: Vars.whiteColor
            backgroundColor: Vars.purpleBorderColor
            buttonClickableArea.onClicked:
            {
                // close keyboard
                Qt.inputMethod.hide();

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

        ControlBackButton
        {
            id: backButton
            Layout.topMargin: -Vars.pageHeight*0.045//0.035
            onClicked:
            {
                toastMessage.close();
                changePasswordPageLoader.source = "passwordInputPage.qml";
            }
        }
    }//middleLayout

    ToastMessage
    {
        id: toastMessage
        closePolicy: Popup.NoAutoClose
    }

    Component.onCompleted: toastMessage.setText(Vars.checkYourEmail);

    Loader
    {
        id: changePasswordPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
