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

//full info about promotion
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtPositioning 5.8

Page
{
    function forceUpdateUserCoords()
    {
        promotionPageLoader.setSource("userLocation.qml",
                    {"callFromPageName": 'promotionPage'});
    }

    id: promotionPage
    enabled: Style.isConnected
    height: Style.pageHeight
    width: Style.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

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
        contentHeight: middleFieldsColumns.height*1.1
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            spacing: Style.screenHeight*0.05

            Rectangle
            {
                id: promsImage
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
                    font.pixelSize: Helper.toDp(13, Style.dpi)
                    color: Style.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }

            RowLayout
            {
                id: rowLayout1
                width: parent.width
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.screenWidth*0.1

                ControlButton
                {
                    id: activeCoupon
                    setWidth: Style.screenWidth*0.6
                    buttonText: qsTr("АКТИВИРОВАТЬ КУПОН")
                    labelContentColor: Style.backgroundWhite
                    backgroundColor: Style.activeCouponColor
                    setBorderColor: "transparent"
                    onClicked:
                    {
                        forceUpdateUserCoords();

                        if(closeEnough())
                        {
                            promoCodePopup.setText(AppSettings.value("promotion/promo_code"));
                            //inform server about coupon was activated
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"serverUrl": 'http://patrick.ga:8080/api/user/activate?',
                                                           "functionalFlag": "user/activate"});
                        }
                        else toastMessage.setTextAndRun(qsTr("Get closer to promotoion"));
                    }
                    function closeEnough()
                    {
                        var promPos = QtPositioning.coordinate(AppSettings.value("promotion/lat"),
                                                               AppSettings.value("promotion/lon"));
                        var userPos = QtPositioning.coordinate(AppSettings.value("user/lat"),
                                                               AppSettings.value("user/lon"));
                        return promPos.distanceTo(userPos) < Style.promCloseDist;
                    }
                }

                ControlButton
                {
                    id: addToFavourite
                    setWidth: setHeight
                    buttonText: qsTr("AtF")
                    labelContentColor: Style.backgroundWhite
                    backgroundColor: AppSettings.value("promotion/is_marked") ?
                                   Style.activeCouponColor : Style.listViewGrey
                    setBorderColor: "transparent"
                    checkable: true
                    checked: AppSettings.value("promotion/is_marked")
                    onClicked:
                    {
                        if(checked)
                        {
                            AppSettings.beginGroup("promotion");
                            AppSettings.setValue("is_marked", true);
                            AppSettings.endGroup();

                            backgroundColor = Style.activeCouponColor;
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"serverUrl": 'http://patrick.ga:8080/api/user/mark?',
                                                           "functionalFlag": "user/mark"});
                        }
                        else
                        {
                            AppSettings.beginGroup("promotion");
                            AppSettings.setValue("is_marked", false);
                            AppSettings.endGroup();

                            backgroundColor = Style.listViewGrey;
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"serverUrl": 'http://patrick.ga:8080/api/user/unmark?',
                                                           "functionalFlag": "user/unmark"});
                        }
                    }
                }//ControlButton
            }//RowLayout

            RowLayout
            {
                id: rowLayout2
                width: Style.screenWidth*0.8
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.screenWidth*0.05

                Rectangle
                {
                    id: companyLogo
                    height: Style.screenWidth*0.16
                    width: height
                    radius: height*0.5
                    color: "transparent"

                    //rounding company logo item background image
                    ImageRounder
                    {
                        imageSource: AppSettings.value("promotion/company_logo")
                        roundValue: parent.height*0.5
                    }
                }

                Rectangle
                {
                    id: textBox
                    width: Style.screenWidth*0.6
                    height: Style.screenWidth*0.15
                    Layout.alignment: Qt.AlignHCenter
                    color: Style.listViewGrey

                    Label
                    {
                        id: nameAndHours
                        topPadding: Helper.toDp(7, Style.dpi)
                        text: AppSettings.value("promotion/company_name")+'\n'
                              +Helper.currStoreHours(AppSettings.value("promotion/store_hours"))
                        font.pixelSize: Helper.toDp(13, Style.dpi)
                        color: Style.backgroundBlack
                    }
                }
            }//RowLayout

            ControlButton
            {
                id: nearestStoreButton
                Layout.fillWidth: true
                buttonText: qsTr("БЛИЖАЙШИЙ КО МНЕ АДРЕС")
                labelContentColor: Style.mainPurple
                backgroundColor: Style.backgroundWhite
                setBorderColor: Style.mainPurple
                Layout.alignment: Qt.AlignHCenter
                //onClicked:
            }

            ControlButton
            {
                id: companyCardButton
                Layout.fillWidth: true
                buttonText: qsTr("ОТКРЫТЬ КАРТОЧКУ КОМПАНИИ")
                labelContentColor: Style.backgroundBlack
                backgroundColor: Style.backgroundWhite
                setBorderColor: Style.backgroundBlack
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Style.screenHeight*0.03
                onClicked:
                {
                    PageNameHolder.push("promotionPage.qml");
                    promotionPageLoader.source = "companyPage.qml";
                }
            }
        }//ColumnLayout
    }//Flickable

    ToastMessage
    {
        id: promoCodePopup
        backgroundColor: Style.mainPurple
        y: Style.screenHeight*0.5
    }

    ToastMessage { id: toastMessage }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Style.dpi)
        buttonWidth: Style.screenWidth*0.55
        buttonText: qsTr("Назад к выбору акций")
        onClicked: promotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'promotionPage.qml' }

    Component.onCompleted:
    {
        promotionPage.forceActiveFocus();
        forceUpdateUserCoords();
    }

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
            else promotionPageLoader.source = pageName;

            //to avoid not loading bug
            promotionPageLoader.reload();
        }
    }

    Loader
    {
        id: promotionPageLoader
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
