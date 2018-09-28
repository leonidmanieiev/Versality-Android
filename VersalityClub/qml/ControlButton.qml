import "../"
import "../js/toDp.js" as Convert
import QtQuick 2.11
import QtQuick.Controls 2.4

AbstractButton
{
    property string buttonText: undefined
    property color labelContentColor: Style.mainPurple
    property color backgroundColor: Style.backgroundWhite

    id: controlButton
    text: qsTr(buttonText)
    background: ControlBackground
    {
        color: backgroundColor
    }
    contentItem: Label
    {
        id: labelContent
        clip: true
        text: buttonText
        font.pixelSize: Convert.toDp(20, Style.dpi)
        color: labelContentColor
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
