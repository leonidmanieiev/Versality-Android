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
    property string currComp: "firstComp"

    function nextLeftHelp()
    {
        if(currComp === "secondComp")
        {
            currComp = "firstComp";
            return firstComp
        }

        currComp = "secondComp";
        return secondComp
    }

    function nextRightHelp()
    {
        if(currComp === "firstComp")
        {
            currComp = "secondComp";
            return secondComp
        }

        currComp = "thirdComp";
        return thirdComp
    }

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

        RowLayout
        {
            id: btnViewBtn
            width: parent.width*0.9
            height: Vars.screenHeight*0.5
            anchors.centerIn: parent

            IconedButton
            {
                id: leftArrowButton
                width: parent.width*0.1
                height: parent.width*0.1
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: parent.height*0.22
                buttonIconSource: "../icons/left_arrow.png"
                clickArea.onClicked:
                {
                    if(currComp !== "firstComp")
                        stackView.push(nextLeftHelp());
                }
            }

            StackView
            {
                id: stackView
                initialItem: firstComp
                width: Vars.screenWidth*0.54
                height: Vars.screenHeight*0.5
                Layout.alignment: Qt.AlignHCenter

                Component
                {
                    id: firstComp

                    HelpComponent
                    {
                        id: firstHelpComp
                        helpText: Vars.firstHelpText
                        helpImageSource: "../icons/settings_help.png"
                    }
                }

                Component
                {
                    id: secondComp

                    HelpComponent
                    {
                        id: secondHelpComp
                        helpText: Vars.secondHelpText
                        helpImageSource: "../icons/logo_gradient.png"
                    }
                }

                Component
                {
                    id: thirdComp

                    HelpComponent
                    {
                        id: thirdHelpComp
                        helpText: Vars.thirdHelpText
                        helpImageSource: "../icons/favourites_help.png"
                    }
                }
            }//stackView

            IconedButton
            {
                id: rightArrowButton
                width: parent.width*0.1
                height: parent.width*0.1
                rotateAngle: 180
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: parent.height*0.22
                buttonIconSource: "../icons/left_arrow.png"
                clickArea.onClicked:
                {
                    if(currComp !== "thirdComp")
                        stackView.push(nextRightHelp());
                }
            }
        }//btnViewBtn
    }//middleItem


    ControlButton
    {
        id: startUsingAppButton
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Helper.toDp(parent.height/14, Vars.dpi)
        anchors.horizontalCenter: parent.horizontalCenter
        labelText: Vars.everythingIsClearStart
        labelColor: Vars.backgroundWhite
        backgroundColor: "transparent"
        borderColor: Vars.backgroundWhite
        buttonClickableArea.onClicked:
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
