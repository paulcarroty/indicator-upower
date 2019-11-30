#include <QDebug>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFileInfo>

#include "settings.h"

Settings::Settings() {
    QFile config(m_configPath + "config.json");
    config.open(QFile::ReadOnly);

    QJsonDocument doc = QJsonDocument::fromJson(config.readAll());
    QJsonObject object = doc.object();

    m_refreshMins = object.value("refresh_mins").toString().trimmed();
    m_thresholdCharging = object.value("threshold_Charging").toString().trimmed();

    Q_EMIT refreshMinsChanged(m_refreshMins);
    Q_EMIT thresholdChargingChanged(m_thresholdCharging);

    config.close();
}

void Settings::save() {
    QJsonObject object;
    object.insert("refresh_mins", QJsonValue(m_refreshMins.trimmed()));
    object.insert("threshold_Charging", QJsonValue(m_thresholdCharging.trimmed()));

    QJsonDocument doc;
    doc.setObject(object);

    if (!QDir(m_configPath).exists()) {
        QDir().mkdir(m_configPath);
    }

    QFile config(m_configPath + "config.json");
    bool success = config.open(QFile::WriteOnly | QFile::Text | QFile::Truncate);
    config.write(doc.toJson());
    config.close();

    Q_EMIT saved(success);
}
