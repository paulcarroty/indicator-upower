import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Indicator 1.0

Page {
    header: PageHeader {
        id: header
        title: i18n.tr("Upower's Indicator")

        trailingActionBar.actions: [
            Action {
                iconName: 'info'
                text: i18n.tr('About')
                onTriggered: pageStack.push(Qt.resolvedUrl('AboutPage.qml'))
            }
        ]
    }

    Settings {
        id: settings

        onSaved: {
            if (!success) {
                message.text = i18n.tr("Failed to save the settings");
                message.color = UbuntuColors.red;
            }
        }
    }

    Flickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        clip: true
        contentHeight: contentColumn.height + units.gu(4)

        ColumnLayout {
            id: contentColumn
            anchors {
                left: parent.left
                top: parent.top
                right: parent.right
                margins: units.gu(2)
            }
            spacing: units.gu(1)

            Label {
                text: i18n.tr("Upower queries interval (seconds)")
                Layout.fillWidth: true
            }

            TextField {
                id: refreshMins // name to be update to seconds
                validator: IntValidator {
                    bottom: 30
                    top: 3600
                }
                inputMethodHints: Qt.ImhDigitsOnly

                Component.onCompleted: {
                    if (settings.refreshMins) {
                        text = settings.refreshMins;
                    } else {
                        text = '30';
                    }
                }

                onTextChanged: {
                    settings.refreshMins = text;
                }
            }

            Rectangle { // Spacer
                Layout.preferredHeight: units.gu(1)
            }
            Label {
                text: i18n.tr("Battery charge threshold alarm (%)")
                Layout.fillWidth: true
            }

            TextField {
                id: thresholdCharging
                validator: IntValidator {
                    bottom: 70
                    top: 100
                }
                inputMethodHints: Qt.ImhDigitsOnly

                Component.onCompleted: {
                    if (settings.thresholdCharging) {
                        text = settings.thresholdCharging;
                    } else {
                        text = '80';
                    }
                }

                onTextChanged: {
                    settings.thresholdCharging = text;
                }
            }
            Label {
                text: i18n.tr("Set 100% to desactivate the alarm")
                Layout.fillWidth: true
            }
            Label {
                text: i18n.tr("How to prolong Lithium-based Batteries ? %1").arg("<a href=\"https://duckduckgo.com/?q=+How+to+Prolong+Lithium-based+charging+80\"> Please read the following link</a>");
                onLinkActivated: Qt.openUrlExternally(link)
                wrapMode: Text.WordWrap
                Layout.fillWidth: true
            }
            Rectangle { // Spacer
                Layout.preferredHeight: units.gu(1)
            }


            Label {
                id: message
                visible: false
            }

            Button {
                text: i18n.tr("Save")
                onClicked: {
                    message.visible = true;
                    var valid = false;
                    if (!refreshMins.acceptableInput) {
                        message.text = i18n.tr("Please specify the Upower queries interval in seconds") + "<br>";
                        // TRANSLATORS: %1 and %2 are the min/max seconds for refreshing the indicator (e.g. 1 to 60)
                        message.text += i18n.tr("in seconds (%1 to %2)").arg(refreshMins.validator.bottom).arg(refreshMins.validator.top);
                        message.color = UbuntuColors.orange;
                    }
                    else if (!thresholdCharging.acceptableInput) {
                        message.text = i18n.tr("Battery charge percentage threshold alarm") + "<br>";
                        // TRANSLATORS: %1 and %2 are the min/max UpowerIndicator for the alarm (e.g. 70 to 100)
                        message.text += i18n.tr("in percentage (%1 to %2)").arg(thresholdCharging.validator.bottom).arg(thresholdCharging.validator.top);
                        message.color = UbuntuColors.orange;
                    }
                    else {
                        valid = true;
                        message.text = i18n.tr("Saved the settings, please reboot");
                        message.color = UbuntuColors.green;
                    }

                    if (valid) settings.save();
                }
                color: UbuntuColors.orange
            }

            Button {
                visible: !Indicator.isInstalled

                text: i18n.tr("Install Indicator")
                onClicked: {
                    message.visible = false;
                    Indicator.install();
                }
                color: UbuntuColors.green
            }

            Button {
                visible: Indicator.isInstalled

                text: i18n.tr("Uninstall Indicator")
                onClicked: {
                    message.visible = false;
                    Indicator.uninstall();
                }
            }

            Label {
                textSize: Label.XSmall

                text: i18n.tr('* Before uninstalling the app be sure to uninstall the indicator here first')
            }
        }
    }

    Connections {
        target: Indicator

        onInstalled: {
            message.visible = true;
            if (success) {
                message.text = i18n.tr("Successfully installed, please reboot");
                message.color = UbuntuColors.green;
            }
            else {
                message.text = i18n.tr("Failed to install");
                message.color = UbuntuColors.red;
            }
        }

        onUninstalled: {
            message.visible = true;
            if (success) {
                message.text = i18n.tr("Successfully uninstalled, please reboot");
                message.color = UbuntuColors.green;
            }
            else {
                message.text = i18n.tr("Failed to uninstall");
                message.color = UbuntuColors.red;
            }
        }
    }
}
