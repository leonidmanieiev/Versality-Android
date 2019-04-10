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

//birthday picker
import '../'
import '../js/helpFunc.js' as Helper
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3

Rectangle
{
    property string selectedDay
    property string selectedMonth
    property string selectedYear
    property alias doneButton: clickableArea

    id: rootBackground
    width: Vars.screenWidth*0.8
    height: Vars.screenHeight*0.4
    color: Vars.copyrightBackgroundColor
    radius: Vars.defaultRadius

    RowLayout
    {
        id: rowLayout
        spacing: width * 0.05
        width: parent.width * 0.8
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        anchors.horizontalCenter: parent.horizontalCenter

        ScrollNumberPicker
        {
            id: daySNP
            minNumber: 1
            maxNumber: 31
            onIndexChanged: selectedDay = t_number
        }

        ScrollNumberPicker
        {
            id: monthSNP
            minNumber: 1
            maxNumber: 12
            onIndexChanged: selectedMonth = t_number
        }

        ScrollNumberPicker
        {
            id: yearSNP
            minNumber: 1900
            maxNumber: 2200
            onIndexChanged: selectedYear = t_number+1899
        }
    }

    Rectangle
    {
        id: proceedButton
        opacity: clickableArea.pressed ? 0.8 : 1
        width: parent.width * 0.25
        height: buttonText.height*2
        radius: Vars.defaultRadius
        color: Vars.fontsPurple
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.05
        anchors.horizontalCenter: parent.horizontalCenter

        FontLoader
        {
            id: mediumText;
            source: Vars.mediumFont
        }

        Text
        {
            id: buttonText
            text: Vars.proceed
            font.family: mediumText.name
            font.pixelSize: Helper.toDp(Vars.defaultFontPixelSize,
                                        Vars.dpi)
            color: Vars.backgroundBlack
            anchors.centerIn: parent
        }

        MouseArea
        {
            id: clickableArea
            anchors.fill: parent
        }
    }

    onVisibleChanged:
    {
        if(visible === true)
        {
            daySNP.setDefault(Vars.defaultDay);
            monthSNP.setDefault(Vars.defaultMonth);
            yearSNP.setDefault(Vars.defaultYear);
        }
    }
}
