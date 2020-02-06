#ifndef EVENTSOURCE_H
#define EVENTSOURCE_H

#include <QObject>
#include <QUrl>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QNetworkAccessManager>

class EventSource : public QObject
{
    Q_OBJECT

public:
    enum EntityType {
        ENTITY_TYPE_VESSEL,
        ENTITY_TYPE_PUMP
    };

    EventSource(const QUrl url, QObject *parent = nullptr);

signals:
    void updateTemperature(QString vessel, QVariant temperature);
    void updatePower(QString vessel, QVariant power);
    void updateHeater(QString vessel, QVariant heater);
    void updateChart(QString vessel, QVariant chart);
    void updateMode(QString vessel, QVariant mode);
    void updateVessels(QVariant vessels);
    void updatePumps(QVariant vessels);
    void streamConnected();
    void streamDisconnected();

public slots:
    void streamReceived();
    void streamError(QNetworkReply::NetworkError error = QNetworkReply::NetworkError::UnknownNetworkError);
    void updateHandler(QString label, QVariant message);
    void startStream();
    void setSetpoint(const QString &vessel, double setpoint);
    void setVesselMode(const QString &vessel, const QString &mode);
    void setPumpMode(const QString &pump, const QString &mode);
    void queryEntity(EntityType type);

private:
    QUrl m_url;
    QNetworkRequest m_request;
    QNetworkAccessManager m_nam;
    QNetworkReply *m_reply;
    int streamErrorRetryCount;

    void initialize();
    void emitUpdateEvent(const QString &label, const QString &message);
    QVariant parseJson(const QString &message);
    void putRequest(EntityType type, const QString &entityId, QByteArray &putData, const QString &endpoint);
    QUrl getEntityUrl(EntityType type);
    void emitEntityUpdate(EventSource::EntityType type, QVariant data);
    void setMode(EntityType type, const QString &vessel, const QString &mode);

};

QDebug operator<<(QDebug debug, const EventSource::EntityType &state);

#endif // EVENTSOURCE_H
