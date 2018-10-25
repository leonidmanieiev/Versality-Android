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
    property string p_picture: ''
    property string p_title: ''
    property string p_description: ''
    property string p_company_logo: ''
    property string p_company_name: ''

    id: promPage
    height: Style.pageHeight
    width: Style.screenWidth
    anchors.top: appWindow.top

    background: Rectangle
    {
        id: pageBackground
        height: Style.pageHeight
        width: Style.screenWidth
        color: Style.backgroundWhite
    }

    Flickable
    {
        id: flickableArea
        clip: true
        anchors.top: parent.top
        anchors.centerIn: parent
        width: Style.screenWidth
        height: Style.pageHeight
        boundsBehavior: Flickable.DragOverBounds
        contentHeight: middleFieldsColumns.height*1.05

        ColumnLayout
        {
            id: middleFieldsColumns
            width: Style.screenWidth
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
        }
    }

    //switch to mapPage (proms on map view)
    ControlButton
    {
        id: backToPromotions
        setHeight: Style.footerButtonsFieldHeight*0.4
        setWidth: Style.screenWidth*0.55
        fontPixelSize: Helper.toDp(13, Style.dpi)
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top
        anchors.topMargin: Helper.toDp(parent.height/13, Style.dpi)
        buttonText: qsTr("Назад к выбору акций")
        labelContentColor: Style.backgroundWhite
        backgroundColor: Style.mainPurple
        setBorderColor: "transparent"
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
