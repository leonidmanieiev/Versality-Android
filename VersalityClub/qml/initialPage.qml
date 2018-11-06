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

//sign up and log in buttons page
import "../"
import Network 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    id: initialPage
    enabled: Style.isConnected
    height: Style.screenHeight
    width: Style.screenWidth

    //checking internet connetion
    NetworkInfo
    {
        onNetworkStatusChanged:
        {
            if(accessible === 1)
            {
                Style.isConnected = true;
                initialPage.enabled = true;
                toastMessage.setTextAndRun(qsTr("Internet re-established"));
            }
            else
            {
                Style.isConnected = false;
                initialPage.enabled = false;
                toastMessage.setTextAndRun(qsTr("No Internet connection"));
            }
        }
    }

    ColumnLayout
    {
        id: middleButtonsColumn
        spacing: Style.screenHeight*0.07
        width: parent.width*0.8
        anchors.centerIn: parent

        ControlButton
        {
            id: signUpButton
            Layout.fillWidth: true
            buttonText: qsTr("ЗАРЕГИСТРИРОВАТЬСЯ")
            onClicked:
            {
                PageNameHolder.push("initialPage.qml");
                initialPageLoader.source = "signUpPage.qml";
            }
        }

        ControlButton
        {
            id: logInButton
            Layout.fillWidth: true
            buttonText: qsTr("ВОЙТИ")
            onClicked:
            {
                PageNameHolder.push("initialPage.qml");
                initialPageLoader.source = "logInPage.qml";
            }
        }
    }//ColumnLayout

    ToastMessage { id: toastMessage }

    Loader
    {
        id: initialPageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }

    //setting active focus for key capturing
    Component.onCompleted: initialPage.forceActiveFocus()

    Keys.onReleased:
    {
        //back button pressed for android and windows
        if (event.key === Qt.Key_Back || event.key === Qt.Key_B)
        {
            event.accepted = true;
            var pageName = PageNameHolder.pop();

            if(pageName === "")
                appWindow.close();
            else initialPageLoader.source = pageName;

            //to avoid not loading bug
            initialPageLoader.reload();
        }
    }
}
