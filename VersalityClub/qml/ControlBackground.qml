import "../"
import QtQuick 2.11

Rectangle
{
    property real h: Style.screenHeight*0.09
    property real w: Style.screenWidth*0.8
    property int r: h*0.5
    property color fillColor: Style.backgroundWhite
    property color borderColor: Style.mainPurple
    property int borderWidth: h*0.06

    id: controlBackground
    height: h
    width: w
    radius: r
    color: fillColor
    border.color: borderColor
    border.width: borderWidth
    anchors.centerIn: parent
}
