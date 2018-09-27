import "../"
import QtQuick 2.11
import "../js/toDp.js" as Convert

Canvas
{
    property real w: 0
    property real h: 0
    property real sX: 0
    property real sY: h
    property real eX: w
    property real eY: h
    property real cp1x: Convert.toDp(100, Style.dpi)
    property real cp1y: Convert.toDp(100, Style.dpi)
    property real cp2x: Convert.toDp(1000, Style.dpi)
    property real cp2y: Convert.toDp(1000, Style.dpi)

    id: bezierCanvas
    width: w
    height: h
    onPaint:
    {
        var ctx = getContext("2d");
        ctx.strokeStyle = Style.mainPurple;
        ctx.fillStyle = Style.mainPurple;
        ctx.lineWidth = Convert.toDp(1, Style.dpi);
        ctx.beginPath();
        ctx.moveTo(sX, sY);
        ctx.bezierCurveTo(cp1x, cp1y, cp2x, cp2y, eX, eY);
        ctx.closePath();
        ctx.fill();
        ctx.stroke();
    }
}
