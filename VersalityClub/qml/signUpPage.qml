import "../"
import "../js/toDp.js" as Convert
import QtQuick 2.11
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import QtQuick.Controls.Styles 1.4

Page
{
    id: signUpPage
    focus: true
    height: Style.screenHeight
    width: Style.screenWidth

    BezierCurve
    {
        id: headerCanvas
        w: parent.width
        h: parent.height/6
        sY: 0
        eY: 0
        cp1x: 0
        cp1y: h
        cp2x: w
        cp2y: h*0.5
    }

    Label
    {
        id: signUpTextHeader
        text: qsTr("Регистрация")
        font.pixelSize: Convert.toDp(14, Style.dpi)
        color: Style.backgroundWhite
        anchors.top: headerCanvas.top
        anchors.topMargin: Convert.toDp(10, Style.dpi)
        anchors.horizontalCenter: parent.horizontalCenter
    }

    ColumnLayout
    {
        id: middleFieldsColumn
        anchors.top: headerCanvas.bottom
        spacing: Style.screenHeight*0.05
        width: parent.width
        anchors.verticalCenter: parent.verticalCenter

        Label
        {
            id: sexLabel
            clip: true
            text: qsTr("Пол:")
            font.pixelSize: Convert.toDp(15, Style.dpi)
            color: Style.mainPurple
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        ControlButton
        {
            id: sexButton
            Layout.fillWidth: true
            buttonText: qsTr("Нажми")
            labelContentColor: Style.backgroundBlack
            onClicked: buttonText === "М" ? buttonText = "Ж" : buttonText = "М"
        }

        Label
        {
            id: dateofbirthLabel
            clip: true
            text: qsTr("Дата рождения:")
            font.pixelSize: Convert.toDp(15, Style.dpi)
            color: Style.mainPurple
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        TextField
        {
            id: dateofbirthField
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            background: ControlBackground  { }
            font.pixelSize: Convert.toDp(15, Style.dpi)
            color: Style.backgroundBlack
            inputMask: "00.00.0000"
            /*Text
            {
                id: placeholder
                text: qsTr("29.08.1997")
                font.pixelSize: Convert.toDp(15, Style.dpi)
                color: Style.backgroundBlack
                anchors.centerIn: dateofbirthField
                visible: !dateofbirthField.text
            }*/
        }

        Label
        {
            id: emailLabel
            clip: true
            text: qsTr("E-mail:")
            font.pixelSize: Convert.toDp(15, Style.dpi)
            color: Style.mainPurple
            Layout.fillWidth: true
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        TextField
        {
            id: emailField
            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            background: ControlBackground  { }
            font.pixelSize: Convert.toDp(15, Style.dpi)
            color: Style.backgroundBlack
            placeholderText: "*********@****.***"
        }

        ControlButton
        {
            id: signUpButton
            padding: Style.screenHeight*0.08
            Layout.fillWidth: true
            buttonText: "ЗАРЕГИСТРИРОВАТЬСЯ"
            labelContentColor: Style.backgroundWhite
            backgroundColor: Style.mainPurple
            onClicked: signLogLoader.source = "signUpPage.qml"
        }
    }
}
