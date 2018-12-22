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
    //promotion vars
    property string p_id: AppSettings.value("promo/id")
    property string p_title: AppSettings.value("promo/title")
    property string p_desc: AppSettings.value("promo/desc")
    property string p_pic: AppSettings.value("promo/pic")
    property string p_promo_code: AppSettings.value("promo/code")
    property string c_icon: AppSettings.value("promo/icon")
    property string comp_id: AppSettings.value("promo/comp_id")
    property bool p_is_marked: AppSettings.value("promo/is_marked")
    //all good flag
    property bool allGood: true
    //dist (in meters) to be able to active coupon
    readonly property int promCloseDist: 100
    //other
    property real minDistToStore: 500000
    readonly property int storeInfoItemHeight: Vars.screenHeight*0.06

    id: promotionPage
    enabled: Vars.isConnected
    height: Vars.pageHeight
    width: Vars.screenWidth

    FontLoader
    {
        id: regularText;
        source: "../fonts/Qanelas_Regular.ttf"
    }

    FontLoader
    {
        id: boldText;
        source: "../fonts/Qanelas_Bold.ttf"
    }

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
        visible: allGood
        clip: true
        anchors.top: parent.top
        width: parent.width
        height: parent.height*0.87
        contentHeight: middleFieldsColumns.height*1.05
        boundsBehavior: Flickable.DragOverBounds

        ColumnLayout
        {
            id: middleFieldsColumns
            width: parent.width
            spacing: Vars.screenHeight*0.05

            Rectangle
            {
                id: promsImage
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
                font.family: boldText.name
                font.bold: true
                color: Vars.backgroundBlack
                Layout.alignment: Qt.AlignHCenter
            }

            Rectangle
            {
                id: textArea
                width: promsImage.width
                height: promotionDescription.height
                Layout.alignment: Qt.AlignHCenter
                color: Vars.listViewGrey

                Label
                {
                    id: promotionDescription
                    width: parent.width
                    text: p_desc === '' ? '\n\n\n\n\n' : p_desc
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    font.family: regularText.name
                    color: Vars.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }

            RowLayout
            {
                id: rowLayout1
                width: parent.width
                Layout.alignment: Qt.AlignHCenter
                spacing: Vars.screenWidth*0.1

                ControlButton
                {
                    id: activeCoupon
                    setWidth: Vars.screenWidth*0.6
                    buttonText: Vars.activateCoupon
                    labelContentColor: Vars.backgroundWhite
                    backgroundColor: Vars.activeCouponColor
                    setBorderColor: "transparent"
                    onClicked:
                    {
                        if(minDistToStore < promCloseDist)
                        {
                            promoCodePopup.setText(p_promo_code);
                            //inform server about coupon was activated
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userActivateProm,
                                                           "functionalFlag": "user/activate",
                                                           "promo_id": p_id});
                        }
                        else toastMessage.setTextAndRun(Vars.getCloserToProm, false);
                    }
                }

                IconedButton
                {
                    id: addToFavourite
                    width: Vars.screenHeight*0.1
                    height: Vars.screenHeight*0.1
                    Layout.alignment: Qt.AlignRight
                    buttonIconSource: p_is_marked ?
                                      "../icons/add_to_favourites_on.png" :
                                      "../icons/add_to_favourites_off.png"
                    clickArea.onClicked:
                    {
                        if(!p_is_marked)
                        {
                            p_is_marked = true;
                            buttonIconSource = "../icons/add_to_favourites_on.png";
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userMarkProm,
                                                           "functionalFlag": "user/mark",
                                                           "promo_id": p_id});
                        }
                        else
                        {
                            p_is_marked = false;
                            buttonIconSource = "../icons/add_to_favourites_off.png";
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userUnmarkProm,
                                                           "functionalFlag": "user/unmark",
                                                           "promo_id": p_id});
                        }
                    }
                }//addToFavourite
            }//RowLayout1

            ListView
            {
                id: storeInfoListView
                visible: false
                clip: true
                Layout.alignment: Qt.AlignHCenter
                width: Vars.screenWidth*0.8
                contentHeight: storeInfoItemHeight
                model:
                    ListModel
                    {
                        id: storeInfoModel;
                        Component.onCompleted:
                        {
                            storeInfoListView.height = adjustHeight();
                            storeInfoListView.visible = true;

                            function adjustHeight()
                            {
                                if(count > 3)
                                    return storeInfoItemHeight*3;
                                else return storeInfoItemHeight*count;
                            }
                        }
                    }
                delegate: storeInfoDelegate
            }

            Component
            {
                id: storeInfoDelegate

                MouseArea
                {
                    id: storeInfoClickableArea
                    width: childrenRect.width
                    height: childrenRect.height
                    onClicked:
                    {
                        PageNameHolder.push("promotionPage.qml");
                        promotionPageLoader.setSource("mapPage.qml",
                                                { "defaultLat": s_lat,
                                                  "defaultLon": s_lon,
                                                  "defaultZoomLevel": 16,
                                                  "showStoreMarker": true
                                                });
                    }

                    RowLayout
                    {
                        id: rowLayout2
                        width: Vars.screenWidth*0.8
                        Layout.alignment: Qt.AlignCenter

                        Rectangle
                        {
                            id: textBox1
                            width: Vars.screenWidth*0.2
                            height: storeInfoItemHeight
                            Layout.alignment: Qt.AlignHCenter
                            color: "transparent"

                            Label
                            {
                                id: distToStore
                                text: distBetweenCoords() + ' м'
                                font.family: regularText.name
                                font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                                            Vars.dpi)
                                color: Vars.backgroundBlack

                                function distBetweenCoords()
                                {
                                    var storePos = QtPositioning.coordinate(s_lat, s_lon);
                                    var userPos = QtPositioning.coordinate(AppSettings.value("user/lat"),
                                                                           AppSettings.value("user/lon"));
                                    var currDistToStore = Math.round(storePos.distanceTo(userPos));
                                    minDistToStore = minDistToStore > currDistToStore ? currDistToStore : minDistToStore

                                    return currDistToStore;
                                }
                            }
                        }

                        Rectangle
                        {
                            id: textBox2
                            width: Vars.screenWidth*0.2
                            height: storeInfoItemHeight
                            Layout.alignment: Qt.AlignHCenter
                            color: "transparent"

                            Label
                            {
                                id: workingHours
                                text: Helper.currStoreHours(store_hours)
                                font.pixelSize: Helper.toDp(13, Vars.dpi)
                                font.family: regularText.name
                                color: Vars.backgroundBlack
                            }
                        }
                    }//rowLayout2
                }//storeInfoClickableArea
            }//Component

            /*ControlButton
            {
                id: nearestStoreButton
                Layout.fillWidth: true
                buttonText: Vars.closestAddress
                labelContentColor: Vars.mainPurple
                backgroundColor: Vars.backgroundWhite
                setBorderColor: Vars.mainPurple
                Layout.alignment: Qt.AlignHCenter
                //onClicked:
            }*/

            ControlButton
            {
                id: companyCardButton
                enabled: storeInfoModel.count !== 0
                Layout.fillWidth: true
                buttonText: Vars.openCompanyCard
                labelContentColor: Vars.backgroundBlack
                backgroundColor: Vars.backgroundWhite
                setBorderColor: Vars.backgroundBlack
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: -Vars.screenHeight*0.02
                onClicked:
                {
                    PageNameHolder.push("promotionPage.qml");
                    promotionPageLoader.source = "companyPage.qml";
                }
            }
        }//middleFieldsColumns
    }//Flickable

    Image
    {
        id: background
        clip: true
        anchors.fill: parent
        source: "../backgrounds/main_f.png"
    }

    Image
    {
        id: background2
        clip: true
        anchors.fill: parent
        source: "../backgrounds/fade_out_h.png"
    }

    ToastMessage
    {
        id: promoCodePopup
        backgroundColor: Vars.fontsPurple
        y: Vars.screenHeight*0.5
    }

    ToastMessage { id: toastMessage }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        visible: allGood
        buttonWidth: Vars.screenWidth*0.54
        buttonText: Vars.backToPromsPicking
        buttonIconSource: "../icons/left_arrow.png"
        iconAlias.width: height*0.5
        iconAlias.height: height*0.4
        onClicked: promotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'promotionPage.qml' }

    Component.onCompleted:
    {
        if(allGood)
        {
            //formating data
            var fpdInJSON = JSON.parse(Vars.fullPromData);
            Helper.promsJsonToListModelForPromPage(fpdInJSON);

            notifier.visible = false;
            promotionPage.forceActiveFocus();
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
