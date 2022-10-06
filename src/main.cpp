#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlApplicationEngine>
#include <QLoggingCategory>

#include "weatherdata.h"
#include "livedata.h"
#include "phidgetqml.h"
#include "fileio.h"

int main(int argc, char *argv[])
{
    QLoggingCategory::setFilterRules("wapp.*.debug=false");

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    qmlRegisterType<WeatherData>("Weather", 1, 0, "WeatherData");
    qmlRegisterType<AppModel>("Weather", 1, 0, "AppModel");
    qRegisterMetaType<WeatherData>();

    qmlRegisterType<PhidgetQml>("PhidgetFeedback", 1, 0, "PhidgetQml");
    qmlRegisterType<FileIO>("FileIO", 1, 0, "FileIO");

    qmlRegisterType<LiveData>("LiveVehicleData", 1, 0, "LiveData");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
