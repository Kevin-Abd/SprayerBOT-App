QT += quick location positioning multimedia

CONFIG += c++11 resources_big

TEMPLATE = app

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        livedata.cpp \
        main.cpp \
        weatherdata.cpp

RESOURCES += qml.qrc \
          qtquickcontrols2.conf \
          nmea_log.txt \
          media \

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    qtquickcontrols2.conf \

HEADERS += \
    livedata.h \
    weatherdata.h

INCLUDEPATH += C:/OpenSSL-Win32/include

win32:CONFIG(release, debug|release): LIBS += -L$$PWD/../lib/phidget22-windevel/lib/c/x64/ -lphidget22
else:win32:CONFIG(debug, debug|release): LIBS += -L$$PWD/../lib/phidget22-windevel/lib/c/x64/ -lphidget22

INCLUDEPATH += $$PWD/../lib/phidget22-windevel/lib/c/
INCLUDEPATH += $$PWD/../lib/phidget22-windevel/lib/c/x64
DEPENDPATH += $$PWD/../lib/phidget22-windevel/lib/c/x64
