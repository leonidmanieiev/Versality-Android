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

//scroll number picker
import '../'
import '../js/helpFunc.js' as Helper
import QtQuick 2.11

Rectangle
{
    property int minNumber: 0
    property int maxNumber: 0
    property bool isMonthScroller: false
    readonly property int itemHeight: Vars.screenHeight*0.1

    signal indexChanged(var t_number)

    id: rootRect
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
        id: regularText;
        source: Vars.regularFont
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
                if(isMonthScroller)
                {
                    append({ value: 1, text: 'Январь' })
                    append({ value: 2, text: 'Февраль' })
                    append({ value: 3, text: 'Март' })
                    append({ value: 4, text: 'Апрель' })
                    append({ value: 5, text: 'Май' })
                    append({ value: 6, text: 'Июнь' })
                    append({ value: 7, text: 'Июль' })
                    append({ value: 8, text: 'Август' })
                    append({ value: 9, text: 'Сентябрь' })
                    append({ value: 10, text: 'Октябрь' })
                    append({ value: 11, text: 'Ноябрь' })
                    append({ value: 12, text: 'Декабрь' })
                }
                else
                {
                    for(var i = minNumber; i <= maxNumber; i++)
                    {
                        var si;

                        if(i < 10)
                            si = '0'+i
                        else si = i.toString();

                        append({ value: i, text: si })
                    }
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
                font.family: regularText.name
                color: Vars.backgroundWhite
                font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                            Vars.dpi)
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
