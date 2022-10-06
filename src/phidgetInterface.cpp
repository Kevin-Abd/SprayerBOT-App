#include <phidget22.h>
#include "phidgetInterface.h"
#include<QDebug>
#include <string>


PhidgetInterface::PhidgetInterface(){

    serialNo = 528564;

    //Enable server discovery to allow your program to find other Phidgets on the local network.
    //PhidgetNet_enableServerDiscovery(PHIDGETSERVER_DEVICEREMOTE);
    //Register a network server that your program will try to connect to.
    PhidgetNet_addServer("serverName", "localhost", 5661, "", 0);
    // PhidgetNet_addServer("serverName", "localhost", 5661, "", 0);


    //Create your Phidget channels
    pPhidget = new PhidgetDigitalOutputHandle();
    PhidgetDigitalOutput_create(pPhidget);

    //Set addressing parameters to specify which channel to open (if any)
    Phidget_setIsHubPortDevice((PhidgetHandle)*pPhidget, 1);
    Phidget_setHubPort((PhidgetHandle)*pPhidget, 0);
    Phidget_setIsRemote((PhidgetHandle)*pPhidget, 1);
    Phidget_setDeviceSerialNumber((PhidgetHandle)*pPhidget, serialNo);


}


PhidgetInterface::~PhidgetInterface(){
    //Close your Phidgets once the program is done.
    Phidget_close((PhidgetHandle)*pPhidget);
    PhidgetDigitalOutput_delete(pPhidget);
}



bool PhidgetInterface::setHandlers(Phidget_OnAttachCallback handlerAttach, Phidget_OnDetachCallback handlerDetach, void *ctx){
    //Assign any event handlers you need before calling open so that no events are missed.
    Phidget_setOnAttachHandler((PhidgetHandle)*pPhidget, handlerAttach, ctx);
    Phidget_setOnDetachHandler((PhidgetHandle)*pPhidget, handlerDetach, ctx);
    return true;
}


bool PhidgetInterface::open(){
    //Open your Phidgets and wait for attachment
    PhidgetReturnCode code = Phidget_openWaitForAttachment((PhidgetHandle)*pPhidget, 20000);
    // qDebug("openAttached Result: ");
    // qDebug(std::to_string(int(code)).c_str());
    return true;
}


int PhidgetInterface::getState() {
    return state;
}


bool PhidgetInterface::activate(){
    PhidgetReturnCode code = PhidgetDigitalOutput_setState(*pPhidget, 1);
    if (code == EPHIDGET_OK)
    {
        state = 1;
        return true;
    }
    else
        return false;
}

bool PhidgetInterface::deactivate(){
    PhidgetReturnCode code = PhidgetDigitalOutput_setState(*pPhidget, 0);
    if (code == EPHIDGET_OK)
    {
        state = 0;
        return true;
    }
    else
        return false;
}
