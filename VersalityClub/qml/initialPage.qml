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
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import org.leonman.versalityclub 1.0

Page
{
    id: initialPage
    height: Style.screenHeight
    width: Style.screenWidth

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
                //workaround because of testing on windows and having QTBUG-68613
                if(networkInfo.networkStatus() !== 1 && Qt.platform.os !== "windows")
                    toastMessage.setTextAndRun(qsTr("Нет интернет соединение"));
                else initialPageLoader.source = "signUpPage.qml"
            }
        }

        ControlButton
        {
            id: logInButton
            Layout.fillWidth: true
            buttonText: qsTr("ВОЙТИ")
            onClicked:
            {
                //workaround because of testing on windows and having QTBUG-68613
                if(networkInfo.networkStatus() !== 1 && Qt.platform.os !== "windows")
                    toastMessage.setTextAndRun(qsTr("Нет интернет соединение"));
                else initialPageLoader.source = "logInPage.qml"
            }
        }
    }

    ToastMessage { id: toastMessage }
    NetworkInfo { id: networkInfo }

    Loader
    {
        id: initialPageLoader
        anchors.fill: parent
    }
}
