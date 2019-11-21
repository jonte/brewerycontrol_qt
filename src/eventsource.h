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
    EventSource(const QUrl url, QObject *parent = nullptr);

signals:
    void updateTemperature(QString vessel, QVariant temperature);
    void updatePower(QString vessel, QVariant power);
    void updateHeater(QString vessel, QVariant heater);
    void updateChart(QString vessel, QVariant chart);
    void updateMode(QString vessel, QVariant mode);
    void updateTimer(QString timerId, QVariant timer);
    void updateVessels(QVariant vessels);
    void streamConnected();
    void streamDisconnected();

public slots:
    void streamReceived();
    void streamError(QNetworkReply::NetworkError error = QNetworkReply::NetworkError::UnknownNetworkError);
    void updateHandler(QString label, QVariant message);
    void startStream();
    void setSetpoint(const QString &vessel, double setpoint);
    void setMode(const QString &vessel, QString mode);
    void queryVessels();
    void queryTimers();

private:
    QUrl m_url;
    QNetworkRequest m_request;
    QNetworkAccessManager m_nam;
    QNetworkReply *m_reply;
    int streamErrorRetryCount;

    void initialize();
    void emitUpdateEvent(const QString &label, const QString &message);
    QVariant parseJson(const QString &message);
    void putRequest(const QString &vessel, QByteArray &putData, const QString &endpoint);
};

#endif // EVENTSOURCE_H
