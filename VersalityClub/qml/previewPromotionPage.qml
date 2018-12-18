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
    //preview promotion vars
    property string p_id: AppSettings.value("promo/id")
    property string p_title: AppSettings.value("promo/title")
    property string p_desc: AppSettings.value("promo/desc")
    property string p_pic: AppSettings.value("promo/pic")
    property string c_icon: AppSettings.value("promo/icon")
    property real s_lat: AppSettings.value("promo/lat")
    property real s_lon: AppSettings.value("promo/lon")
    property bool p_is_marked: AppSettings.value("promo/is_marked")
    //all good flag
    property bool allGood: true
    //max length of promotion description text preview
    readonly property int maxLineCnt: 3

    id: previewPromPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    background: Rectangle
    {
        id: pageBackground
        anchors.fill: parent
        color: Vars.listViewGrey
    }

    Flickable
    {
        id: flickableArea
        clip: true
        width: Vars.screenWidth
        height: Vars.screenHeight
        contentHeight: middleFieldsColumns.height
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds
    ColumnLayout
    {
        id: middleFieldsColumns
        width: parent.width
        spacing: Vars.screenHeight*0.05

        Button
        {
            id: favouriteIndicator
            Layout.topMargin: parent.spacing*0.5
            Layout.alignment: Qt.AlignHCenter
            width: Vars.screenWidth*0.16
            height: width
            text: qsTr("AtF")
            background: Rectangle
            {
                id: buttonBackground
                implicitWidth: parent.width
                implicitHeight: parent.height
                radius: Vars.listItemRadius
                color: p_is_marked ? Vars.errorRed : Vars.backgroundWhite
            }
            checkable: true
            checked: p_is_marked
            onClicked:
            {
                if(checked)
                {
                    p_is_marked = true;
                    buttonBackground.color = Vars.activeCouponColor;
                    previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                        {"api": Vars.userMarkProm,
                                                         "functionalFlag": "user/mark",
                                                         "promo_id": p_id});
                }
                else
                {
                    p_is_marked = false;
                    buttonBackground.color = Vars.listViewGrey;
                    previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                        {"api": Vars.userUnmarkProm,
                                                         "functionalFlag": "user/unmark",
                                                         "promo_id": p_id});
                }
            }
        }//favouriteIndicator

        Rectangle
        {
            id: promsImage
            Layout.topMargin: parent.spacing*3
            Layout.alignment: Qt.AlignHCenter
            height: Vars.screenHeight*0.25
            width: Vars.screenWidth*0.8
            radius: Vars.listItemRadius
            color: "transparent"

            //rounding promotion image
            ImageRounder
            {
                imageSource: p_pic
                roundValue: Vars.listItemRadius
            }
        }

        Label
        {
            id: promotionTitle
            text: p_title
            font.pixelSize: Helper.toDp(16, Vars.dpi)
            font.bold: true
            color: Vars.backgroundBlack
            Layout.alignment: Qt.AlignHCenter
        }

        Rectangle
        {
            id: textArea
            width: promsImage.width
            height: childrenRect.height
            Layout.alignment: Qt.AlignHCenter
            color: Vars.listViewGrey

            Label
            {
                id: promotionDescription
                width: parent.width
                text: p_desc
                maximumLineCount: maxLineCnt
                font.pixelSize: Helper.toDp(13, Vars.dpi)
                color: Vars.backgroundBlack
                elide: Text.ElideRight
                wrapMode: Label.WordWrap
            }
        }

        ControlButton
        {
            id: moreButton
            Layout.fillWidth: true
            buttonText: Vars.more
            labelContentColor: Vars.mainPurple
            backgroundColor: Vars.backgroundWhite
            setBorderColor: Vars.mainPurple
            Layout.alignment: Qt.AlignHCenter
            onClicked:
            {
                PageNameHolder.push("previewPromotionPage.qml");
                previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                        { "api": Vars.promFullViewModel,
                                          "functionalFlag": 'user/fullprom'});
            }
        }//ControlButton
    }//ColumnLayout
    }
    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.top: parent.top
        anchors.topMargin: Vars.screenWidth*0.25
        buttonWidth: Vars.screenWidth*0.55
        buttonText: Vars.backToPromsPicking
        onClicked: previewPromotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'previewPromotionPage.qml' }

    Component.onCompleted:
    {
        if(allGood)
        {
            notifier.visible = false;
            previewPromPage.forceActiveFocus();
        }
        else notifier.visible = true;
    }

    StaticNotifier
    {
        id: notifier
        notifierText: Vars.smthWentWrong
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
            else previewPromotionPageLoader.source = pageName;

            //to avoid not loading bug
            previewPromotionPageLoader.reload();
        }
    }

    ToastMessage { id: toastMessage }

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
