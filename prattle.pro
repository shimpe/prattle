TEMPLATE = app

QT += qml quick widgets multimedia

CONFIG += c++11

SOURCES += main.cpp \
    marytts.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

DISTFILES +=

HEADERS += \
    marytts.h
