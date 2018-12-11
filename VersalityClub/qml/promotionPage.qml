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
    property string p_id: ''
    property string p_title: ''
    property string p_desc: ''
    property string p_pic: ''
    property string p_promo_code: ''
    property string c_icon: ''
    property string comp_id: ''
    property bool p_is_marked: false
    //all good flag
    property bool allGood: false
    //dist (in meters) to be able to active coupon
    readonly property int promCloseDist: 100
    //other
    property real minDistToStore: 500000
    readonly property int storeInfoItemHeight: Vars.screenHeight*0.07

    id: promotionPage
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
        visible: allGood
        clip: true
        width: Vars.screenWidth
        height: Vars.screenHeight
        contentHeight: middleFieldsColumns.height*1.1
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
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
                    text: p_desc
                    font.pixelSize: Helper.toDp(13, Vars.dpi)
                    color: Vars.backgroundBlack
                    wrapMode: Label.WordWrap
                }
            }

            RowLayout
            {
                id: rowLayout1
                enabled: p_desc !== ''
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
                        else toastMessage.setTextAndRun(Vars.getCloserToProm);
                    }
                }

                ControlButton
                {
                    id: addToFavourite
                    setWidth: setHeight
                    buttonText: qsTr("AtF")
                    labelContentColor: Vars.backgroundWhite
                    backgroundColor: p_is_marked ? Vars.activeCouponColor :
                                                   Vars.listViewGrey
                    setBorderColor: "transparent"
                    checkable: true
                    checked: p_is_marked
                    onClicked:
                    {
                        if(checked)
                        {
                            p_is_marked = true;
                            backgroundColor = Vars.activeCouponColor;
                            promotionPageLoader.setSource("xmlHttpRequest.qml",
                                                          {"api": Vars.userMarkProm,
                                                           "functionalFlag": "user/mark",
                                                           "promo_id": p_id});
                        }
                        else
                        {
                            p_is_marked = false;
                            backgroundColor = Vars.listViewGrey;
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
                clip: true
                Layout.alignment: Qt.AlignHCenter
                width: Vars.screenWidth*0.8
                height: (storeInfoItemHeight+Vars.screenWidth*0.01)*2
                contentHeight: storeInfoItemHeight
                model: ListModel { id: storeInfoModel }
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
                                                  "defaultZoomLevel": 16
                                                });
                    }

                    RowLayout
                    {
                        id: rowLayout2
                        width: Vars.screenWidth*0.8
                        Layout.alignment: Qt.AlignHCenter

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
                                text: distBetweenCoords() + ' m'
                                font.pixelSize: Helper.toDp(13, Vars.dpi)
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
                Layout.fillWidth: true
                buttonText: Vars.openCompanyCard
                labelContentColor: Vars.backgroundBlack
                backgroundColor: Vars.backgroundWhite
                setBorderColor: Vars.backgroundBlack
                Layout.alignment: Qt.AlignHCenter
                //Layout.topMargin: Vars.screenHeight*0.03
                onClicked:
                {
                    PageNameHolder.push("promotionPage.qml");
                    promotionPageLoader.source = "companyPage.qml";
                }
            }
        }//middleFieldsColumns
    }//Flickable

    ToastMessage
    {
        id: promoCodePopup
        backgroundColor: Vars.mainPurple
        y: Vars.screenHeight*0.5
    }

    ToastMessage { id: toastMessage }

    //back to promotions choose button
    TopControlButton
    {
        id: backButton
        visible: allGood
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/20, Vars.dpi)
        buttonWidth: Vars.screenWidth*0.55
        buttonText: Vars.backToPromsPicking
        onClicked: promotionPageLoader.source = "mapPage.qml"
    }

    FooterButtons { pressedFromPageName: 'promotionPage.qml' }

    Component.onCompleted:
    {
        //if we got correct response
        if(Vars.fullPromData.length > 50)
        {
            allGood = true;
            notifier.visible = false;
            //formating data
            var ppdInJSON = JSON.parse(Vars.fullPromData);
            Helper.promsJsonToListModelForPromPage(ppdInJSON);
            //initializing vars
            p_id = ppdInJSON.id;
            p_title = ppdInJSON.title;
            p_desc = ppdInJSON.desc;
            p_pic = ppdInJSON.pic;
            p_promo_code = ppdInJSON.promo_code;
            c_icon = ppdInJSON.icon;
            comp_id = ppdInJSON.company_id;
            p_is_marked = ppdInJSON.is_marked;
            //setting active focus for key capturing
            promotionPage.forceActiveFocus()
        }
        else
        {
            allGood = false;
            notifier.visible = true;
        }
    }//Component.onCompleted:

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
