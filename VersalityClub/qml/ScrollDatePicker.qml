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
    height: Vars.screenHeight*0.4*Vars.iconHeightFactor
    color: Vars.birthdayPickerColor
    radius: Vars.defaultRadius

    Rectangle
    {
        id: chosenDateSubstrate
        width: parent.width
        height: Vars.screenHeight*0.07*Vars.iconHeightFactor
        color: Vars.chosenPurpleColor
        anchors.centerIn: rowLayout
    }

    function monthToNumber(month)
    {
        switch(month)
        {
            case 'Январь': return '01'
            case 'Февраль': return '02'
            case 'Март': return '03'
            case 'Апрель': return '04'
            case 'Май': return '05'
            case 'Июнь': return '06'
            case 'Июль': return '07'
            case 'Август': return '08'
            case 'Сентябрь': return '09'
            case 'Октябрь': return '10'
            case 'Ноябрь': return '11'
            case 'Декабрь': return '12'
            default: return Vars.defaultMonth
        }
    }

    RowLayout
    {
        id: rowLayout
        width: parent.width
        anchors.top: parent.top
        anchors.topMargin: parent.height * 0.05
        anchors.horizontalCenter: parent.horizontalCenter

        ScrollNumberPicker
        {
            id: daySNP
            minNumber: 1
            maxNumber: 31
            width: Vars.screenWidth*0.192
            Layout.alignment: Qt.AlignRight
            onIndexChanged: selectedDay = t_number
        }

        ScrollNumberPicker
        {
            id: monthSNP
            isMonthScroller: true
            width: Vars.screenWidth*0.25
            Layout.alignment: Qt.AlignHCenter
            onIndexChanged: selectedMonth = monthToNumber(t_number)
        }

        ScrollNumberPicker
        {
            id: yearSNP
            minNumber: 1900
            maxNumber: Helper.maxYearOfBirth()
            width: Vars.screenWidth*0.192
            Layout.alignment: Qt.AlignLeft
            onIndexChanged: selectedYear = t_number+1899
        }
    }

    Rectangle
    {
        id: proceedButton
        opacity: clickableArea.pressed ? 0.8 : 1
        width: parent.width * 0.65
        height: buttonText.height*2
        radius: height*0.5
        color: Vars.birthdayPickerColor
        border.color: Vars.whiteColor
        border.width: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)*0.2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: parent.height*0.05
        anchors.horizontalCenter: parent.horizontalCenter

        FontLoader
        {
            id: regularText;
            source: Vars.regularFont
        }

        Text
        {
            id: buttonText
            text: Vars.proceed
            font.family: regularText.name
            font.pixelSize: Helper.applyDpr(Vars.defaultFontPixelSize, Vars.dpr)
            color: Vars.whiteColor
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
