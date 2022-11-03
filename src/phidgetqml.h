#ifndef PHIDGETQML_H
#define PHIDGETQML_H

#include <QObject>
#include "phidgetInterface.h"
class PhidgetQml : public QObject
{
    Q_OBJECT
public:
    explicit PhidgetQml(QObject *parent = nullptr);
    Q_INVOKABLE bool activate();
    Q_INVOKABLE bool deactivate();
    Q_INVOKABLE int getState();

    static void CCONV onAttach(PhidgetHandle ch, void * ctx);
    static void CCONV onDetach(PhidgetHandle ch, void * ctx);

signals:
   void attached();
   void detached();

private:
   PhidgetInterface *phidget;
};

#endif // PHIDGETQML_H
