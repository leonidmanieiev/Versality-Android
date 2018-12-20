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

//page where app tells how to use itself
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    id: almostDonePage
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
        source: "../backgrounds/almost_done_bg.png"
    }

    LogoAndPageTitle { pageTitleText: Vars.almostDone }

    FontLoader
    {
        id: mediumText;
        source: "../fonts/Qanelas_Medium.ttf"
    }

    ControlButton
    {
        id: startUsingAppButton
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Helper.toDp(parent.height/14, Vars.dpi)
        buttonText: Vars.everythingIsClearStart
        labelContentColor: Vars.backgroundWhite
        backgroundColor: "transparent"
        setBorderColor: Vars.backgroundWhite
        onClicked:
        {
            almostDonePageLoader.setSource("xmlHttpRequest.qml",
                                     { "api": Vars.userInfo,
                                       "functionalFlag": 'user'
                                     });
        }
    }

    ToastMessage { id: toastMessage }

    Component.onCompleted: PageNameHolder.clear()

    Loader
    {
        id: almostDonePageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
