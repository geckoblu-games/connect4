QT += quick quickcontrols2 concurrent

CONFIG += c++11 \
        file_copies

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

TARGET = blu-connect4

SOURCES += \
        src/brain/Solver.cpp \
        src/gamemodel.cpp \
        src/main.cpp

RESOURCES += qml.qrc \
    sounds/sounds.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /usr/local/games
!isEmpty(target.path): INSTALLS += target

DISTFILES +=

HEADERS += \
    src/brain/Move.hpp \
    src/brain/MoveChooser.hpp \
    src/brain/MoveSorter.hpp \
    src/brain/OpeningBook.hpp \
    src/brain/Position.hpp \
    src/brain/Solver.hpp \
    src/brain/TranspositionTable.hpp \
    src/gamemodel.hpp \
    src/levelclass.hpp

INSTALLS += openings

openings.files = $$files( src/brain/7x6*.book)
openings.path = $$target.path

