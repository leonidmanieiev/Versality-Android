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

//shows three buttons in popup
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.1
import Network 0.9

Rectangle
{
    property bool isPopupOpened: false
    // for company page because of header eats some height
    property real companyFactor: 0.0
    property real parentHeight: 0.0 + companyFactor
    property string currentPage: 'mapPage.qml'
    readonly property real popupWindowHeight: parentHeight*0.5
    readonly property int popupWindowDurat: 400
    readonly property real popupWindowOpacity: 0.8
    property real defaultButtonHeight: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)*Vars.controlHeightFactor * 0.7
    property real popupShowTo:  parentHeight - Vars.footerButtonsFieldHeight - popupWindowHeight     - companyFactor + defaultButtonHeight
    property real yToHide:      parentHeight - Vars.footerButtonsFieldHeight - popupWindowHeight*0.5 - companyFactor + defaultButtonHeight
    property real yToInvisible: parentHeight - Vars.footerButtonsFieldHeight                         - companyFactor + defaultButtonHeight

    id: popupSettingsWindow
    visible: false
    width: Vars.screenWidth
    height: popupWindowHeight
    color: Vars.mapPromsPopupColor
    anchors.horizontalCenter: parent.horizontalCenter

    //checking internet connetion
    Network { id: network }

    NumberAnimation
    {
        id: popupAnim
        property: "y"
        target: popupSettingsWindow
        duration: popupWindowDurat
    }

    function show()
    {
        popupAnim.from = Vars.screenHeight;
        popupAnim.to = popupShowTo;
        popupAnim.start();
    }

    function hide()
    {
        if(currentPage === 'appInfoPage.qml' ||
           currentPage === 'selectCategoryPage.qml' ||
           currentPage === 'profileSettingsPage.qml') {
            parent.parent.fb.showSubstrateForSettingsButton();
        }
        else if(currentPage === 'favouritePage.qml') {
            parent.parent.fb.showSubstrateForFavouriteButton();
        } else {
            parent.parent.fb.showSubstrateForHomeButton();
        }

        popupAnim.from = popupSettingsWindow.y;
        popupAnim.to = Vars.screenHeight;
        popupAnim.start();
    }

    Rectangle
    {
        id: dragerLine
        width: parent.width*0.3
        height: parent.height*0.03
        anchors.top: parent.top
        anchors.topMargin: Vars.defaultRadius*0.5
        radius: Vars.defaultRadius
        anchors.horizontalCenter: parent.horizontalCenter
        color: Vars.dragerLineColor
    }

    MouseArea
    {
        id: drager
        width: parent.width
        height: Vars.defaultRadius
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        drag.target: popupSettingsWindow
        drag.axis: Drag.YAxis
        drag.minimumY: popupShowTo
        drag.maximumY: Vars.screenHeight
    }

    onYChanged:
    {
        //set flag if entire popup shows
        if(y === popupShowTo)
        {
            isPopupOpened = true;
        }
        else if(isPopupOpened === true)
        {
            //if user swipes popup down enought to automaticly hide it
            if(y > yToHide)
            {
                hide();
            }
            //if popup hides enought to make it invisible
            if(y > yToInvisible)
            {
                popupSettingsWindow.visible = false;
                isPopupOpened = false;
            }
        }
        else if(isPopupOpened === false)
        {
            //if popup shows enought to make it visible
            if(y <= yToInvisible)
            {
                popupSettingsWindow.visible = true;
            }
        }
    }

    FontLoader
    {
        id: boldText;
        source: Vars.boldFont
    }

    ColumnLayout
    {
        id: middleFieldsColumns
        width: parent.width*0.8
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Vars.defaultRadius+dragerLine.height
        spacing: popupWindowHeight*0.04

        RowLayout
        {
            id: titleAndInfo
            width: parent.width
            height: Vars.screenHeight*0.05
            spacing: 0

            Rectangle
            {
                height: parent.height
                width:  parent.width - infoButton.width
                Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
                color: "transparent"

                CustomLabel
                {
                    id: settingsLabel
                    labelText: "Настройки профиля"
                    labelColor: Vars.whiteColor
                    anchors.left: parent.left
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Rectangle
            {
                id: infoButtonSubstrate
                height: Vars.screenHeight*0.05
                width:  Vars.screenHeight*0.05
                Layout.alignment: Qt.AlignRight
                color: "transparent"

                IconedButton
                {
                    id: infoButton
                    anchors.fill: parent
                    anchors.centerIn: parent
                    buttonIconSource: "../icons/app_info_off.svg"
                    clickArea.onClicked:
                    {
                        if(network.hasConnection())
                        {
                            toastMessage.close();
                            if(currentPage === 'profileSettingsPage.qml')
                            {
                                // this points to profileSettingsPage
                                parent.parent.parent.parent.parent.parent.saveProfileSettings('appInfoPage.qml');
                            }
                            else if(currentPage === 'selectCategoryPage.qml')
                            {
                                // save cats then open appInfoPage
                                appWindowLoader.setSource("xmlHttpRequest.qml",
                                                          {
                                                            "api": Vars.userSelectCats,
                                                            "functionalFlag": 'user/refresh-cats',
                                                            "nextPageAfterCatsSave": 'appInfoPage.qml'
                                                          });
                            } else if(currentPage === 'appInfoPage.qml') {
                                hide();
                            } else {
                                appWindowLoader.source = "appInfoPage.qml";
                            }

                            PageNameHolder.push(currentPage)
                        } else {
                            toastMessage.setTextNoAutoClose(Vars.noInternetConnection);
                        }
                    } // onClicked
                } // IconedButton
            } // infoButtonSubstrate
        } // titleAndInfo

        ControlButton
        {
            id: selectCategoryButton
            buttonHeight: fontPixelSize*Vars.controlHeightFactor*1.1
            labelText: Vars.chooseCategories
            labelColor: Vars.mapPromsPopupColor
            labelAlias.font.family: boldText.name
            labelAlias.font.bold: true
            Layout.fillWidth: true
            backgroundColor: Vars.whiteColor
            borderColor: Vars.whiteColor
            buttonRadius: 20
            buttonClickableArea.onClicked:
            {
                PageNameHolder.push(currentPage);

                if(currentPage === 'selectCategoryPage.qml') {
                    hide();
                } else if(currentPage === 'profileSettingsPage.qml') {
                    // this points to profileSettingsPage
                    parent.parent.parent.parent.saveProfileSettings('selectCategoryPage.qml');
                } else {
                    appWindowLoader.setSource("xmlHttpRequest.qml",
                                              {
                                                  "api": Vars.userInfo,
                                                  "functionalFlag": 'user',
                                                  "nextPageAfterRetrieveUserCats": 'selectCategoryPage.qml'
                                              });
                }
            }
        } // selectCategoryButton

        ControlButton
        {
            id: profileSettingsButton
            labelAlias.font.family: boldText.name
            labelAlias.font.bold: true
            buttonHeight: fontPixelSize*Vars.controlHeightFactor*0.9
            Layout.fillWidth: true
            labelText: "НАСТРОЙКИ ПРОФИЛЯ"
            labelColor: Vars.whiteColor
            backgroundColor: "transparent"
            borderColor: Vars.whiteColor
            buttonClickableArea.onClicked:
            {
                PageNameHolder.push(currentPage);

                if(currentPage === 'selectCategoryPage.qml')
                {
                    appWindowLoader.setSource("xmlHttpRequest.qml",
                                              {
                                                "api": Vars.userSelectCats,
                                                "functionalFlag": 'user/refresh-cats',
                                                "nextPageAfterCatsSave": 'profileSettingsPage.qml'
                                              });
                }
                else if(currentPage === 'profileSettingsPage.qml')
                {
                    hide();
                }
                else
                {
                    appWindowLoader.setSource("xmlHttpRequest.qml",
                                              {
                                                  "api": Vars.userInfo,
                                                  "functionalFlag": 'user'
                                              });
                }
            }
        } // profileSettingsButton

        ControlButton
        {
            id: logoutButton
            labelAlias.font.family: boldText.name
            labelAlias.font.bold: true
            buttonHeight: fontPixelSize*Vars.controlHeightFactor*0.9
            Layout.fillWidth: true
            labelText: Vars.logout
            labelColor: Vars.whiteColor
            backgroundColor: "transparent"
            borderColor: Vars.whiteColor
            buttonClickableArea.onClicked:
            {
                AppSettings.clearAllAppSettings();
                appWindowLoader.source = "initialPage.qml";
            }
        } // logoutButton
    }
}//popupSettingsWindow
