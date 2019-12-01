#ifndef SETTINGS_H
#define SETTINGS_H

#include <QObject>

class Settings: public QObject {
    Q_OBJECT

    Q_PROPERTY(QString refreshMins MEMBER m_refreshMins NOTIFY refreshMinsChanged)
    Q_PROPERTY(QString thresholdCharging MEMBER m_thresholdCharging NOTIFY thresholdChargingChanged)
    Q_PROPERTY(QString repeat_alarm MEMBER m_repeat_alarm NOTIFY repeat_alarmChanged)

public:
    Settings();
    ~Settings() = default;

    Q_INVOKABLE void save();

Q_SIGNALS:
    void saved(bool success);

    void refreshMinsChanged(const QString &refreshMins);
    void thresholdChargingChanged(const QString &thresholdCharging);
    void repeat_alarmChanged(const QString &repeat_alarm);

private:
    QString m_configPath = "/home/phablet/.config/indicator.upower.ernesst/"; //TODO don't hardcode this
    QString m_refreshMins;
    QString m_thresholdCharging;
    QString m_repeat_alarm;
};

#endif
