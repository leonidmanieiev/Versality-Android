import "../"
import QtQuick 2.11
import QtQuick.Controls 2.4
import "../js/toDipConverter.js" as Convert

AbstractButton
{
    property string buttonText: indefined

    id: controlButton
    text: qsTr(buttonText)
    background: ControlBackground { }
    contentItem: Label
    {
        id: labelContent
        clip: true
        text: buttonText
        font.pixelSize: Convert.toDp(Style.screenWidth*0.015, Style.dpi)
        color: Style.mainPurple
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
}
