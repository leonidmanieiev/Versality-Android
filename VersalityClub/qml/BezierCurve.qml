import QtQuick 2.11
import "../"

Canvas
{
    property real w: 0
    property real h: 0
    property real sX: 0
    property real sY: h
    property real eX: w
    property real eY: h
    property real cp1x: 100
    property real cp1y: 100
    property real cp2x: 1000
    property real cp2y: 1000

    id: bezierCanvas
    width: w
    height: h
    onPaint:
    {
        var ctx = getContext("2d");
        ctx.strokeStyle = Style.mainPurple;
        ctx.fillStyle = Style.mainPurple;
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.moveTo(sX, sY);
        ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, eX, eY);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
    }
}
