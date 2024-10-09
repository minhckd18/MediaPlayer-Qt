QT += testlib
QT -= gui

CONFIG += qt console warn_on depend_includepath testcase
CONFIG -= app_bundle

TEMPLATE = app

SOURCES +=  \
    tst_songtest.cpp \
    ../../../MediaPlayer/Source/song.cpp

INCLUDEPATH += ../../../MediaPlayer/Source
