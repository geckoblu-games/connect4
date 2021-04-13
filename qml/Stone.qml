import QtQuick 2.12
import QtMultimedia 5.15

Item {
    id: stone

    readonly property int fallDuration: 500

    width: board.tilesize;
    height: width;

    x: width * column
    y: 0

    property int row
    property int column
    property int player;

    property alias fall: fall

    Image {
        id: stoneImg
        source: player === 1 ? "/images/red.svg" : "/images/yellow.svg"
        sourceSize: Qt.size(parent.width, parent.height)
        //smooth: true
    }

    SoundEffect {
        id: playSound
        source: "qrc:/disc_drop_1.wav"
    }

    NumberAnimation {
        id: fall
        target: stone
        properties: 'y'
        to: height * (board.rows - row - 1);
        duration: (fallDuration / board.rows) * (board.rows - row)

        onFinished: {
            if (settings.playSounds) {
                playSound.play();
            }
            board.playEnd(player, column, row);
        }
    }

}
