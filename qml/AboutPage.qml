import QtQuick 2.4
import QtQuick.Layouts 1.1
import Lomiri.Components 1.3

Page {
    title: i18n.tr('About')

    header: PageHeader {
        id: header
        title: parent.title
    }

    Flickable {
        anchors {
            top: header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        contentHeight: contentColumn.height + units.gu(4)

        ColumnLayout {
            id: contentColumn
            anchors {
                left: parent.left;
                top: parent.top;
                right: parent.right;
                margins: units.gu(2)
            }
            spacing: units.gu(2)

            Label {
                Layout.fillWidth: true

                text: i18n.tr('Upower\'s Indicator')
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            LomiriShape {
                Layout.preferredHeight: units.gu(20)
                Layout.preferredWidth: units.gu(20)
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                source:  Image {
                    source: '../assets/logo.svg'
                }
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr('A big thanks to:');
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr('Brian Douglass\'s application %1 and his help.').arg("<a href=\"https://gitlab.com/bhdouglass/indicator-weather\"> indicator weather</a>");
                onLinkActivated: Qt.openUrlExternally(link)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr("BigET\'s application %1").arg("<a href=\"https://github.com/BigET/NotificationPost\">Notification Post</a>");
                onLinkActivated: Qt.openUrlExternally(link)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr("Gustavo Reis for the Suru++ logo %1").arg("<a href=\"https://github.com/gusbemacbe/suru-plus\">credits and honors</a>");
                onLinkActivated: Qt.openUrlExternally(link)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr("%1 command line tool").arg("<a href=\"https://upower.freedesktop.org/\">UPower</a>");
                onLinkActivated: Qt.openUrlExternally(link)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr("Ubports documentation on %1").arg("<a href=\"https://docs.ubports.com/en/latest/appdev/guides/pushnotifications.html/\">push notification</a>");
                onLinkActivated: Qt.openUrlExternally(link)
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr('Consider donating to Ubports!')
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Button {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                text: i18n.tr('Donate')
                color: LomiriColors.orange
                onClicked: Qt.openUrlExternally('https://ubports.com/donate')
            }
        }
    }
}
