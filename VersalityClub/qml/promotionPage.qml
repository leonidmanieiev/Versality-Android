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
    property string p_id: ''
    property real p_lat: 0.0
    property real p_lon: 0.0
    property string p_title: ''
    property string p_picture: ''
    property string p_description: ''
    property bool p_is_marked: false
    property string p_store_hours: ''
    property string p_promo_code: ''
    property string p_company_id: ''
    property string p_company_name: ''
    property string p_company_logo: ''

    id: promPage
    height: Style.pageHeight
    width: Style.screenWidth
    anchors.top: appWindow.top

    background: Rectangle
    {
        id: pageBackground
        height: Style.pageHeight
        width: Style.screenWidth
        color: Style.listViewGrey
    }

    Flickable
    {
        id: flickableArea
        clip: true
        width: Style.screenWidth
        height: Style.pageHeight
        boundsBehavior: Flickable.DragOverBounds
        contentHeight: middleFieldsColumns.height*1.05

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
                    imageSource: p_picture
                    roundValue: Style.listItemRadius
                }
            }

            Label
            {
                id: promotionTitle
                text: p_title
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
                    text: p_description
                    font.pixelSize: Helper.toDp(13, Style.dpi)
                    color: Style.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }

            RowLayout
            {
                id: rowLayout1
                width: Style.screenWidth*0.8
                Layout.alignment: Qt.AlignHCenter
                spacing: Style.screenWidth*0.1

                ControlButton
                {
                    id: activeCoupon
                    enabled: closeEnough() ? true : false
                    opacity: enabled ? 1 : 0.8
                    setWidth: Style.screenWidth*0.6
                    buttonText: qsTr("АКТИВИРОВАТЬ КУПОН")
                    labelContentColor: Style.backgroundWhite
                    backgroundColor: Style.activeCouponColor
                    setBorderColor: "transparent"
                    onClicked: promoCodePopup.setText(p_promo_code);

                    function closeEnough()
                    {
                        var promPos = QtPositioning.coordinate(p_lat, p_lon);
                        var userPos = QtPositioning.coordinate(UserSettings.value("user_data/lat"),
                                                               UserSettings.value("user_data/lon"));
                        return promPos.distanceTo(userPos) < Style.promCloseDist;
                    }
                }

                ControlButton
                {
                    id: addToFavourite
                    setWidth: setHeight
                    buttonText: qsTr("AtF")
                    labelContentColor: Style.backgroundWhite
                    backgroundColor: p_is_marked ? Style.activeCouponColor : Style.listViewGrey
                    setBorderColor: "transparent"
                    checkable: true
                    checked: p_is_marked
                    onClicked:
                    {
                        if(checked)
                        {
                            backgroundColor = Style.activeCouponColor;
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"serverUrl": 'http://patrick.ga:8080/api/user/mark?',
                                                           "promo_id": p_id,
                                                           "functionalFlag": "user/mark"});
                        }
                        else
                        {
                            backgroundColor = Style.listViewGrey;
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"serverUrl": 'http://patrick.ga:8080/api/user/unmark?',
                                                           "promo_id": p_id,
                                                           "functionalFlag": "user/unmark"});
                        }
                    }
                }
            }


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
                        imageSource: p_company_logo
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
                        text: p_company_name+'\n'+Helper.currStoreHours(p_store_hours)
                        font.pixelSize: Helper.toDp(13, Style.dpi)
                        color: Style.backgroundBlack
                    }
                }
            }

            ControlButton
            {
                id: nearestStoreButton
                setWidth: Style.screenWidth*0.8
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
                setWidth: Style.screenWidth*0.8
                buttonText: qsTr("ОТКРЫТЬ КАРТОЧКУ КОМПАНИИ")
                labelContentColor: Style.backgroundBlack
                backgroundColor: Style.backgroundWhite
                setBorderColor: Style.backgroundBlack
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: Style.screenHeight*0.03
                onClicked:
                {
                    PageNameHolder.push("promotionPage.qml");
                    promotionPageLoader.setSource("companyPage.qml",
                                                  {"p_company_id": p_company_id,
                                                   "p_company_name": p_company_name,
                                                   "p_company_logo": p_company_logo});
                }
            }
        }
    }

    ToastMessage
    {
        id: promoCodePopup
        backgroundColor: Style.activeCouponColor
        y: Style.screenHeight*0.5
    }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Style.dpi)
        buttonWidth: Style.screenWidth*0.55
        buttonText: qsTr("Назад к выбору акций")
        onClicked: promotionPageLoader.source = "listViewPage.qml"
    }

    FooterButtons { pressedFromPageName: 'promotionPage.qml' }

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
