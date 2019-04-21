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

//page where user select categories
import "../"
import "../js/helpFunc.js" as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4

Page
{
    property string strCatsJSON: ''

    id: selectCategoryPage
    enabled: Vars.isConnected
    height: Vars.screenHeight
    width: Vars.screenWidth

    //checking internet connetion
    Network { toastMessage: toastMessage }

    Image
    {
        id: background
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/settings_bg.png"
    }

    FontLoader
    {
        id: mediumText;
        source: Vars.mediumFont
    }

    ListModel { id: catsModel }

    ListView
    {
        id: catsListView
        clip: true
        width: parent.width
        height: parent.height*0.615
        anchors.top: parent.top
        anchors.topMargin: parent.height*0.175
        model: catsModel
        delegate: Component
        {
            id: catsDelegate
            Column
            {
                id: middleFieldsColumn
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                bottomPadding: Vars.screenHeight*0.03
                Rectangle
                {
                    id: catsItem
                    height: Vars.screenHeight*0.09
                    width: parent.width
                    radius: height*0.5
                    color: "transparent"
                    border.color: Vars.backgroundWhite
                    border.width: height*0.06

                    Image
                    {
                        id: catIcon
                        width: parent.radius
                        height: parent.radius
                        anchors.left: parent.left
                        anchors.leftMargin: parent.radius*0.6
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/cat_"+id+".png"
                    }

                    Text
                    {
                        id: catsItemText
                        x: parent.radius*2
                        anchors.verticalCenter: parent.verticalCenter
                        color: Vars.backgroundWhite
                        font.family: mediumText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                                    Vars.dpi)
                        text: title
                    }

                    Image
                    {
                        id: downArrow
                        width: parent.radius
                        height: parent.radius
                        anchors.right: parent.right
                        anchors.rightMargin: parent.radius
                        anchors.verticalCenter: parent.verticalCenter
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/down_arrow.png"
                    }

                    MouseArea
                    {
                        id: catsClickableArea
                        anchors.fill: parent
                        onClicked:
                        {
                            downArrow.rotation = collapsed ? 180 : 0;
                            catsItem.border.color = collapsed ? "transparent" : Vars.backgroundWhite
                            catsItem.color = collapsed ? Vars.popupWindowColor : "transparent"
                            catsModel.setProperty(index, "collapsed", !collapsed);
                        }
                    }
                }//Rectangle

                Loader
                {
                    id: catsItemLoader
                    visible: !collapsed
                    property variant subCatsModel : subcats
                    sourceComponent: collapsed ? null : subCatsDelegate
                    onStatusChanged: if (status == Loader.Ready) item.model = subCatsModel
                }
            }//middleFieldsColumn
        }//catsDelegate
    }//catsListView

    Component
    {
        id: subCatsDelegate
        Column
        {
            id: middleFieldsSubColumn
            property alias model: subCatsRepeater.model
            width: catsListView.width*0.8
            anchors.horizontalCenter: parent.horizontalCenter
            topPadding: Vars.screenHeight*0.02
            //instead of bottomPadding
            spacing: Vars.screenHeight*0.01

            Repeater
            {
                id: subCatsRepeater
                delegate: Rectangle
                {
                    id: subCatsItem
                    color: AppSettings.contains(subid) ? Vars.subCatSelectedColor :
                                                         "transparent"
                    radius: height*0.5
                    height: Vars.screenHeight*0.07
                    width: parent.width

                    Text
                    {
                        id: subCatsText
                        x: parent.radius*2
                        width: parent.width*0.7
                        anchors.verticalCenter: parent.verticalCenter
                        font.family: mediumText.name
                        font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                                    Vars.dpi)
                        color: AppSettings.contains(subid) ? "transprent" :
                                                             Vars.backgroundWhite
                        wrapMode: Text.WordWrap
                        text: subtitle
                    }

                    Image
                    {
                        id: tickIcon
                        width: parent.radius*1.2
                        height: parent.radius*1.2
                        anchors.left: parent.left
                        anchors.leftMargin: parent.radius*0.45
                        anchors.verticalCenter: parent.verticalCenter
                        visible: AppSettings.contains(subid)
                        fillMode: Image.PreserveAspectFit
                        source: "../icons/tick.png"
                    }

                    MouseArea
                    {
                        id: subCatsClickableArea
                        anchors.fill: parent
                        onClicked:
                        {
                            if(AppSettings.contains(subid))
                            {
                                subCatsItem.color = "transparent";
                                subCatsText.color = Vars.backgroundWhite
                                tickIcon.visible = false;
                                AppSettings.removeCat(subid);
                            }
                            else
                            {
                                subCatsItem.color = Vars.subCatSelectedColor;
                                subCatsText.color = "transprent";
                                tickIcon.visible = true;
                                AppSettings.insertCat(subid);
                            }
                        }
                    }
                }//delegate: Rectangle
            }//Repeater
        }//Column
    }//Component

    Image
    {
        id: header_footer
        clip: true
        width: parent.width
        height: parent.height
        source: "../backgrounds/category_settings_hf.png"
    }

    LogoAndPageTitle
    {
        pageTitleText: Vars.profileSettings
        showInfoButton: true
    }

    ControlButton
    {
        id: saveSelectedButton
        buttonWidth: parent.width*0.8
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.05
        anchors.horizontalCenter: parent.horizontalCenter
        labelText: Vars.saveAndBackToSetting
        labelAlias.horizontalAlignment: Text.AlignHCenter
        buttonClickableArea.onClicked:
        {
            PageNameHolder.pop();
            chooseCategoryPageLoader.setSource("xmlHttpRequest.qml",
                                              { "api": Vars.userSelectCats,
                                                "functionalFlag": 'user/refresh-cats'
                                              });
        }
    }


    ToastMessage { id: toastMessage }

    Component.onCompleted:
    {
        //setting active focus for key capturing
        selectCategoryPage.forceActiveFocus();

        var catsJSON = JSON.parse(strCatsJSON);
        Helper.catsJsonToListModel(catsJSON);
    }

    Keys.onReleased:
    {
        //back button pressed for android and windows
        if (event.key === Qt.Key_Back || event.key === Qt.Key_B)
        {
            event.accepted = true;
            var pageName = PageNameHolder.pop();
            chooseCategoryPageLoader.source = pageName;

            //to avoid not loading bug
            chooseCategoryPageLoader.reload();
        }
    }

    Loader
    {
        id: chooseCategoryPageLoader
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
