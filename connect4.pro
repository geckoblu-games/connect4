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
else: unix:!android: target.path = /opt/$${TARGET}/bin
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

OTHER_FILES += \
    src/brain/7x6.book \
    src/brain/7x6_mini.book \
    src/brain/7x6_small.book

COPIES +=  openings
#INSTALLS += openings

openings.files = $$OTHER_FILES # $$files( src/brain/7x6*.book)
openings.path = $$OUT_PWD # $$target.path

# # copies the given files to the destination directory
# defineTest(copyToDestDir) {
#     files = $$1
#     dir = $$2
#     # replace slashes in destination path for Windows
#     win32:dir ~= s,/,\\,g
#
#     for(file, files) {
#         file = $$PWD/$$file
#         # replace slashes in source path for Windows
#         win32:file ~= s,/,\\,g
#
#         QMAKE_POST_LINK += $$QMAKE_COPY $$shell_quote($$file) $$shell_quote($$dir) $$escape_expand(\\n\\t)
#     }
#
#     export(QMAKE_POST_LINK)
# }
#
# copyToDestDir($$OTHER_FILES, $$OUT_PWD)
