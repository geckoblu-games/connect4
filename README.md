# Connect4
Play the classic [Connect Four](https://en.wikipedia.org/wiki/Connect_Four) game against an AI!

## Screenshot

<img src="./screenshot.png?raw=true" alt="Screenshot" height="200"/>

## ToDo

* Port to Qt 6

## Build
The Qt libraries (version >= 5.12 but < 6.0) are required. Make sure that they are installed on your system.

    qmake -o Makefile connect4.pro
    make

Remember to copy the 7x6*.book(s) alongside the executable

## Credits

* The AI is based on [Connect 4 Game Solver](https://github.com/PascalPons/connect4) by Pascal Pons
* Sounds from [connect4](https://github.com/code-monk08/connect4) by Mayank Singh
    
## License
connect4-qml is licensed under the [GPL v3.0](http://www.gnu.org/licenses/gpl-3.0.en.html) or later. 
