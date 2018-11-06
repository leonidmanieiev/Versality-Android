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

//preview of promotion
import "../"
import "../js/helpFunc.js" as Helper
import Network 1.0
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    id: previewPromPage
    enabled: Style.isConnected
    height: Style.pageHeight
    width: Style.screenWidth

    //checking internet connetion
    NetworkInfo
    {
        onNetworkStatusChanged:
        {
            if(accessible === 1)
            {
                Style.isConnected = true;
                previewPromPage.enabled = true;
                toastMessage.setTextAndRun(qsTr("Internet re-established"));
            }
            else
            {
                Style.isConnected = false;
                previewPromPage.enabled = false;
                toastMessage.setTextAndRun(qsTr("No Internet connection"));
            }
        }
    }

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Style.listViewGrey
    }

    Flickable
    {
        id: flickableArea
        clip: true
        width: Style.screenWidth
        height: Style.screenHeight
        contentHeight: middleFieldsColumns.height*1.05
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            spacing: Style.screenHeight*0.05

            Button
            {
                id: favouriteIndicator
                Layout.topMargin: parent.spacing*0.5
                Layout.alignment: Qt.AlignHCenter
                width: Style.screenWidth*0.16
                height: width
                text: qsTr("AtF")
                background: Rectangle
                {
                    id: buttonBackground
                    implicitWidth: parent.width
                    implicitHeight: parent.height
                    radius: Style.listItemRadius
                    color: AppSettings.value("promotion/is_marked") ?
                               Style.errorRed : Style.backgroundWhite
                }
                checkable: true
                checked: AppSettings.value("promotion/is_marked")
                onClicked:
                {
                    if(checked)
                    {
                        AppSettings.beginGroup("promotion");
                        AppSettings.setValue("is_marked", true);
                        AppSettings.endGroup();

                        buttonBackground.color = Style.activeCouponColor;
                        previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                            {"serverUrl": 'http://patrick.ga:8080/api/user/mark?',
                                                             "functionalFlag": "user/mark"});
                    }
                    else
                    {
                        AppSettings.beginGroup("promotion");
                        AppSettings.setValue("is_marked", false);
                        AppSettings.endGroup();

                        buttonBackground.color = Style.listViewGrey;
                        previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                            {"serverUrl": 'http://patrick.ga:8080/api/user/unmark?',
                                                             "functionalFlag": "user/unmark"});
                    }
                }
            }//Button

            Rectangle
            {
                id: promsImage
                Layout.topMargin: parent.spacing*3
                Layout.alignment: Qt.AlignHCenter
                height: Style.screenHeight*0.25
                width: Style.screenWidth*0.8
                radius: Style.listItemRadius
                color: "transparent"

                //rounding promotion image
                ImageRounder
                {
                    imageSource: AppSettings.value("promotion/picture")
                    roundValue: Style.listItemRadius
                }
            }

            Label
            {
                id: promotionTitle
                text: AppSettings.value("promotion/title")
                font.pixelSize: Helper.toDp(16, Style.dpi)
                font.bold: true
                color: Style.backgroundBlack
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle
            {
                id: textArea
                width: promsImage.width
                height: promotionDescription.height
                Layout.alignment: Qt.AlignHCenter
                color: Style.listViewGrey

                Label
                {
                    id: promotionDescription
                    width: parent.width
                    text: AppSettings.value("promotion/description")
                    maximumLineCount: 3
                    font.pixelSize: Helper.toDp(13, Style.dpi)
                    color: Style.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }

            ControlButton
            {
                id: moreButton
                Layout.fillWidth: true
                buttonText: qsTr("ПОДРОБНЕЕ")
                labelContentColor: Style.mainPurple
                backgroundColor: Style.backgroundWhite
                setBorderColor: Style.mainPurple
                Layout.alignment: Qt.AlignHCenter
                onClicked:
                {
                    PageNameHolder.push("previewPromotionPage.qml");
                    previewPromotionPageLoader.source = "promotionPage.qml";
                }
            }//ControlButton
        }//ColumnLayout
    }//Flickable

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: Style.screenWidth*0.25
        buttonWidth: Style.screenWidth*0.55
        buttonText: qsTr("Назад к выбору акций")
        onClicked: previewPromotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'previewPromotionPage.qml' }

    Component.onCompleted: previewPromPage.forceActiveFocus()

    Keys.onReleased:
    {
        //back button pressed for android and windows
        if (event.key === Qt.Key_Back || event.key === Qt.Key_B)
        {
            event.accepted = true;
            var pageName = PageNameHolder.pop();

            //if no pages in sequence
            if(pageName === "")
                appWindow.close();
            else previewPromotionPageLoader.source = pageName;

            //to avoid not loading bug
            previewPromotionPageLoader.reload();
        }
    }

    Loader
    {
        id: previewPromotionPageLoader
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
}
