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

//preview of promotion
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

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

    FontLoader
    {
        id: regularText;
        source: Vars.regularFont
    }

    FontLoader
    {
        id: boldText;
        source: Vars.boldFont
    }

    //checking internet connetion
    Network { toastMessage: toastMessage }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/preview_bg.jpg"
    }

    Flickable
    {
        id: flickableArea
        clip: true
        width: parent.width
        height: parent.height
        contentHeight: middleFieldsColumns.height
        anchors.top: parent.top
        bottomMargin: Vars.footerButtonsFieldHeight*1.05
        anchors.horizontalCenter: parent.horizontalCenter
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: Vars.screenWidth*0.9
            spacing: Vars.screenHeight*0.05
            anchors.horizontalCenter: parent.horizontalCenter

            IconedButton
            {
                id: addToFavourite
                width: Vars.footerButtonsHeight*1.3
                height: Vars.footerButtonsHeight*1.3
                Layout.topMargin: parent.spacing*0.2
                Layout.alignment: Qt.AlignHCenter
                buttonIconSource: p_is_marked ?
                                  "../icons/add_to_favourites_2_on.svg" :
                                  "../icons/add_to_favourites_2_off.svg"
                clickArea.onClicked:
                {
                    if(!p_is_marked)
                    {
                        p_is_marked = true;
                        buttonIconSource = "../icons/add_to_favourites_2_on.svg";
                        previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                             {"api": Vars.userMarkProm,
                                                              "functionalFlag": "user/mark",
                                                              "promo_id": p_id});
                    }
                    else
                    {
                        p_is_marked = false;
                        buttonIconSource = "../icons/add_to_favourites_2_off.svg";
                        previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                                             {"api": Vars.userUnmarkProm,
                                                              "functionalFlag": "user/unmark",
                                                              "promo_id": p_id});
                    }
                }
            }//addToFavourite

            Rectangle
            {
                id: promsImage
                Layout.topMargin: parent.spacing*2
                Layout.alignment: Qt.AlignHCenter
                height: Vars.screenHeight*0.25
                width: Vars.screenWidth*0.9
                radius: Vars.listItemRadius
                color: "transparent"

                RectangularGlow
                {
                    id: effect
                    z: -1
                    anchors.fill: promsImage
                    color: "#3a3a3a"
                    glowRadius: 40
                    cornerRadius: promsImage.radius
                }

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
                font.family: boldText.name
                font.weight: Font.Bold
                color: Vars.purpleTextColor
                Layout.alignment: Qt.AlignLeft
            }

            Rectangle
            {
                id: textArea
                width: promsImage.width
                height: childrenRect.height
                Layout.alignment: Qt.AlignLeft
                color: "transparent"

                Label
                {
                    id: promotionDescription
                    width: parent.width
                    text: p_desc
                    maximumLineCount: maxLineCnt
                    font.family: regularText.name
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    color: Vars.blackColor
                    elide: Text.ElideRight
                    wrapMode: Label.WordWrap
                }

                Image
                {
                    id: descriptionFadeOut
                    visible: promotionDescription.lineCount < maxLineCnt ? false : true
                    clip: true
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height
                    source: "../backgrounds/description_fade_out.png"
                }
            }//textArea

            ControlButton
            {
                id: moreButton
                buttonWidth: Vars.screenWidth*0.9
                Layout.alignment: Qt.AlignLeft
                labelText: Vars.more
                buttonClickableArea.onClicked:
                {
                    PageNameHolder.push("previewPromotionPage.qml");
                    previewPromotionPageLoader.setSource("xmlHttpRequest.qml",
                                            { "api": Vars.promFullViewModel,
                                              "functionalFlag": 'user/fullprom'});
                }
            }//moreButton
        }//middleFieldsColumns
    }//flickableArea

    Image
    {
        id: background2
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        source: "../backgrounds/map_f.png"
    }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        anchors.topMargin: Vars.screenWidth*0.25
        buttonText: Vars.backToPromsPicking
        buttonIconSource: "../icons/left_arrow.svg"
        iconAlias.sourceSize.width: height*0.5
        iconAlias.sourceSize.height: height*0.4
        onClicked: previewPromotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons
    {
        pressedFromPageName: 'previewPromotionPage.qml'
        Component.onCompleted: disableAllButtonsSubstrates()
    }

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
