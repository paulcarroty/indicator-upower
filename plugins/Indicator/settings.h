#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings: public QObject {
    Q_OBJECT

    Q_PROPERTY(QString refreshSec MEMBER m_refreshSec NOTIFY refreshSecChanged)
    Q_PROPERTY(QString thresholdCharging MEMBER m_thresholdCharging NOTIFY thresholdChargingChanged)
    Q_PROPERTY(QString repeat_alarm MEMBER m_repeat_alarm NOTIFY repeat_alarmChanged)
    Q_PROPERTY(QString Stop_Charging MEMBER m_Stop_Charging NOTIFY Stop_ChargingChanged)
    Q_PROPERTY(QString PUSH_Notification MEMBER m_PUSH_Notification NOTIFY PUSH_NotificationChanged)
    Q_PROPERTY(QString chargingFILE MEMBER m_chargingFILE NOTIFY chargingFILEChanged)


public:
    Settings();
    ~Settings() = default;

    Q_INVOKABLE void save();

Q_SIGNALS:
    void saved(bool success);

    void refreshSecChanged(const QString &refreshSec);
    void thresholdChargingChanged(const QString &thresholdCharging);
    void repeat_alarmChanged(const QString &repeat_alarm);
    void Stop_ChargingChanged(const QString &Stop_Charging);
    void PUSH_NotificationChanged(const QString &PUSH_Notification);
    void chargingFILEChanged(const QString &chargingFILE);




private:
    QString m_configPath = "/home/phablet/.config/indicator.upower.ernesst/"; //TODO don't hardcode this
    QString m_refreshSec;
    QString m_thresholdCharging;
    QString m_repeat_alarm;
    QString m_Stop_Charging;
    QString m_PUSH_Notification;
    QString m_chargingFILE;

};

#endif
