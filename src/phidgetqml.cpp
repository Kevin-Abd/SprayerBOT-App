#include "phidgetqml.h"

PhidgetQml::PhidgetQml(QObject *parent) : QObject(parent)
{
    // qDebug("PhidgetQml Initilizing");
    phidget = new PhidgetInterface();
    // qDebug("PhidgetQml setting handlers");
    phidget->setHandlers(onAttach, onDetach, NULL);
    // qDebug("PhidgetQml openning");
    phidget ->opne();
    // qDebug("PhidgetQml done");
}


Q_INVOKABLE bool PhidgetQml::activate() {
    // qDebug("PhidgetQml activate invoked");
    return phidget->activate();
}

Q_INVOKABLE bool PhidgetQml::deactivate() {
    // qDebug("PhidgetQml deactivate invoked");
    return phidget->deactivate();
}

Q_INVOKABLE int PhidgetQml::getState() {
    return phidget->getState();
}


void CCONV PhidgetQml::onAttach(PhidgetHandle ch, void * ctx) {
    // qInfo("PhidgetQml Attached");
    // TODO call attached
}

void CCONV PhidgetQml::onDetach(PhidgetHandle ch, void * ctx) {
    // qInfo("PhidgetQml Deatached");
    // TODO call deattached
}

