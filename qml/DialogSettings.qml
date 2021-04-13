import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Material 2.12

import connect4 1.0

Dialog {
    id: settingsDialog
    title: "Settings"

    x: Math.round((mainWindow.width - width) / 2)
    y: Math.round(mainWindow.height / 6)
    width: Math.round(Math.min(mainWindow.width, mainWindow.height) / 3 * 2)
    modal: true
    focus: true

    background: Rectangle {
        color: blue
    }

    header: Item {
        height: text.height
        Text {
            id: text
            text: qsTr("Settings")
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
            font.pixelSize: 16
        }
    }

    footer: DialogButtonBox {
        Material.background: blue
        Button {
            text: qsTr("Apply")
            DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
            Material.background: dark_blue
            Material.foreground: 'black'
        }
        Button {
            text: qsTr("Cancel")
            DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
            Material.background: dark_blue
            Material.foreground: 'black'
        }

        //onAccepted: console.log("Apply clicked")
        //onRejected: console.log("Cancel clicked")
    }

    onAccepted: {
        //console.log("Apply clicked", levelBox.currentIndex)
        settings.ai_level = levelBox.currentIndex;
        settings.firstPlayerMode = firstPlayerBox.currentIndex;
        gamemodel.setLevel(settings.ai_level);
        settings.playSounds = (chkSounds.checkState === Qt.Checked)
        settingsDialog.close();
    }

    onRejected: {
        //console.log("Cancel clicked")
        settingsDialog.close()
    }

    contentItem: GridLayout {
        id: grid
        columns: 2

        Label {
            text: "Level:"
        }

        ComboBox {
            id: levelBox
            Material.background: dark_blue

            textRole: "key"
            model: ListModel {
                ListElement { key: qsTr("Easy"); value: Level.Easy }
                ListElement { key: qsTr("Normal"); value: Level.Normal }
                ListElement { key: qsTr("Hard"); value: Level.Hard }
                ListElement { key: qsTr("Expert"); value: Level.Expert }
            }
            Component.onCompleted: {
                currentIndex = settings.ai_level;
            }
            Layout.fillWidth: true
        }

        Label {
            text: "First Player:"
        }

        ComboBox {
            id: firstPlayerBox
            Material.background: dark_blue

            textRole: "key"
            model: ListModel {
                ListElement { key: qsTr("Always You"); value: Enums.FirstPlayerMode.ALWAYSYOU }
                ListElement { key: qsTr("Always AI"); value: Enums.FirstPlayerMode.ALWAYSAI }
                ListElement { key: qsTr("Alternate"); value: Enums.FirstPlayerMode.ALTERNATE }
                ListElement { key: qsTr("Random"); value: Enums.FirstPlayerMode.RANDOM }
            }
            Component.onCompleted: {
                currentIndex = settings.firstPlayerMode;
            }
            Layout.fillWidth: true
        }

        Label {
            text: "Sounds:"
        }

        CheckBox {
            id: chkSounds
            checked: settings.playSounds

            Material.accent: mainWindow.dark_blue
        }

        Label {
            text: " "
            horizontalAlignment: Label.AlignHCenter
            verticalAlignment: Label.AlignVCenter
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    function show() {
        chkSounds.checked =  settings.playSounds;
        firstPlayerBox.currentIndex = settings.firstPlayerMode;
        levelBox.currentIndex = settings.ai_level;
        open();
    }
}
