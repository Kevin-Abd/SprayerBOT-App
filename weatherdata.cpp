/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/


#include "weatherdata.h"

#include <qgeopositioninfosource.h>
#include <qgeosatelliteinfosource.h>
#include <qnmeapositioninfosource.h>
#include <qgeopositioninfo.h>
#include <qnetworkconfigmanager.h>
#include <qnetworksession.h>

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QStringList>
#include <QTimer>
#include <QUrlQuery>
#include <QElapsedTimer>

/*
 *This application uses http://openweathermap.org/api
 **/

#define ZERO_KELVIN 273.15

WeatherData::WeatherData(QObject *parent) :
        QObject(parent)
{
}

WeatherData::WeatherData(const WeatherData &other) :
        QObject(nullptr),
        m_timeOfDay(other.m_timeOfDay),
        m_weather(other.m_weather),
        m_weatherDescription(other.m_weatherDescription),
        m_temperature(other.m_temperature),
        m_windSpeed(other.m_windSpeed),
        m_windDirection(other.m_windDirection)
{
}

QString WeatherData::timeOfDay() const
{
    return m_timeOfDay;
}

/*!
 * The icon value is based on OpenWeatherMap.org icon set. For details
 * see http://bugs.openweathermap.org/projects/api/wiki/Weather_Condition_Codes
 *
 * e.g. 01d ->sunny day
 *
 * The icon string will be translated to
 * http://openweathermap.org/img/w/01d.png
 */

QString WeatherData::weatherIcon() const
{
    return m_weather;
}

QString WeatherData::weatherDescription() const
{
    return m_weatherDescription;
}

QString WeatherData::windSpeed() const
{
    return m_windSpeed;
}

QString WeatherData::windDirection() const
{
    return m_windDirection;
}

QString WeatherData::temperature() const
{
    return m_temperature;
}

void WeatherData::setTimeOfDay(const QString &value)
{
    m_timeOfDay = value;
    emit dataChanged();
}

void WeatherData::setWeatherIcon(const QString &value)
{
    m_weather = value;
    emit dataChanged();
}

void WeatherData::setWeatherDescription(const QString &value)
{
    m_weatherDescription = value;
    emit dataChanged();
}

void WeatherData::setWindSpeed(const QString &value)
{
    m_windSpeed = value;
    emit dataChanged();
}

void WeatherData::setWindDirection(const QString &value)
{
    m_windDirection = value;
    emit dataChanged();
}

void WeatherData::setTemperature(const QString &value)
{
    m_temperature = value;
    emit dataChanged();
}

class AppModelPrivate
{
public:
    static const int baseMsBeforeNewRequest = 10 * 60 * 1000; // 10 mins as per https://openweathermap.org/appid
    QGeoPositionInfoSource *src;
    QGeoCoordinate coord;
    QString longitude, latitude;
    QString city;
    QNetworkAccessManager *nam;
    QNetworkSession *ns;
    WeatherData now;
    QList<WeatherData*> forecast;
    QQmlListProperty<WeatherData> *fcProp;
    bool ready;
    bool useGps;
    QElapsedTimer throttle;
    int nErrors;
    int minMsBeforeNewRequest;
    QTimer delayedCityRequestTimer;
    QTimer requestNewWeatherTimer;
    QString app_ident;

    AppModelPrivate() :
            src(nullptr),
            nam(nullptr),
            ns(nullptr),
            fcProp(nullptr),
            ready(false),
            useGps(true),
            nErrors(0),
            minMsBeforeNewRequest(baseMsBeforeNewRequest)
    {
        delayedCityRequestTimer.setSingleShot(false);
        delayedCityRequestTimer.setInterval(1000); // 1 s
        requestNewWeatherTimer.setSingleShot(false);
        requestNewWeatherTimer.setInterval(10*60*1000); // 10 min
        throttle.invalidate();
        app_ident = QStringLiteral("e7c5accef045351fb5c040b8db568c9b"); // api key from openweatherdata
        // 7a394909a7937711c783c53eb8f89c05 -> owned by Franklin Ogidi
    }
};

static void forecastAppend(QQmlListProperty<WeatherData> *prop, WeatherData *val)
{
    Q_UNUSED(val);
    Q_UNUSED(prop);
}

static WeatherData *forecastAt(QQmlListProperty<WeatherData> *prop, int index)
{
    auto *d = static_cast<AppModelPrivate*>(prop->data);
    return d->forecast.at(index);
}

static int forecastCount(QQmlListProperty<WeatherData> *prop)
{
    auto *d = static_cast<AppModelPrivate*>(prop->data);
    return d->forecast.size();
}

static void forecastClear(QQmlListProperty<WeatherData> *prop)
{
    static_cast<AppModelPrivate*>(prop->data)->forecast.clear();
}

AppModel::AppModel(QObject *parent) :
        QObject(parent),
        d(new AppModelPrivate)
{
    d->fcProp = new QQmlListProperty<WeatherData>(this, d,
                                                          forecastAppend,
                                                          forecastCount,
                                                          forecastAt,
                                                          forecastClear);

    connect(&d->delayedCityRequestTimer, SIGNAL(timeout()),
            this, SLOT(queryCity()));
    connect(&d->requestNewWeatherTimer, SIGNAL(timeout()),
            this, SLOT(refreshWeather()));
    d->requestNewWeatherTimer.start();

    // make sure we have an active network session
    d->nam = new QNetworkAccessManager(this);

    QNetworkConfigurationManager ncm;
    d->ns = new QNetworkSession(ncm.defaultConfiguration(), this);
    connect(d->ns, SIGNAL(opened()), this, SLOT(networkSessionOpened()));
    // the session may be already open. if it is, run the slot directly
    if (d->ns->isOpen())
        this->networkSessionOpened();
    // tell the system we want network
    d->ns->open();
}

AppModel::~AppModel()
{
    d->ns->close();
    if (d->src)
        d->src->stopUpdates();
    delete d;
}

void AppModel::networkSessionOpened()
{
    d->src = QGeoPositionInfoSource::createDefaultSource(this);

    if (d->src) {
        d->useGps = true;
        connect(d->src, SIGNAL(positionUpdated(QGeoPositionInfo)),
                this, SLOT(positionUpdated(QGeoPositionInfo)));
        connect(d->src, SIGNAL(error(QGeoPositionInfoSource::Error)),
                this, SLOT(positionError(QGeoPositionInfoSource::Error)));
        d->src->startUpdates();
    } else {
        d->useGps = false;
        d->city = "Winnipeg";
        emit cityChanged();
        this->refreshWeather();
    }
}

void AppModel::positionUpdated(QGeoPositionInfo gpsPos)
{
    d->coord = gpsPos.coordinate();

    if (!(d->useGps))
        return;

    queryCity();
}

void AppModel::queryCity()
{
    //don't update more often than once a minute
    //to keep load on server low
    if (d->throttle.isValid() && d->throttle.elapsed() < d->minMsBeforeNewRequest ) {
        if (!d->delayedCityRequestTimer.isActive())
            d->delayedCityRequestTimer.start();
        return;
    }
    d->throttle.start();
    d->minMsBeforeNewRequest = (d->nErrors + 1) * d->baseMsBeforeNewRequest;

    QString latitude, longitude;
    longitude.setNum(d->coord.longitude());
    latitude.setNum(d->coord.latitude());

    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    QUrlQuery query;

    query.addQueryItem("lat", latitude);
    query.addQueryItem("lon", longitude);
    query.addQueryItem("mode", "json");
    query.addQueryItem("APPID", d->app_ident);
    url.setQuery(query);
    QNetworkReply *rep = d->nam->get(QNetworkRequest(url));
    // connect up the signal right away
    connect(rep, &QNetworkReply::finished,
            this, [this, rep]() { handleGeoNetworkData(rep); });
}

void AppModel::positionError(QGeoPositionInfoSource::Error e)
{
    Q_UNUSED(e);
    qWarning() << "Position source error. Falling back to simulation mode.";
    // cleanup insufficient QGeoPositionInfoSource instance
    d->src->stopUpdates();
    d->src->deleteLater();
    d->src = nullptr;

    // activate simulation mode
    d->useGps = false;
    d->city = "Winnipeg";
    emit cityChanged();
    this->refreshWeather();
}

void AppModel::hadError(bool tryAgain)
{
    d->throttle.start();
    if (d->nErrors < 10)
        ++d->nErrors;
    d->minMsBeforeNewRequest = (d->nErrors + 1) * d->baseMsBeforeNewRequest;
    if (tryAgain)
        d->delayedCityRequestTimer.start();
}

void AppModel::handleGeoNetworkData(QNetworkReply *networkReply)
{
    if (!networkReply) {
        hadError(false); // should retry?
        return;
    }

    if (!networkReply->error()) {
        d->nErrors = 0;
        if (!d->throttle.isValid())
            d->throttle.start();
        d->minMsBeforeNewRequest = d->baseMsBeforeNewRequest;
        //convert coordinates to city name
        QJsonDocument document = QJsonDocument::fromJson(networkReply->readAll());

        QJsonObject jo = document.object();
        QJsonValue jv = jo.value(QStringLiteral("name"));

        const QString city = jv.toString();

        if (city != d->city) {
            d->city = city;
            emit cityChanged();
            refreshWeather();
        }
    } else {
        hadError(true);
    }
    networkReply->deleteLater();
}

void AppModel::refreshWeather()
{
    if (d->city.isEmpty()) {
        return;
    }

    QString latitude, longitude;
    longitude.setNum(d->coord.longitude());
    latitude.setNum(d->coord.latitude());

    QUrl url("http://api.openweathermap.org/data/2.5/weather");
    QUrlQuery query;

    if (longitude == "nan" && latitude == "nan") {
        query.addQueryItem("q", d->city);
    } else {
        query.addQueryItem("lat", latitude);
        query.addQueryItem("lon", longitude);
    }

    query.addQueryItem("mode", "json");
    query.addQueryItem("APPID", d->app_ident);
    url.setQuery(query);

    QNetworkReply *rep = d->nam->get(QNetworkRequest(url));
    // connect up the signal right away
    connect(rep, &QNetworkReply::finished,
            this, [this, rep]() { handleWeatherNetworkData(rep); });
}

static QString niceTemperatureString(double t)
{
    return QString::number(qRound(((t-ZERO_KELVIN) * 1.8) + 32)) + QChar(0xB0) + QChar('F');
}

static QString niceWindSpeedString(double ws)
{
    QString unit = " mph";
    return QString::number(qRound(ws * 2.23694)) + unit;
}

static QString niceWindDirectionString(double wd)
{
    QString unit = " deg";
    return QString::number(wd) + unit;
}

void AppModel::handleWeatherNetworkData(QNetworkReply *networkReply)
{
    if (!networkReply)
        return;

    if (!networkReply->error()) {
        foreach (WeatherData *inf, d->forecast)
            delete inf;
        d->forecast.clear();

        QJsonDocument document = QJsonDocument::fromJson(networkReply->readAll());

        if (document.isObject()) {
            QJsonObject obj = document.object();
            QJsonObject tempObject;
            QJsonValue val;

            if (obj.contains(QStringLiteral("weather"))) {
                val = obj.value(QStringLiteral("weather"));
                QJsonArray weatherArray = val.toArray();
                val = weatherArray.at(0);
                tempObject = val.toObject();
                d->now.setWeatherDescription(tempObject.value(QStringLiteral("description")).toString());
                d->now.setWeatherIcon(tempObject.value("icon").toString());
            }
            if (obj.contains(QStringLiteral("main"))) {
                val = obj.value(QStringLiteral("main"));
                tempObject = val.toObject();
                val = tempObject.value(QStringLiteral("temp"));
                d->now.setTemperature(niceTemperatureString(val.toDouble()));
            }
            if (obj.contains(QStringLiteral("wind"))) {
                val = obj.value(QStringLiteral("wind"));
                tempObject = val.toObject();
                d->now.setWindSpeed(niceWindSpeedString(tempObject.value(QStringLiteral("speed")).
                                                        toDouble()));
                d->now.setWindDirection(niceWindDirectionString(tempObject.value(QStringLiteral("deg"))
                                                                .toDouble()));
            }
        }
    }
    networkReply->deleteLater();
    emit weatherChanged();

    QString latitude, longitude;
    longitude.setNum(d->coord.longitude());
    latitude.setNum(d->coord.latitude());

    //retrieve the forecast
    QUrl url("http://api.openweathermap.org/data/2.5/forecast");
    QUrlQuery query;

    if (longitude == "nan" && latitude == "nan") {
        query.addQueryItem("q", d->city);
    } else {
        query.addQueryItem("lat", latitude);
        query.addQueryItem("lon", longitude);
    }

    query.addQueryItem("mode", "json");
    query.addQueryItem("APPID", d->app_ident);
    url.setQuery(query);

    QNetworkReply *rep = d->nam->get(QNetworkRequest(url));
    // connect up the signal right away
    connect(rep, &QNetworkReply::finished,
            this, [this, rep]() { handleForecastNetworkData(rep); });
}

void AppModel::handleForecastNetworkData(QNetworkReply *networkReply)
{
    if (!networkReply)
        return;

    if (!networkReply->error()) {
        QJsonDocument document = QJsonDocument::fromJson(networkReply->readAll());
        QJsonObject jo;
        QJsonValue jv;
        QJsonObject root = document.object();
        jv = root.value(QStringLiteral("list"));

        if (!jv.isArray())
            qWarning() << "Invalid forecast object; no list";

        QJsonArray ja = jv.toArray();

        //we need at least 2 days of forecast -> first entry is today
        if (ja.count() != 40)
            qWarning() << "Invalid forecast object";

        QString data;

        for (int i = 1; i<8; i++) {
            auto *forecastEntry = new WeatherData();

            // min/max temperature
            QJsonObject subtree = ja.at(i).toObject();
            jo = subtree.value(QStringLiteral("main")).toObject();
            jv = jo.value(QStringLiteral("temp"));
            data.clear();
            data += niceTemperatureString(jv.toDouble());
            forecastEntry->setTemperature(data);

            // get time
            jv = subtree.value(QStringLiteral("dt"));
            QDateTime dt = QDateTime::fromMSecsSinceEpoch((qint64)jv.toDouble()*1000);
            forecastEntry->setTimeOfDay(dt.time().toString(QStringLiteral("h AP")));

            // get icon
            QJsonArray weatherArray = subtree.value(QStringLiteral("weather")).toArray();
            jo = weatherArray.at(0).toObject();
            forecastEntry->setWeatherIcon(jo.value(QStringLiteral("icon")).toString());

            // get description
            forecastEntry->setWeatherDescription(jo.value(QStringLiteral("description")).toString());

            // get wind data
            jo = subtree.value(QStringLiteral("wind")).toObject();
            forecastEntry->setWindSpeed(niceWindSpeedString(jo.value(QStringLiteral("speed")).toDouble()));

            d->forecast.append(forecastEntry);
        }

        if (!(d->ready)) {
            d->ready = true;
            emit readyChanged();
        }

        emit weatherChanged();
    }
    networkReply->deleteLater();
}

bool AppModel::hasValidCity() const
{
    return (!(d->city.isEmpty()) && d->city.size() > 1 && d->city != "");
}

bool AppModel::hasValidWeather() const
{
    return hasValidCity() && (!(d->now.weatherIcon().isEmpty()) &&
                              (d->now.weatherIcon().size() > 1) &&
                              d->now.weatherIcon() != "");
}

WeatherData *AppModel::weather() const
{
    return &(d->now);
}

QQmlListProperty<WeatherData> AppModel::forecast() const
{
    return *(d->fcProp);
}

bool AppModel::ready() const
{
    return d->ready;
}

bool AppModel::hasSource() const
{
    return (d->src != nullptr);
}

bool AppModel::useGps() const
{
    return d->useGps;
}

void AppModel::setUseGps(bool value)
{
    d->useGps = value;
    if (value) {
        d->city = "Winnipeg";
        d->throttle.invalidate();
        emit cityChanged();
        emit weatherChanged();
    }
    emit useGpsChanged();
}

QString AppModel::city() const
{
    return d->city;
}

void AppModel::setCity(const QString &value)
{
    d->city = value;
    emit cityChanged();
    refreshWeather();
}
