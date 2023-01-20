import QtQuick
//import QtGraphicalEffects 1.12


Item {
    id: item

    width: board.tilesize;
    height: width;   

    Image {
        id: tileImage
        source: "/images/tile.svg"
        sourceSize: Qt.size(parent.width, parent.height)
        visible: false
    }    

    ShaderEffect {
        id: huesat
        anchors.fill: parent;
        property variant source: tileImage
        property real lightness: 0.0
        property variant hsl: Qt.vector3d(0.0, 0.0, lightness)

        // vertexShader: "default.vert.qsb"
        fragmentShader: "huesaturation.frag.qsb"
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
        // console.log("Tile.highlight not woring");
        if (flag === true) {
            huesat.lightness = +0.1
        } else {
            huesat.lightness = 0.0
        }
    }

    function evidence1(flag) {
        frame1.visible = flag
    }

}

