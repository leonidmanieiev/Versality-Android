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

//scroll number picker
import '../'
import '../js/helpFunc.js' as Helper
import QtQuick 2.11

Rectangle
{
    property int minNumber: 0
    property int maxNumber: 0
    readonly property int itemHeight: Vars.screenHeight*0.1

    signal indexChanged(var t_number)

    id: rootRect
    width: Vars.screenWidth*0.192
    height: Vars.screenHeight*0.3
    color: "transparent"

    function setDefault(defValue)
    {
        listView.positionViewAtIndex(defValue, ListView.Center);
        listView.currentIndex = defValue;
        indexChanged(defValue);
    }

    FontLoader
    {
        id: mediumText;
        source: Vars.mediumFont
    }

    ListView
    {
        id: listView
        clip: true
        anchors.fill: parent
        contentHeight: itemHeight*3
        model: ListModel
        {
            id: listModel
            Component.onCompleted:
            {
                append({ value: -1, text: ' ' })
                for(var i = minNumber; i <= maxNumber; i++)
                {
                    var si;

                    if(i < 10)
                        si = '0'+i
                    else si = i.toString();

                    append({ value: i, text: si })
                }
                append({ value: -1, text: ' ' })
            }
        }
        delegate: Item
        {
            id: delegateItem
            width: listView.width
            height: itemHeight

            Text
            {
                id: delegateItemText
                text: model.text
                font.family: mediumText.name
                font.pixelSize: Helper.toDp(20, Vars.dpi)
                anchors.centerIn: parent
            }
        }

        onMovementEnded:
        {
            var centralItemIndex =
                    listView.indexAt(listView.contentX,
                                     listView.contentY+itemHeight*1.5)
            moveToIndex(centralItemIndex)
            indexChanged(listModel.get(currentIndex).text)
        }

        function moveToIndex(centralItemIndex)
        {
            var startPos = listView.contentY, stopPos;

            listView.positionViewAtIndex(centralItemIndex, ListView.Center);
            stopPos = listView.contentY;

            moveAnimation.from = startPos;
            moveAnimation.to = stopPos;
            moveAnimation.running = true;

            listView.currentIndex = centralItemIndex
        }
    }

    NumberAnimation
    {
        id: moveAnimation;
        target: listView;
        property: "contentY";
        easing.type: Easing.Linear
    }
}
