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

Page
{
    property string p_id: ''
    property string p_title: ''
    property string p_picture: ''
    property string p_description: ''
    //property string p_promo_code: ''
    //property string p_company_id: ''
    property string p_company_logo: ''
    property string p_store_hours: ''
    property string p_company_name: ''
    property bool p_is_marked: false

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
                    setWidth: Style.screenWidth*0.6
                    buttonText: qsTr("АКТИВИРОВАТЬ КУПОН")
                    labelContentColor: Style.backgroundWhite
                    backgroundColor: Style.activeCouponColor
                    setBorderColor: "transparent"
                    //onClicked:
                }

                ControlButton
                {
                    id: addToFavourite
                    setWidth: setHeight
                    buttonText: qsTr("AtF")
                    labelContentColor: Style.backgroundWhite
                    backgroundColor: p_is_marked ? Style.errorRed : Style.listViewGrey
                    setBorderColor: "transparent"
                    checkable: true
                    checked: p_is_marked
                    onClicked:
                    {
                        backgroundColor = checked ? Style.listViewGrey : Style.errorRed
                        //request for flag change
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
                onClicked: promotionPageLoader.source = "companyPage.qml";
            }
        }
    }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Style.dpi)
        buttonWidth: Style.screenWidth*0.55
        buttonText: qsTr("Назад к выбору акций")
        onClicked:
        {
            var pageName = PageNameHolder.pop();

            //if no pages in sequence
            if(pageName === "")
                appWindow.close();
            else promotionPageLoader.source = pageName;

            //to avoid not loading bug
            promotionPageLoader.reload();
        }
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
