import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import Indicator 1.0

Page {
    header: PageHeader {
        id: header
        title: i18n.tr("Indicator Weather")

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

            RowLayout {
                Layout.fillWidth: true

                WeatherProviderSelect {
                    settings: settings
                    Layout.fillWidth: true
                }

                Image {
                    visible: settings.provider == 'dark_sky'
                    source: "../assets/darksky.png"

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally('https://darksky.net/poweredby/')
                    }

                    Layout.preferredWidth: parent.width / 4
                    Layout.preferredHeight: width / 2
                }
            }

            Label {
                visible: settings.provider == 'dark_sky'
                text: i18n.tr("Dark Sky API Key")
                Layout.fillWidth: true
            }

            TextField {
                visible: settings.provider == 'dark_sky'
                id: darkSkyApiKey

                Component.onCompleted: text = settings.darkSkyApiKey

                onTextChanged: {
                    settings.darkSkyApiKey = text;
                }
            }

            Label {
                visible: settings.provider == 'open_weather_map'
                text: i18n.tr("OpenWeatherMap API Key")
                Layout.fillWidth: true
            }

            TextField {
                visible: settings.provider == 'open_weather_map'
                id: owmApiKey

                Component.onCompleted: text = settings.owmApiKey

                onTextChanged: {
                    settings.owmApiKey = text;
                }
            }

            Label {
                visible: settings.provider == 'open_weather_map'
                text: i18n.tr("Click to signup for an API key")
                color: 'blue'

                MouseArea {
                    anchors.fill: parent
                    onClicked: Qt.openUrlExternally('https://openweathermap.org/appid')
                }
            }

            Label {
                text: i18n.tr("Latitude")
                Layout.fillWidth: true
            }

            TextField {
                id: lat
                validator: DoubleValidator {
                    bottom: -90
                    top: 90
                    notation: DoubleValidator.StandardNotation
                }

                Component.onCompleted: text = settings.lat

                onTextChanged: {
                    settings.lat = text;
                }
            }

            Label {
                text: i18n.tr("Longitude")
                Layout.fillWidth: true
            }

            TextField {
                id: lng
                validator: DoubleValidator {
                    bottom: -180
                    top: 180
                    notation: DoubleValidator.StandardNotation
                }

                Component.onCompleted: text = settings.lng

                onTextChanged: {
                    settings.lng = text;
                }
            }

            Rectangle { // Spacer
                Layout.preferredHeight: units.gu(1)
            }

            TemperatureUnitSelect {
                settings: settings
                Layout.fillWidth: true
            }

            Rectangle { // Spacer
                Layout.preferredHeight: units.gu(1)
            }

            Label {
                text: i18n.tr("Weather refresh interval (minutes)")
                Layout.fillWidth: true
            }

            TextField {
                id: refreshMins
                validator: IntValidator {
                    bottom: 1
                    top: 60
                }

                Component.onCompleted: {
                    settings.refreshMins ? text = settings.refreshMins : text = '30' ;
                }

                onTextChanged: {
                    settings.refreshMins = text;
                }
            }

            Rectangle { // Spacer
                Layout.preferredHeight: units.gu(1)
            }

            Button {
                text: i18n.tr("Save")
                onClicked: {
                    message.visible = true;

                    var valid = false;
                    if (
                        (!settings.darkSkyApiKey && settings.provider == 'dark_sky') ||
                        (!settings.owmApiKey && settings.provider == 'open_weather_map')
                    ) {
                        message.text = i18n.tr("Please specify an api key");
                        message.color = UbuntuColors.orange;
                    }
                    else if (!lat.acceptableInput) {
                        message.text = i18n.tr("Please specify the latitude");
                        // TRANSLATORS: %1 is representing the min/max latitude (e.g. -90 to 90)
                        message.text += i18n.tr(", within the appropriate range (-%1 to %1)").arg(lat.validator.top);
                        message.color = UbuntuColors.orange;
                    }
                    else if (!lng.acceptableInput) {
                        message.text = i18n.tr("Please specify the longitude");
                        // TRANSLATORS: %1 is representing the min/max longitude (e.g. -180 to 180)
                        message.text += i18n.tr(", within the appropriate range (-%1 to %1)").arg(lng.validator.top);
                        message.color = UbuntuColors.orange;
                    }
                    else if (!refreshMins.acceptableInput) {
                        // TRANSLATORS: %1 and %2 are the min/max minutes for refreshing the weather (e.g. 1 to 60)
                        message.text = i18n.tr(
                            "Please specify the weather refresh interval in minutes (%1 to %2)"
                        ).arg(refreshMins.validator.bottom).arg(refreshMins.validator.top);
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

            Label {
                id: message
                visible: false
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
