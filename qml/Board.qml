import QtQuick

Rectangle {
    id: root

    readonly property int tilesize: 64
    readonly property int columns: 7 // TODO: bind to gamemodel
    readonly property int rows: 6 // TODO: bind to gamemodel
    readonly property int offset: 8

    width: tilesize * columns + offset * 2 // 456
    height: tilesize * rows + offset * 2 // 392

    color:  mainWindow.light_blue
    radius: 16

    property int selectedColumn: 3
    property bool sensitive: true

    //property var stoneComponent
    property var tiles
    property var stones
    property int nStone: 0
    property int evidenceColumn: 0
    property int evidenceRow: 0

    property var playerType: [0, 0, 0] // player1 and player2 type, index 0 is never used

    Rectangle {
        id: innerBoard
        color: mainWindow.blue
        anchors.fill: parent
        anchors.margins: offset

        Repeater {
            id: repeaterStones
            model: board.columns * board.rows
            Stone {
                visible: false
            }
        }

        Grid {
            columns: board.columns
            z: 100

            Repeater {
                id: repeaterTiles
                model: board.columns * board.rows
                Tile {}
            }

            Component.onCompleted: {
                //console.log("Board completed");

                tiles = new Array(board.columns);
                for(var c = 0; c < board.columns; c++) {
                    tiles[c] = new Array(board.rows);
                    for(var r = 0; r < board.rows; r++) {
                        tiles[c][r] = repeaterTiles.itemAt(c + board.columns * (board.rows - r - 1))
                    }
                }

                stones = new Array(board.columns * board.rows);
                for(var i = 0; i < stones.length; i++) {
                    stones[i] = repeaterStones.itemAt(i)
                }

                //console.log(selectedColumn)
                highlight(selectedColumn, true);
                //stoneComponent = Qt.createComponent("Stone.qml");
            }
        }

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            enabled: true
            hoverEnabled: true
            cursorShape: Qt.BlankCursor

            onPositionChanged: {
                if (sensitive) {
                    cursorShape =  Qt.ArrowCursor;
                    var sc =Math.floor(mouse.x / tilesize);
                    if (sc >= 0 && sc < columns) {
                        highlight(selectedColumn, false)
                        selectedColumn = sc
                        highlight(selectedColumn, true)
                    }
                }
            }

            onClicked: {
                if (sensitive) {
                    var sc =Math.floor(mouse.x / tilesize);
                    if (sc >= 0 && sc < columns) {
                        play(selectedColumn);
                    }
                }
            }
        }
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Left) {
            //console.log('Left')
            board.moveLeft()
        } else if (event.key === Qt.Key_Right) {
            //console.log('Right')
            board.moveRight()
        } else if (event.key === Qt.Key_Down) {
            //console.log('Down')
            board.moveDown()
        } else if (event.key === Qt.Key_Return) {
            //console.log('Enter')
            if(winnerR.visible) {
                newGame();
            } else {
                board.moveDown()
            }
        }
    }

    /**
     *
     */
    function clear() {
        // de-Evidence the last move
        tiles[evidenceColumn][evidenceRow].evidence1(false);
        evidenceColumn = 0;
        evidenceRow = 0;

        // de-Evidence the winning position
        for(var c = 0; c < board.columns; c++) {
            for(var r = 0; r < board.rows; r++) {
                tiles[c][r].evidence1(false);
            }
        }

        selectedColumn = 3;
        highlight(selectedColumn, true)

        for(var i = 0; i < stones.length; i++) {
            stones[i].visible = false;
        }
        nStone = 0;

        sensitive = true;
    }

    function moveLeft() {
        if (sensitive && selectedColumn > 0) {
            highlight(selectedColumn, false)
            selectedColumn = selectedColumn - 1
            highlight(selectedColumn, true)

            mouseArea.cursorShape = Qt.BlankCursor;
            //TODO: mouseArea.mouseX = selectedColumn * tilesize;
        }
    }

    function moveRight() {
        if (sensitive && selectedColumn < columns -1) {
            highlight(selectedColumn, false)
            selectedColumn = selectedColumn + 1
            highlight(selectedColumn, true)

            mouseArea.cursorShape = Qt.BlankCursor;
            //TODO: mouseArea.mouseX = selectedColumn * tilesize;
        }
    }

    function moveDown() {
        if (sensitive && gamemodel.canPlay(selectedColumn)) {
            play(selectedColumn);
        }
    }

    function play(column) {
        var row = gamemodel.play(column);
        if (row >= 0) {
            //console.log(player);
            //chooser.visible = false;
            sensitive = false;
            highlight(selectedColumn, false)
            dropStone(column, row);
        }
    }

    /**
     * This method is called asynchronously when a Stone has ended to fall
     */
    function playEnd(player, column, row) {

        // Evidence the last move
        tiles[evidenceColumn][evidenceRow].evidence1(false);
        tiles[column][row].evidence1(true);
        evidenceColumn = column;
        evidenceRow = row;

        var winner = gamemodel.whoWin();
        winnerR.winner = winner; // This trigger an event change on winner (listen by WinnerRect)
        switch(winner) {
        case 0: // Draw
            // do nothing else
            break;
        case 1:
        case 2: // Player 1 or 2 wins
            var wp = gamemodel.getWinningPosition();
            wp.forEach(function(move) {
                var c = move['column'];
                var r = move['row'];
                tiles[c][r].evidence1(true);
            });
            break;
        default: // Continue the game
            if (player === 1) {
                playerR1.highlight = false;
            } else {
                playerR1.highlight = true;
            }
            if (playerType[player] === Enums.PlayerType.HUMAN) {
                // let play AI
                gamemodel.chooseMove();
            } else {
                // let play HUMAN
                sensitive = true;
                highlight(selectedColumn, true)
            }
        }
    }

    /**
     * This method is called asynchronously when the AI choosed its next move
     */
    function moveChoosed(move) {

        if (move["column"] >= 0) {
            dropStone(move["column"], move["row"]);
        } else {
            console.log("Player 2 no moves allowed.")
        }
    }

    /**
     * Higlight the selected column
     */
    function highlight(column, flag) {
        for (var r = 0; r < board.rows ; r++) {
            tiles[column][r].highlight(flag);
        }
    }

    function dropStone(column, row) {
        var stone = stones[nStone++];
        stone.player = gamemodel.lastPlayer();
        stone.column = column;
        stone.row = row;
        stone.y = 0;
        stone.visible = true;
        stone.fall.start();
    }

    /**
     * Set the player1 type.
     * The player2 type is the opposite of player1 type.
     */
    function setPlayer1Type(player1Type) {
        if (player1Type === Enums.PlayerType.HUMAN) {
            playerType[1] = Enums.PlayerType.HUMAN;
            playerType[2] = Enums.PlayerType.AI;
            sensitive = true;
            highlight(board.selectedColumn, true)
        } else {
            playerType[1] = Enums.PlayerType.AI;
            playerType[2] = Enums.PlayerType.HUMAN;
            sensitive = false;
            highlight(board.selectedColumn, false)
            gamemodel.chooseMove();
        }

    }

}
