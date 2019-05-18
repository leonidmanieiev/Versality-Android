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

//company card page
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtGraphicalEffects 1.0

Page
{
    //company data
    readonly property string comp_id: AppSettings.value("company/id")
    readonly property string comp_logo: AppSettings.value("company/logo")
    readonly property string comp_phone: AppSettings.value("company/phone")
    readonly property string comp_about: AppSettings.value("company/about")
    readonly property string comp_name: AppSettings.value("company/name")
    readonly property var comp_pictures: AppSettings.value("company/pictures")
    readonly property string comp_website: AppSettings.value("company/website")
    readonly property var picsSources: [comp_pictures[0], comp_pictures[1],
                                        comp_pictures[2], comp_pictures[3]]
    property int picInd: 0
    //all good flag
    property bool allGood: AppSettings.value("company/id") === undefined ? false : true
    //alias
    property alias comp_loader: companyPageLoader

    function setPopupPicAndShow()
    {
        compPicPopup.picItem.source = picsSources[picInd];
        compPicPopup.visible = true;
        PageNameHolder.push('popupImage');
    }

    header: HeaderButtons { }

    id: companyPage
    enabled: Vars.isConnected
    height: Vars.companyPageHeight
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

    background: Rectangle
    {
        id: backgroundColor
        anchors.fill: parent
        color: Vars.backgroundWhite
    }

    Flickable
    {
        id: mainFlickableArea
        visible: allGood
        clip: true
        width: parent.width
        height: Vars.screenHeight
        contentHeight: middleFieldsColumns.height*1.1
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            spacing: Vars.screenHeight*0.05

            RowLayout
            {
                id: logoContactInfo
                width: Vars.screenWidth
                height: Vars.footerButtonsFieldHeight
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.05
                spacing: parent.width*0.0625

                Rectangle
                {
                    id: compLogoField
                    width: parent.height
                    height: parent.height
                    Layout.alignment: Qt.AlignRight
                    color: "transparent"

                    ImageRounder
                    {
                        id: compLogo
                        imageSource: comp_logo
                        roundValue: parent.height*0.5
                    }
                }

                ColumnLayout
                {
                    id: namePhoneSite
                    Layout.alignment: Qt.AlignLeft

                    Label
                    {
                        id: compName
                        text: comp_name
                        font.family: regularText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                    }

                    Label
                    {
                        id: compPhone
                        text: comp_phone
                        font.family: regularText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                    }

                    Label
                    {
                        id: compSite
                        textFormat: Text.RichText;
                        text: '<a href="http://'+comp_website+'"'
                              +' style="color: '+Vars.popupWindowColor+'">'
                              +comp_website+'</a>'
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize, Vars.dpi)
                        font.family: boldText.name
                        font.bold: true
                        onLinkActivated: Qt.openUrlExternally(link)
                    }
                }//namePhoneSite
            }//compLogoField

            Item
            {
                id: flicker_image_field
                clip: true
                width: parent.width
                height: parent.width*0.4
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.leftMargin: parent.width*0.05

                Flickable
                {
                    id: picFlickableArea
                    clip: true
                    width: parent.width
                    height: parent.height
                    contentHeight: height
                    contentWidth: height*4.5
                    boundsBehavior: Flickable.DragOverBounds

                    RowLayout
                    {
                        id: picturesRow
                        width: parent.width
                        height: parent.height

                        Rectangle
                        {
                            id: compPicField1
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic1
                                imageSource: picsSources[0]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea1
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 0;
                                    setPopupPicAndShow()
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField2
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic2
                                imageSource: picsSources[1]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea2
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 1;
                                    setPopupPicAndShow()
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField3
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic3
                                imageSource: picsSources[2]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea3
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 2;
                                    setPopupPicAndShow()
                                }
                            }
                        }

                        Rectangle
                        {
                            id: compPicField4
                            width: parent.height
                            height: parent.height
                            color: "transparent"

                            ImageRounder
                            {
                                id: compPic4
                                imageSource: picsSources[3]
                                roundValue: parent.height*0.1
                            }

                            MouseArea
                            {
                                id: clickableArea4
                                anchors.fill: parent
                                onClicked:
                                {
                                    picInd = 3;
                                    setPopupPicAndShow()
                                }
                            }
                        }
                    }//picturesRow
                }//picFlickableArea

                Image
                {
                    id: pictures_fade_out
                    clip: true
                    width: parent.width
                    height: parent.height
                    anchors.right: parent.right
                    source: "../backgrounds/comp_pictures_fade_out.png"
                }
            }//flicker_image_field

            Rectangle
            {
                id: textArea
                width: parent.width*0.9
                color: "transparent"
                anchors.left: parent.left
                anchors.leftMargin: parent.width*0.05

                Label
                {
                    id: companyDescription
                    width: parent.width
                    text: comp_about
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    font.family: regularText.name
                    color: Vars.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }
        }//middleFieldsColumns
    }//mainFlickableArea

    Popup
    {
        property alias picItem: pic

        id: compPicPopup
        x: 0
        y: (Vars.companyPageHeight-height)/2
        width: parent.width
        height: parent.height*0.35
        padding: 0
        modal: true
        focus: true
        closePolicy: Popup.CloseOnEscape | Popup.CloseOnPressOutside

        onClosed: PageNameHolder.pop()

        Image
        {
            id: pic
            anchors.fill: parent
        }

        MouseArea
        {
            property int xStart: 0
            property bool canSwipe: false

            id: swiper
            enabled: parent.visible
            anchors.fill: parent

            onPressed:
            {
                canSwipe = true;
                xStart = mouse.x;
            }

            onPositionChanged:
            {
                var dist = mouse.x - xStart;
                xStart = mouse.x;

                if(picInd > 0 && dist > 15 && canSwipe)
                {
                    // swipe from left to right
                    canSwipe = false;
                    picInd = picInd-1;
                    pic.source = picsSources[picInd];
                }
                else if(picInd < 3 && dist < -15 && canSwipe)
                {
                    // swipe from right to left
                    canSwipe = false;
                    picInd = picInd+1;
                    pic.source = picsSources[picInd];
                }
            }
        }
    }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        companyPage.forceActiveFocus();
    }

    Image
    {
        id: compDescFadeOut
        clip: true
        anchors.bottom: background.top
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        source: "../backgrounds/description_fade_out.png"
    }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: Vars.footerButtonsFieldHeight
        anchors.bottom: parent.bottom
        source: "../backgrounds/map_f.png"
    }

    FooterButtons { pressedFromPageName: 'companyPage.qml' }

    ToastMessage { id: toastMessage }

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
            else if (pageName === 'popupImage')
                compPicPopup.close();
            else
            {
                //to avoid not loading bug
                appWindowLoader.source = "";
                appWindowLoader.source = pageName;
            }
        }
    }

    Loader
    {
        id: companyPageLoader
        asynchronous: false
        anchors.fill: parent
        anchors.topMargin: -header.height
        visible: status == Loader.Ready

        function reload()
        {
            var oldSource = source;
            source = "";
            source = oldSource;
        }
    }
}
