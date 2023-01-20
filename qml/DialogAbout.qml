import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Controls.Material

Dialog {
    id: aboutDialog
    title: "About"

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    // width: Math.round(Math.min(mainWindow.width, mainWindow.height) / 3 * 2)
    modal: true
    focus: true

    background: Rectangle {
        color: blue
    }

    header: Item {
        height: text.height


        Text {
            id: text
            text: qsTr("Connect4")
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            font.pixelSize: 16
        }
    }


    footer: DialogButtonBox {
        Material.background: blue
        Button {
            id: btn1
            text: qsTr("OK")
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            Material.background: dark_blue
            Material.foreground: 'black'
        }

    }

    onRejected: {
        aboutDialog.close()
    }

    Column {
        id: aboutColumn
        spacing: 20
        //Layout.alignment: Qt.AlignHCenter
        width: contentItem.width

        Image {
            source: 'qrc:/images/connect4.svg'
            width: btn1.width
            height: width

            anchors.horizontalCenter: parent.horizontalCenter

            visible: true;
        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter

            text: qsTr('v') + ' ' + '0.1'

        }

        Text {
            horizontalAlignment: Text.AlignHCenter
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 10

            text:qsTr(
'by<br/>
<a href="https://www.geckoblu.net">geckoblu</a><br/>
<br/>' +
qsTr('Released under') +  ' <a href="http://www.gnu.org/licenses/gpl-3.0.en.html">GPL v3.0</a> ' + qsTr('or later.') + '<br/>
<br/>' +
qsTr('More info and credits at:') + '<br/>
<a href="https://github.com/geckoblu-games/connect4-qml">connect4-qml</a><br>
<br/>
')

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.NoButton // we don't want to eat clicks on the Text
                cursorShape: parent.hoveredLink ? Qt.PointingHandCursor : Qt.ArrowCursor
            }

            onLinkActivated: Qt.openUrlExternally(link)

        }
    }
}
