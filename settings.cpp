#include "settings.h"

#include <QDebug>
#include <QFileInfo>
#include <QStandardPaths>

Settings::Settings(QObject *parent)
    :  QSettings(getSettingsFile(), QSettings::Format::IniFormat, parent)
{
    qDebug() << "Using config:" << getSettingsFile();
}

Settings::Settings(const QString &fileName, const QSettings::Format format, QObject *parent)
    : QSettings(fileName, format, parent)
{

}

QVariant Settings::value(const QString &key, const QVariant &defaultValue) {
    return QSettings::value(key, defaultValue);
}


QString Settings::getSettingsFile() {
    QString homeFile = QStandardPaths::locate(QStandardPaths::StandardLocation::HomeLocation, ".brewerycontrol.conf");
    if (!homeFile.isEmpty())
        return homeFile;

    if (QFileInfo::exists("/etc/brewerycontrol.conf"))
        return "/etc/brewerycontrol.conf";

    return QString();
}
