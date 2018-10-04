import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

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

                text: i18n.tr('Indicator Weather')
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            UbuntuShape {
                Layout.preferredHeight: units.gu(10)
                Layout.preferredWidth: units.gu(10)
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                source:  Image {
                    source: '../assets/logo.svg'
                }
            }

            Label {
                Layout.fillWidth: true

                text: i18n.tr('The app icon is based on a weather icon by Erik Flowers (SIL OFL 1.1)');
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true

                text: i18n.tr('A Brian Douglass app, consider donating if you like it and want to see more apps like it!')
                horizontalAlignment: Text.AlignHCenter
                wrapMode: Text.WordWrap
            }

            Button {
                Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                text: i18n.tr('Donate')
                color: UbuntuColors.orange
                onClicked: Qt.openUrlExternally('https://liberapay.com/bhdouglass')
            }
        }
    }
}
