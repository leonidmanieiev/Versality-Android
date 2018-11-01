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
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Page
{
    property string p_id: ''
    property string p_title: ''
    property string p_picture: ''
    property string p_description: ''
    property bool p_is_marked: false
    property string p_store_hours: ''
    property string p_promo_code: ''
    property string p_company_id: ''
    property string p_company_name: ''
    property string p_company_logo: ''

    id: previewPromPage
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
                color: p_is_marked ? Style.errorRed : Style.backgroundWhite
            }
            checkable: true
            checked: p_is_marked
            onClicked:
            {
                if(checked)
                {
                    buttonBackground.color = Style.activeCouponColor;
                    previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                        {"serverUrl": 'http://patrick.ga:8080/api/user/mark?',
                                                         "promo_id": p_id,
                                                         "functionalFlag": "user/mark"});
                }
                else
                {
                    buttonBackground.color = Style.listViewGrey;
                    previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                        {"serverUrl": 'http://patrick.ga:8080/api/user/unmark?',
                                                         "promo_id": p_id,
                                                         "functionalFlag": "user/unmark"});
                }
            }
        }

        Rectangle
        {
            id: promsImage
            Layout.topMargin: parent.spacing*1.2
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
                maximumLineCount: 3
                font.pixelSize: Helper.toDp(13, Style.dpi)
                color: Style.backgroundBlack
                wrapMode: Label.WordWrap
            }
        }

        ControlButton
        {
            id: moreButton
            setWidth: Style.screenWidth*0.8
            buttonText: qsTr("ПОДРОБНЕЕ")
            labelContentColor: Style.mainPurple
            backgroundColor: Style.backgroundWhite
            setBorderColor: Style.mainPurple
            Layout.alignment: Qt.AlignHCenter
            onClicked:
            {
                PageNameHolder.push("previewPromotionPage.qml");
                previewPromotionPageLoader.setSource("promotionPage.qml",
                                                      { "p_id": p_id,
                                                        "p_picture": p_picture,
                                                        "p_title": p_title,
                                                        "p_description": p_description,
                                                        "p_is_marked": p_is_marked,
                                                        "p_promo_code": p_promo_code,
                                                        "p_store_hours": p_store_hours,
                                                        "p_company_id": p_company_id,
                                                        "p_company_logo": p_company_logo,
                                                        "p_company_name": p_company_name
                                                      });
            }
        }
    }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: Style.screenWidth*0.25
        buttonWidth: Style.screenWidth*0.55
        buttonText: qsTr("Назад к выбору акций")
        onClicked: previewPromotionPageLoader.source = "listViewPage.qml"
    }

    FooterButtons { pressedFromPageName: 'promotionPage.qml' }

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
