#include "livedata.h"

#include <qnetworkconfigmanager.h>
#include <qnetworksession.h>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

#include <QTimer>

class LiveDataPrivate
{
public:
    static const int minTimeBeforeNewRequest = 1000;
    QNetworkAccessManager *nam;
    int timeBeforeNewRequest;
    QTimer newDataTimer;
    QNetworkSession *ns;
    bool ready;

    QString speedValue, prevSpeed;
    QString prevPumpState, pumpValue;
    QString prevNozzle1State, n1;
    QString prevNozzle2State, n2;
    QString prevNozzle3State, n3;
    QString prevNozzle4State, n4;
    QString prevNozzle5State, n5;
    QString prevNozzle6State, n6;
    QString boomHeightValue, prevBoomHeight;
    QString applicationRate1, prevApplicationRate1;
    QString applicationRate2, prevApplicationRate2;
    QString tankLevel1, prevTankLevel1;
    QString tankLevel2, prevTankLevel2;

    LiveDataPrivate() :
        nam(nullptr),
        ns(nullptr),
        ready(false)
    {
        newDataTimer.setSingleShot(false);
    }
};

LiveData::LiveData(QObject *parent) :
    QObject(parent),
    p(new LiveDataPrivate)
{
    connect(&p->newDataTimer, SIGNAL(timeout()), this, SLOT(queryServer()));

    p->nam = new QNetworkAccessManager(this);

    QNetworkConfigurationManager ncm;
    p->ns = new QNetworkSession(ncm.defaultConfiguration(), this);
    connect(p->ns, SIGNAL(opened()), this, SLOT(networkSessionOpened()));

    if (p->ns->isOpen())
        this->networkSessionOpened();
    p->ns->open();
}

LiveData::~LiveData()
{
    p->ns->close();
    delete p;
}

void LiveData::networkSessionOpened()
{
    queryServer();
}

void LiveData::queryServer()
{
    QUrl url ("http://agbotwebserver.us-west-2.elasticbeanstalk.com/api/vehicle/1");

    QNetworkRequest request;
    request.setUrl(url);

    QNetworkReply *rep = p->nam->get(request);
    connect(rep, &QNetworkReply::finished, this,
            [this, rep]() { handleServerResponse(rep);});

}

void LiveData::startUpdates() {
    p->newDataTimer.start(p->minTimeBeforeNewRequest);
}

void LiveData::stopUpdates() {
    p->newDataTimer.stop();
    queryServer();
}

void LiveData::handleServerResponse(QNetworkReply *networkReply)
{
    if (networkReply->error()) {
        p->ready = false;
        emit readyChanged();
        queryServer();
    } else {
        QByteArray response = networkReply->readAll();
        response = response.replace("\\", "").replace(0, 1, "");
        response = response.replace(response.size() - 1, 1, "");

        QJsonParseError jsonError{};
        QJsonDocument document = QJsonDocument::fromJson(response, &jsonError);

        if(jsonError.error != QJsonParseError::NoError){
            qDebug() << "Error: " << jsonError.errorString();
        }

        if (document.isObject()) {
            QJsonObject obj = document.object();
            QJsonObject tempObj;
            QJsonValue val;

            if (obj.contains(QStringLiteral("Parameters"))) {
                val = obj.value(QStringLiteral("Parameters"));
                QJsonArray parameterArray = val.toArray();
                tempObj = parameterArray.at(1).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->speedValue = val.toString();

                if (p->speedValue != p->prevSpeed && p->speedValue.toDouble() >= 0) {
                    setSpeed(p->speedValue.toDouble());
                    p->prevSpeed = p->speedValue;
                }

                tempObj = parameterArray.at(15).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->pumpValue = val.toString();

                if (p->pumpValue != p->prevPumpState) {
                    if (p->pumpValue == "True") {
                        setPumpState(true);
                    } else {
                        setPumpState(false);
                    }
                    p->prevPumpState = p->pumpValue;
                }

                tempObj = parameterArray.at(16).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->n1 = val.toString();

                if (p->n1 != p->prevNozzle1State) {
                    if (p->n1 == "True") {
                        setNozzle1State(true);
                    } else {
                        setNozzle1State(false);
                    }
                    p->prevNozzle1State = p->n1;
                }

                tempObj = parameterArray.at(17).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->n2 = val.toString();

                if (p->n2 != p->prevNozzle2State) {
                    if (p->n2 == "True") {
                        setNozzle2State(true);
                    } else {
                        setNozzle2State(false);
                    }
                    p->prevNozzle2State = p->n2;
                }

                tempObj = parameterArray.at(18).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->n3 = val.toString();

                if (p->n3 != p->prevNozzle3State) {
                    if (p->n3 == "True") {
                        setNozzle3State(true);
                    } else {
                        setNozzle3State(false);
                    }
                    p->prevNozzle3State = p->n3;
                }

                tempObj = parameterArray.at(19).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->n4 = val.toString();

                if (p->n4 != p->prevNozzle4State) {
                    if (p->n4 == "True") {
                        setNozzle4State(true);
                    } else {
                        setNozzle4State(false);
                    }
                    p->prevNozzle4State = p->n4;
                }

                tempObj = parameterArray.at(20).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->n5 = val.toString();

                if (p->n5 != p->prevNozzle5State) {
                    if (p->n5 == "True") {
                        setNozzle5State(true);
                    } else {
                        setNozzle5State(false);
                    }
                    p->prevNozzle5State = p->n5;
                }

                tempObj = parameterArray.at(21).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->n6 = val.toString();

                if (p->n6 != p->prevNozzle6State) {
                    if (p->n6 == "True") {
                        setNozzle6State(true);
                    } else {
                        setNozzle6State(false);
                    }
                    p->prevNozzle6State = p->n6;
                }

                tempObj = parameterArray.at(22).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->boomHeightValue = val.toString();

                if (p->boomHeightValue != p->prevBoomHeight && p->boomHeightValue.toDouble() >= 0) {
                    setBoomHeight(p->boomHeightValue.toDouble());
                    p->prevBoomHeight = p->boomHeightValue;
                }

                tempObj = parameterArray.at(23).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->applicationRate1 = val.toString();

                if ((p->applicationRate1 != p->prevApplicationRate1 &&
                     p->applicationRate1.toDouble() >= 0) || m_speed >= 0) {
                    setApplicationRate1(p->applicationRate1.toDouble());
                    p->prevApplicationRate1 = p->applicationRate1;
                }

                tempObj = parameterArray.at(24).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->applicationRate2 = val.toString();

                if ((p->applicationRate2 != p->prevApplicationRate2 &&
                     p->applicationRate2.toDouble() >= 0.0) || m_speed >= 0.0) {
                    setApplicationRate2(p->applicationRate2.toDouble());
                    p->prevApplicationRate2 = p->applicationRate2;
                }

                tempObj = parameterArray.at(25).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->tankLevel1 = val.toString();

                if (p->tankLevel1 != p->prevTankLevel1 && p->tankLevel1.toDouble() >= 0.0) {
                    setTankLevel1(p->tankLevel1.toDouble());
                    p->prevTankLevel1 = p->tankLevel1;
                }

                tempObj = parameterArray.at(26).toObject();
                val = tempObj.value(QStringLiteral("Value"));
                p->tankLevel2 = val.toString();

                if (p->tankLevel2 != p->prevTankLevel2 && p->tankLevel2.toDouble() >= 0.0) {
                    setTankLevel2(p->tankLevel2.toDouble());
                    p->prevTankLevel2 = p->tankLevel2;
                }
            }
        }
    }
    if (!(p->ready)) {
        p->ready = true;
        emit readyChanged();
    }
    networkReply->deleteLater();
}

bool LiveData::ready() const
{
    return p->ready;
}

void LiveData::setSpeed(const double &value)
{
    m_speed = value;
    emit speedChanged();
    emit applicationRate1Changed();
    emit applicationRate2Changed();
}

double LiveData::speed() const
{
    return m_speed;
}

void LiveData::setPumpState(const bool &value)
{
    m_pump = value;
    emit nozzle1StateChanged();
    emit nozzle2StateChanged();
    emit nozzle3StateChanged();
    emit nozzle4StateChanged();
    emit nozzle5StateChanged();
    emit nozzle6StateChanged();
}

bool LiveData::pumpState() const
{
    return m_pump;
}

void LiveData::setNozzle1State(const bool &value)
{
    m_nozzle1 = value;
    emit nozzle1StateChanged();
}

bool LiveData::nozzle1State() const
{
    return m_nozzle1;
}

void LiveData::setNozzle2State(const bool &value)
{
    m_nozzle2 = value;
    emit nozzle2StateChanged();
}

bool LiveData::nozzle2State() const
{
    return m_nozzle2;
}

void LiveData::setNozzle3State(const bool &value)
{
    m_nozzle3 = value;
    emit nozzle3StateChanged();
}

bool LiveData::nozzle3State() const
{
    return m_nozzle3;
}

void LiveData::setNozzle4State(const bool &value)
{
    m_nozzle4 = value;
    emit nozzle4StateChanged();
}

bool LiveData::nozzle4State() const
{
    return m_nozzle4;
}

void LiveData::setNozzle5State(const bool &value)
{
    m_nozzle5 = value;
    emit nozzle5StateChanged();
}

bool LiveData::nozzle5State() const
{
    return m_nozzle5;
}

void LiveData::setNozzle6State(const bool &value)
{
    m_nozzle6 = value;
    emit nozzle6StateChanged();
}

bool LiveData::nozzle6State() const
{
    return m_nozzle6;
}

void LiveData::setBoomHeight(const double &value)
{
    m_boomHeight = value;
    emit boomHeightChanged();
}

double LiveData::boomHeight() const
{
    return m_boomHeight;
}

void LiveData::setApplicationRate1(const double &value)
{
    if (m_speed > 0) {
        m_applicationRate1 = value * (10000 / (60 * m_speed * 2.2));
    } else {
        m_applicationRate1 = 0;
    }
    emit applicationRate1Changed();
    emit nozzle1StateChanged();
    emit nozzle3StateChanged();
    emit nozzle4StateChanged();
    emit nozzle6StateChanged();
}

double LiveData::applicationRate1() const
{
    return m_applicationRate1;
}

void LiveData::setApplicationRate2(const double &value)
{
    if (m_speed > 0) {
        m_applicationRate2 = value * (10000 / (60 * m_speed * 2.2));
    } else {
        m_applicationRate2 = 0;
    }
    emit applicationRate2Changed();
    emit nozzle2StateChanged();
    emit nozzle5StateChanged();
}

double LiveData::applicationRate2() const
{
    return m_applicationRate2;
}

void LiveData::setTankLevel1(const double &value)
{
    m_tankLevel1 = value;
    emit tankLevel1Changed();
}

double LiveData::tankLevel1() const
{
    return m_tankLevel1;
}

void LiveData::setTankLevel2(const double &value)
{
    m_tankLevel2 = value;
    emit tankLevel2Changed();
}

double LiveData::tankLevel2() const
{
    return m_tankLevel2;
}
