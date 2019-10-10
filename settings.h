#ifndef SETTINGS_H
#define SETTINGS_H

#include <QSettings>


class Settings : public QSettings
{
    Q_OBJECT

public:
    Settings(QObject *parent = nullptr);
    Settings(const QString &fileName, QSettings::Format format, QObject *parent = nullptr);

    Q_INVOKABLE QVariant value(const QString& key, const QVariant &defaultValue);

private:
    QString getSettingsFile();
    QString m_settingsFile;
};

#endif // SETTINGS_H
