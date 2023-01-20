import QtQuick

Rectangle {
    id: rect1
    width: 200
    height: 48
    color: mainWindow.dark_blue //'#42a5f5'
    border.color: highlight ? mainWindow.dark_yellow : mainWindow.dark_blue //'#1b86e4'
    border.width: 2
    radius: height / 2

    property alias text: text1.text
    property alias source: image1.source

    property bool highlight

    Image {
        id: image1
        sourceSize.height: 26
        sourceSize.width: 26
        anchors.verticalCenter: parent.verticalCenter
        x: 26
    }

    Text {
        id: text1
        //font.family: "Helvetica"
        font.pointSize: 20
        //color: "red"
        anchors.centerIn: parent
    }

}
