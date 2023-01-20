import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Controls.Material
import Qt.labs.settings

import connect4 1.0

Window {
    id: mainWindow
    width: background.width
    height: background.height
    minimumWidth: background.width
    minimumHeight: background.height
    visible: false
    title: qsTr("Connect4")
    color: delta > 50 ? dark_blue : blue

    readonly property string version: '0.1'
    readonly property color dark_blue: '#1463be'
    readonly property color blue: '#1976d2'
    readonly property color light_blue: '#2196f3'
    readonly property color light_blue2: '#43a6f6'
    readonly property color dark_yellow: '#fbc02d'

    Material.background: dark_blue
    Material.foreground: 'black'
    Material.accent: dark_yellow
    Material.primary: Material.Purple

    property int firstPlayerType: Enums.PlayerType.HUMAN

    Settings {
        id: settings
        property int ai_level: Level.Easy
        property int firstPlayerMode: Enums.FirstPlayerMode.ALTERNATE

        property bool playSounds: true

        property int mainWindowX: (Screen.width - width) / 2
        property int mainWindowY: (Screen.height - height) / 2
    }

    property int delta: Math.max(mainWindow.width - background.width, mainWindow.height - background.height)

    Rectangle {
        id: background
        width: (board.width * 3)/2 + 20
        height: board.height + 20
        color: blue
        radius: delta > 50 ? 10 : 0

        anchors.centerIn: parent

        focus: true

        Item {
            id: frame
            anchors.fill: parent
            anchors.margins: 10

            Board {
                id: board
                objectName: "board" // For findChild to work

                anchors.right: parent.right
                anchors.bottom: parent.bottom
            }

            RoundButton {
                id: buttonMenu
                icon.name: 'menu'
                Material.elevation: 1
                Material.background: dark_blue
                //Material.foreground: "white"
                anchors.top: parent.top
                anchors.left: parent.left
                onClicked: drawer.open()
            }

            Item {
                id: leftPane

                anchors.top: buttonMenu.bottom
                anchors.left: parent.left
                anchors.right: board.left
                anchors.rightMargin: 10
                anchors.bottom: parent.bottom
                PlayerRect {
                    id: playerR1
                    text: firstPlayerType === Enums.PlayerType.HUMAN ? qsTr('You') : qsTr('AI')
                    source: '/images/red.svg'
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 20
                    highlight: true
                }

                PlayerRect {
                    id: playerR2
                    text: firstPlayerType === Enums.PlayerType.HUMAN ? qsTr('AI') : qsTr('You')
                    source: '/images/yellow.svg'
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: playerR1.bottom
                    anchors.topMargin: 20
                    highlight: !playerR1.highlight
                }

                WinnerRect {
                    id: winnerR
                    anchors.top: playerR2.bottom
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.margins: 20

                    //winner: 0
                }
            }
        }

        Drawer {
            id: drawer
            width: leftPane.width
            height: mainWindow.height
            Material.background: blue

            ListView {
                id: listView

                focus: true
                currentIndex: -1
                anchors.fill: parent

                delegate: ItemDelegate {
                    width: parent.width
                    text: model.title
                    highlighted: ListView.isCurrentItem
                    onClicked: {
                        drawer.close();
                        if (model.action === 'settings') {
                            dialogSetting.show();
                        } else if (model.action === 'about') {
                            dialogAbout.open();
                        }
                    }
                }

                model: ListModel {
                    ListElement { title: qsTr('Settings'); action: 'settings' }
                    ListElement { title: qsTr('About'); action: 'about' }
                }
            }
        }


        DialogSettings {id: dialogSetting }

        DialogAbout {id: dialogAbout }

        Component.onCompleted: {
            contentItem.Keys.forwardTo = board;
        }

    }

    function newGame() {
        winnerR.winner = -1;
        board.clear();

        gamemodel.newGame();

        switch (settings.firstPlayerMode) {
        case Enums.FirstPlayerMode.ALWAYSAI:
            firstPlayerType = Enums.PlayerType.AI;
            break;
        case Enums.FirstPlayerMode.ALWAYSYOU:
            firstPlayerType = Enums.PlayerType.HUMAN;
            break;
        case Enums.FirstPlayerMode.ALTERNATE:
            if (firstPlayerType === Enums.PlayerType.HUMAN) {
                firstPlayerType = Enums.PlayerType.AI;
            } else {
                firstPlayerType = Enums.PlayerType.HUMAN;
            }
            break;
        case Enums.FirstPlayerMode.RANDOM:
            firstPlayerType = Math.floor(Math.random() * 2);
            break;
        }

        board.setPlayer1Type(firstPlayerType);

    }

    Component.onCompleted: {
        x = settings.mainWindowX;
        y = settings.mainWindowY;

        gamemodel.setLevel(settings.ai_level);

        if (settings.firstPlayerMode === Enums.FirstPlayerMode.ALTERNATE) {
            firstPlayerType = Enums.PlayerType.AI; // Will be reverted to HUMAN on newGame()
        }

        visible = true;
    }

    Component.onDestruction: {
        settings.mainWindowX = x;
        settings.mainWindowY = y;
    }
}
