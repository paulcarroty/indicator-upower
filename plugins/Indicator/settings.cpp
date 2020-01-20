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

    m_refreshSec = object.value("refresh_sec").toString().trimmed();
    m_thresholdCharging = object.value("threshold_Charging").toString().trimmed();
    m_repeat_alarm = object.value("repeat_alarm").toString().trimmed();
    m_Stop_Charging = object.value("Stop_Charging").toString().trimmed();
    m_PUSH_Notification = object.value("PUSH_Notification").toString().trimmed();
    m_chargingFILE = object.value("chargingFILE").toString().trimmed();


    Q_EMIT refreshSecChanged(m_refreshSec);
    Q_EMIT thresholdChargingChanged(m_thresholdCharging);
    Q_EMIT repeat_alarmChanged(m_repeat_alarm);
    Q_EMIT Stop_ChargingChanged(m_Stop_Charging);
    Q_EMIT PUSH_NotificationChanged(m_PUSH_Notification);
    Q_EMIT chargingFILEChanged(m_chargingFILE);
    config.close();
}

void Settings::save() {
    QJsonObject object;
    object.insert("refresh_sec", QJsonValue(m_refreshSec.trimmed()));
    object.insert("threshold_Charging", QJsonValue(m_thresholdCharging.trimmed()));
    object.insert("repeat_alarm", QJsonValue(m_repeat_alarm.trimmed()));
    object.insert("Stop_Charging", QJsonValue(m_Stop_Charging.trimmed()));
    object.insert("PUSH_Notification", QJsonValue(m_PUSH_Notification.trimmed()));
    object.insert("chargingFILE", QJsonValue(m_chargingFILE.trimmed()));

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
