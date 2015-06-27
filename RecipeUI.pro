TEMPLATE = app

QT += qml quick widgets

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

QMAKE_CXXFLAGS += -Wall -Werror -Wextra -pedantic -pedantic-errors -static

QMAKE_CXXFLAGS_DEBUG += -O1 -ggdb

QMAKE_CXXFLAGS_RELEASE += -O3

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS +=
