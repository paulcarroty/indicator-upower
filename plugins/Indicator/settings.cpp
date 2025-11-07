#include <QDebug>
#include <QFile>
#include <QDir>
#include <QJsonDocument>
#include <QJsonObject>
#include <QFileInfo>

#include "settings.h"

Settings::Settings() {
    QFile config(m_configPath + "config.json");
    if (!config.open(QFile::ReadOnly)) {
        qDebug() << "Failed to open config file for reading";
        return;
    }

    QJsonDocument doc = QJsonDocument::fromJson(config.readAll());
    config.close();
    
    if (doc.isNull() || !doc.isObject()) {
        qDebug() << "Invalid JSON in config file";
        return;
    }
    
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
        if (!QDir().mkpath(m_configPath)) {
            qDebug() << "Failed to create config directory";
            Q_EMIT saved(false);
            return;
        }
    }

    QFile config(m_configPath + "config.json");
    if (!config.open(QFile::WriteOnly | QFile::Text | QFile::Truncate)) {
        qDebug() << "Failed to open config file for writing";
        Q_EMIT saved(false);
        return;
    }
    
    qint64 bytesWritten = config.write(doc.toJson());
    config.close();
    
    bool success = (bytesWritten > 0);
    Q_EMIT saved(success);
}
