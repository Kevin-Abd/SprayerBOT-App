#ifndef PHIDGETINTERFACE_H
#define PHIDGETINTERFACE_H

#include <phidget22.h>

class PhidgetInterface{

private:
    int state;
    int serialNo;
    PhidgetDigitalOutputHandle*    pPhidget ;

public:
    PhidgetInterface();
    ~PhidgetInterface();

    bool setHandlers(Phidget_OnAttachCallback handlerAttach, Phidget_OnDetachCallback handlerDetach, void *ctx);
    bool opne();
    bool activate();
    bool deactivate();
    int getState();

};


#endif // PHIDGETINTERFACE_H
