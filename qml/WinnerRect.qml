import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

Item {
    id: root

    property int winner: -1

    visible: winner >= 0 && winner <= 2

    Item {
        id: rect1
        height: btnNewGame.height
        width: height
        Image {
            id: image1
            sourceSize.height: parent.height
            sourceSize.width: parent.width
        }
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Text {
        id: text1
        //font.family: "Helvetica"
        font.pointSize: 20
        text: ''
        color: dark_yellow

        anchors.top: rect1.bottom
        //anchors.topMargin: 4
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button {
        id: btnNewGame
        text: qsTr('New Game')
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        Material.background: dark_yellow
        visible: false
        onClicked: mainWindow.newGame()
    }

    onWinnerChanged: {
        switch(winner) {
        case 0: // Draw
            text1.text = qsTr('Drawn!');
            btnNewGame.visible = true;
            image1.source = '';
            break;
        case 1: // Player 1 wins
            text1.text = qsTr('Wins!');
            btnNewGame.visible = true;
            image1.source = '/images/red.svg';
            break;
        case 2: // Player 2 wins
            text1.text = qsTr('Wins!');
            btnNewGame.visible = true;
            image1.source = '/images/yellow.svg';
            break;
        default: // Continue the game
            text1.text = '';
            btnNewGame.visible = false;
            image1.source = '';
        }
    }
}

