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
        id: regularText;
        source: Vars.regularFont
    }

    Rectangle
    {
        id: middleItem
        width: parent.width
        height: Vars.screenHeight*0.5
        anchors.centerIn: parent
        color: "transparent"

        IconedButton
        {
            id: leftArrowButton
            z: 1
            width: parent.width*0.08
            height: parent.width*0.08
            anchors.left: parent.left
            anchors.leftMargin: parent.width*0.05
            anchors.verticalCenter: parent.verticalCenter
            buttonIconSource: "../icons/left_arrow.svg"
            clickArea.onClicked: swipeView.decrementCurrentIndex()
        }

        SwipeView
        {
            id: swipeView
            z: -1
            currentIndex: 0
            width: parent.width
            height: parent.height
            anchors.top: parent.top
            anchors.topMargin: Vars.screenHeight * 0.1
            anchors.horizontalCenter: parent.horizontalCenter

            HelpComponent
            {
                id: firstHelpPage
                helpText: Vars.firstHelpText
                helpImageSource: "../icons/settings_help.svg"
            }

            HelpComponent
            {
                id: secondHelpPage
                helpText: Vars.secondHelpText
                helpImageSource: "../icons/logo_gradient.svg"
            }

            HelpComponent
            {
                id: thirdHelpPage
                helpText: Vars.thirdHelpText
                helpImageSource: "../icons/favourites_help.svg"
            }
        }//swipeView

        IconedButton
        {
            id: rightArrowButton
            z: 1
            rotateAngle: 180
            width: parent.width*0.08
            height: parent.width*0.08
            anchors.right: parent.right
            anchors.rightMargin: parent.width*0.05
            anchors.verticalCenter: parent.verticalCenter
            buttonIconSource: "../icons/left_arrow.svg"
            clickArea.onClicked: swipeView.incrementCurrentIndex()
        }

        PageIndicator
        {
            id: swipePageIndicator
            count: swipeView.count
            currentIndex: swipeView.currentIndex
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter

            delegate: Rectangle
            {
                id: dot
                implicitWidth:  Vars.screenHeight*0.03
                implicitHeight: Vars.screenHeight*0.03
                radius: width*0.5
                color: index === swipeView.currentIndex ?
                           Vars.purpleTextColor : "transparent"

                Rectangle
                {
                    id: subDot
                    visible: index !== swipeView.currentIndex
                    implicitWidth:  Vars.screenHeight*0.015
                    implicitHeight: Vars.screenHeight*0.015
                    radius: width*0.5
                    color: Vars.whiteColor
                    anchors.centerIn: parent
                }
            }
        }//swipePageIndicator
    }//middleItem

    ControlButton
    {
        id: startUsingAppButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height/14
        anchors.horizontalCenter: parent.horizontalCenter
        labelText: Vars.everythingIsClearStart
        labelColor: Vars.whiteColor
        backgroundColor: "transparent"
        borderColor: Vars.whiteColor
        buttonClickableArea.onClicked:
        {
            // to do not show user some help info about app (he already saw it)
            Vars.fromSignUp = false;
            almostDonePageLoader.setSource("xmlHttpRequest.qml",
                                     { "api": Vars.userInfo,
                                       "functionalFlag": 'user',
                                       "requestFromADP": true
                                     });
        }
    }

    Component.onCompleted: PageNameHolder.clear()

    Loader
    {
        id: almostDonePageLoader
        asynchronous: true
        anchors.fill: parent
        visible: status == Loader.Ready
    }
}
