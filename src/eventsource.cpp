#include "eventsource.h"

#include <QTimer>
#include <QDebug>
#include <QJsonDocument>

#define STREAM_ENDPOINT "/stream"

EventSource::EventSource(const QUrl url, QObject *parent) :
    QObject(parent),
    m_reply(nullptr),
    streamErrorRetryCount(0)
{
    qDebug() << "Setting up EventSource for" << url.url();

    m_url = url;

    initialize();
}

void EventSource::initialize() {
    QUrl streamUrl = QUrl(m_url.url() + STREAM_ENDPOINT);
    m_request = QNetworkRequest(streamUrl);

    m_request.setRawHeader(QByteArray("Accept"), QByteArray("text/event-stream"));
    m_request.setAttribute(QNetworkRequest::FollowRedirectsAttribute, true);
    m_request.setAttribute(QNetworkRequest::CacheLoadControlAttribute, QNetworkRequest::AlwaysNetwork); // Events shouldn't be cached

    queryEntity(ENTITY_TYPE_VESSEL);
    queryEntity(ENTITY_TYPE_PUMP);
    startStream();
}

QUrl EventSource::getEntityUrl(EventSource::EntityType type) {
    switch (type) {
    case ENTITY_TYPE_VESSEL:
        return QUrl((m_url.url() + "/vessel"));
    case ENTITY_TYPE_PUMP:
        return QUrl((m_url.url() + "/pump"));
    }

    qWarning() << "Illegal entity type in" << __FUNCTION__;
    return QUrl();
}

void EventSource::emitEntityUpdate(EventSource::EntityType type, QVariant data) {
    switch (type) {
    case ENTITY_TYPE_PUMP:
        emit updatePumps(data);
        break;
    case ENTITY_TYPE_VESSEL:
        emit updateVessels(data);
        break;
    }
}

void EventSource::queryEntity(EventSource::EntityType type) {
    QUrl entityUrl = getEntityUrl(type);

    QNetworkRequest req = QNetworkRequest(entityUrl);
    QNetworkReply *reply = m_nam.get(req);

    connect(reply, QOverload<QNetworkReply::NetworkError>::of(&QNetworkReply::error), [=](){
        qDebug() << "Failed to query entity.. Retrying.";
        QTimer::singleShot(1000, std::bind(&EventSource::queryEntity, this, type));
        reply->deleteLater();
    });

    connect(reply, &QNetworkReply::readyRead, [=]() {
        if (reply->error() != QNetworkReply::NetworkError::NoError) {
            qWarning() << "Failed to set setpoint";
        } else {
            QJsonDocument d = QJsonDocument::fromJson(reply->readAll());
            emitEntityUpdate(type, d.toVariant());
        }

        reply->deleteLater();
    });

}

void EventSource::startStream() {
    if (m_reply)
        delete (m_reply);

    m_reply = m_nam.get(m_request);
    connect(m_reply, SIGNAL(readyRead()), this, SLOT(streamReceived()));
    connect(m_reply, SIGNAL(readyRead()), this, SIGNAL(streamConnected()));
    connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SLOT(streamError(QNetworkReply::NetworkError)));
    connect(m_reply, SIGNAL(error(QNetworkReply::NetworkError)), this, SIGNAL(streamDisconnected()));
    connect(m_reply, SIGNAL(finished()), this, SIGNAL(streamDisconnected()));
    connect(m_reply, SIGNAL(finished()), this, SLOT(streamError()));
}

void EventSource::streamError(QNetworkReply::NetworkError error) {
    int retryDelay = this->streamErrorRetryCount * 1000;

    this->streamErrorRetryCount++;

    qDebug() << "Received network error during stream: " << error;
    qDebug() << "Retrying stream in " << retryDelay << " milliseconds";
    QTimer::singleShot(retryDelay, this, SLOT(startStream()));
}

void EventSource::streamReceived() {
    QString label, message, temp;
    char c;

    // Discard 'event:'
    if ((temp = m_reply->read(strlen("event: "))) != "event: ") {
        qCritical() << "Malformed message header (event section): " + temp;

        temp = m_reply->readAll();
        return;
    }

    // Construct event label
    while (m_reply->read(&c, 1) > 0) {
        if (c == '\n')
            break;

        label.append(c);
    }

    // Discard 'data:'
    if (m_reply->read(strlen("data: ")) != "data: ") {
        qCritical() << "Malformed message header (data section)";

        m_reply->readAll();
        return;
    }

    // Construct message
    while (m_reply->read(&c, 1) > 0) {
        if (c == '\n') {
            m_reply->read(&c, 1);
            break;
        }

        message.append(c);
    }

    emitUpdateEvent(label, message);

    this->streamErrorRetryCount = 0;

    if (m_reply->bytesAvailable() > 0)
        emit m_reply->readyRead();
}

void EventSource::emitUpdateEvent(const QString &label, const QString &message) {
    QVariant data;
    std::function<void(QString, QVariant)> signal;

    QStringRef vessel = label.splitRef("-").last();

#define fwrap(f) std::bind((f), this, std::placeholders::_1, std::placeholders::_2)
    if (label.startsWith("vessel-temperature-")) {
        data = parseJson(message);
        signal = fwrap(&EventSource::updateTemperature);
    } else if (label.startsWith("vessel-power-")) {
        data = message.toFloat();
        signal = fwrap(&EventSource::updatePower);
    } else if (label.startsWith("vessel-heater-")) {
        data = parseJson(message);
        signal = fwrap(&EventSource::updateHeater);
    } else if (label.startsWith("vessel-chart-")) {
        data = parseJson(message);
        signal = fwrap(&EventSource::updateChart);
    } else if (label.startsWith("pump-mode-")) {
        data = parseJson(message);
        signal = fwrap(&EventSource::updateMode);
    } else {
        qWarning() << "Unhandled event type: " << label;
    }
#undef fwrap

    if (signal) {
        emit signal(vessel.toString(), data);
    }
}

QVariant EventSource::parseJson(const QString &message) {
    QVariant data;
    QJsonParseError error;
    QJsonDocument d = QJsonDocument::fromJson(message.toUtf8(), &error);

    if (error.error) {
        qDebug() << error.errorString();
        qDebug() << "Document used:" << message.toUtf8();
    } else {
        data = d.toVariant();
    }

    return data;
}

void EventSource::updateHandler(QString label, QVariant message) {
    if (!message.isValid())
        qDebug() << "Label:" << label;
}

void EventSource::setSetpoint(const QString &vessel, double setpoint) {
    QByteArray d = QString("{\"temperature\": %1, \"unit\": \"C\"}").arg(setpoint).toUtf8();
    putRequest(ENTITY_TYPE_VESSEL, vessel, d, "setpoint");
}

void EventSource::setMode(EntityType type, const QString &entity, const QString &mode) {
    QByteArray d = QString("{\"mode\": \"%1\"}").arg(mode).toUtf8();
    putRequest(type, entity, d, "mode");
}

void EventSource::setVesselMode(const QString &vessel, const QString &mode) {
    setMode(ENTITY_TYPE_VESSEL, vessel, mode);
}

void EventSource::setPumpMode(const QString &pump, const QString &mode) {
    setMode(ENTITY_TYPE_PUMP, pump, mode);
}

void EventSource::putRequest(EventSource::EntityType type, const QString &entityId, QByteArray &putData, const QString &endpoint = QString()) {
    QUrl url = QUrl(getEntityUrl(type).url() + "/" + entityId + (endpoint.isEmpty() ? "" : "/" + endpoint));
    QNetworkRequest req = QNetworkRequest(url);
    req.setHeader(QNetworkRequest::KnownHeaders::ContentTypeHeader, "application/json");
    QNetworkReply *reply = m_nam.put(req, putData);

    qDebug() << "PUT on" << type << "ID: " << entityId << "with data:" << putData << "URL:" << url.url();

    connect(reply, &QNetworkReply::metaDataChanged, [=]() {
        QVariant statusCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute);
        if (!statusCode.isValid())
            return;

        int status = statusCode.toInt();

        if ( status < 200 || status >= 300){
            QString reason = reply->attribute( QNetworkRequest::HttpReasonPhraseAttribute ).toString();
            qDebug() << "ERROR FOR PUT on" << type << "ID:" << entityId << "with data:" << putData
                     << "URL:" << url.url() << "status" << status << ":" << "reason" << reason;
        }

        reply->deleteLater();
    });

    connect(reply, &QNetworkReply::readyRead, [=]() {
        qDebug() << "REPLY FOR PUT on" << type << "ID:" << entityId << "with data:" << putData
                 << "URL:" << url.url() << ":" << reply->readAll();

        if (reply->error() != QNetworkReply::NetworkError::NoError) {
            qWarning() << "Failed to set " << endpoint;
        }

        reply->deleteLater();
    });
}

QDebug operator<<(QDebug debug, const EventSource::EntityType &state) {
    switch (state) {
    case EventSource::ENTITY_TYPE_PUMP:
        debug << "PUMP";
        break;
    case EventSource::ENTITY_TYPE_VESSEL:
        debug << "VESSEL";
        break;
    }

    return debug;
}
