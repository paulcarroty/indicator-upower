import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3

Page {
    title: i18n.tr('How to get coordinates')

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

                text: i18n.tr('To obtain coordinates for your location visit OpenStreetMap:')
                horizontalAlignment: Text.AlignHLeft
                wrapMode: Text.WordWrap
            }
            
            RowLayout {
                                
                UbuntuShape {
                Layout.preferredHeight: units.gu(5)
                Layout.preferredWidth: units.gu(5)
                //Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter

                source:  Image {
                    source: '../assets/osm.svg'
                    }
                    
                MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally('https://www.openstreetmap.org/')
                        }
                }
                
            Label {
                    text: 'www.openstreetmap.org'
                    color: 'blue'
                    horizontalAlignment: Text.AlignHLeft

                    MouseArea {
                        anchors.fill: parent
                        onClicked: Qt.openUrlExternally('https://www.openstreetmap.org/')
                    }
                }
            }
            Label {
                Layout.fillWidth: true

                text: i18n.tr('Navigate to your location, tap into the map and hold (or right click). From the context menu select <show address>.')
                horizontalAlignment: Text.AlignHLeft
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true

                text: i18n.tr('A window opens with several information including coordinates. Those are given as \'Latitude\' first, followed by \'Longitude\'.');
                horizontalAlignment: Text.AlignHLeft
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true

                text: i18n.tr('Enter the coordinates in Indicator Weather with the desired number of decimals. Bear in mind that 1 degree is aproximately 111 km.')
                horizontalAlignment: Text.AlignHLeft
                wrapMode: Text.WordWrap
            }

            Label {
                Layout.fillWidth: true

                text: i18n.tr('To check the location install the indicator and from the pull down menu select \'forecast\'. That should open the webpage of the selected provider on your location.')
                horizontalAlignment: Text.AlignHLeft
                wrapMode: Text.WordWrap
            }
        }
    }
}
