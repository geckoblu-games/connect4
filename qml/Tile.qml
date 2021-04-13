import QtQuick 2.12
import QtGraphicalEffects 1.12

Item {
    id: item

    width: board.tilesize;
    height: width;   

    Image {
        id: tile
        source: "/images/tile.svg"
        sourceSize: Qt.size(parent.width, parent.height)
        //smooth: true
    }    

    HueSaturation {
        id: saturation
        anchors.fill: tile
        source: tile
        hue: 0.0
        saturation: 0.0
        lightness: 0.0
    }

    Rectangle {
        id: frame1
        anchors.fill: parent;
        color: 'transparent'
        border.color: mainWindow.light_blue2
        border.width: 4
        visible: false
    }    

    function highlight(flag) {
        if (flag === true) {
            saturation.lightness = +0.08
        } else {
            saturation.lightness = 0.0
        }
    }

    function evidence1(flag) {
        frame1.visible = flag
    }

}

