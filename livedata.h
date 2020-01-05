#ifndef LIVEDATA_H
#define LIVEDATA_H

#include <QObject>
#include <QString>
#include <QtNetwork/QNetworkReply>

class LiveDataPrivate;
class LiveData : public QObject
{
    // Set the properties of the class that can be accessed in qml
    Q_OBJECT
    Q_PROPERTY(bool ready READ ready NOTIFY readyChanged)
    Q_PROPERTY(double speed READ speed WRITE setSpeed NOTIFY speedChanged)
    Q_PROPERTY(bool pumpState READ pumpState WRITE setPumpState)
    Q_PROPERTY(bool nozzle1State READ nozzle1State WRITE setNozzle1State NOTIFY nozzle1StateChanged)
    Q_PROPERTY(bool nozzle2State READ nozzle2State WRITE setNozzle2State NOTIFY nozzle2StateChanged)
    Q_PROPERTY(bool nozzle3State READ nozzle3State WRITE setNozzle3State NOTIFY nozzle3StateChanged)
    Q_PROPERTY(bool nozzle4State READ nozzle4State WRITE setNozzle4State NOTIFY nozzle4StateChanged)
    Q_PROPERTY(bool nozzle5State READ nozzle5State WRITE setNozzle5State NOTIFY nozzle5StateChanged)
    Q_PROPERTY(bool nozzle6State READ nozzle6State WRITE setNozzle6State NOTIFY nozzle6StateChanged)
    Q_PROPERTY(double boomHeight READ boomHeight WRITE setBoomHeight NOTIFY boomHeightChanged)
    Q_PROPERTY(double applicationRate1 READ applicationRate1 WRITE setApplicationRate1
               NOTIFY applicationRate1Changed)
    Q_PROPERTY(double applicationRate2 READ applicationRate2 WRITE setApplicationRate2
               NOTIFY applicationRate2Changed)
    Q_PROPERTY(double tankLevel1 READ tankLevel1 WRITE setTankLevel1 NOTIFY tankLevel1Changed)
    Q_PROPERTY(double tankLevel2 READ tankLevel2 WRITE setTankLevel2 NOTIFY tankLevel2Changed)

public:
    explicit LiveData(QObject *parent = nullptr);
    ~LiveData();

    bool ready() const;
    double speed() const;
    bool pumpState() const;
    bool nozzle1State() const;
    bool nozzle2State() const;
    bool nozzle3State() const;
    bool nozzle4State() const;
    bool nozzle5State() const;
    bool nozzle6State() const;
    double boomHeight() const;
    double applicationRate1() const;
    double applicationRate2() const;
    double tankLevel1() const;
    double tankLevel2() const;

    void setSpeed(const double &value);
    void setPumpState(const bool &value);
    void setNozzle1State(const bool &value);
    void setNozzle2State(const bool &value);
    void setNozzle3State(const bool &value);
    void setNozzle4State(const bool &value);
    void setNozzle5State(const bool &value);
    void setNozzle6State(const bool &value);
    void setBoomHeight(const double &value);
    void setApplicationRate1(const double &value);
    void setApplicationRate2(const double &value);
    void setTankLevel1(const double &value);
    void setTankLevel2(const double &value);

signals:
    void speedChanged();
    void readyChanged();
    void nozzle1StateChanged();
    void nozzle2StateChanged();
    void nozzle3StateChanged();
    void nozzle4StateChanged();
    void nozzle5StateChanged();
    void nozzle6StateChanged();
    void boomHeightChanged();
    void applicationRate1Changed();
    void applicationRate2Changed();
    void tankLevel1Changed();
    void tankLevel2Changed();


private:
    double m_speed;
    bool m_pump;
    bool m_nozzle1;
    bool m_nozzle2;
    bool m_nozzle3;
    bool m_nozzle4;
    bool m_nozzle5;
    bool m_nozzle6;
    double m_boomHeight;
    double m_applicationRate1;
    double m_applicationRate2;
    double m_tankLevel1;
    double m_tankLevel2;
    LiveDataPrivate *p;

public slots:
    void queryServer();
    Q_INVOKABLE void startUpdates();
    Q_INVOKABLE void stopUpdates();

private slots:
    void networkSessionOpened();
    void handleServerResponse(QNetworkReply *reply);
};

#endif // LIVEDATA_H
