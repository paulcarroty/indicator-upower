/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.2
import QtQuick.Controls.Material 2.1
import QtQuick.Controls.Universal 2.1
import Qt.labs.settings 1.0
import Indicator 1.0
import Lomiri.Components 1.3 as TR  // only imported to allow using i18n.tr() translations, named TR to avoid lomiri components being used as default


ApplicationWindow {
    id: window
    width: 360
    height: 520
    visible: true
    title: i18n.tr("Upower Indicator")

    Settings {
        id: settings
        property string style: "Suru"
    }

    Shortcut {
        sequence: "Menu"
        onActivated: optionsMenu.open()
    }


    header: ToolBar {
        Material.foreground: "white"

        RowLayout {
            spacing: 20
            anchors.fill: parent
            Label {
                id: titleLabel
                text: i18n.tr("Upower Indicator")
                font.pixelSize: 20
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }
    SwipeView {
        id: swipeView
        width: parent.width
        height: parent.height
        currentIndex: tabBar.currentIndex

        Flickable {
            id: listView
            contentWidth: swipeView.width
            contentHeight:settings_1.implicitHeight

            ScrollBar.vertical: ScrollBar {}
            Pane{
            id: settings_1
            width: swipeView.width
            height: swipeView.height
            Button {
                id: infoButton
                text: i18n.tr("Info")
                anchors.margins: -10
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                onClicked: {
                    infoText.visible = !infoText.visible;
                }
            }
            Label {
                id: infoText
                text: i18n.tr('Welcome in the Upower Indicator settings menu. This application displays limited information for most devices. To get more data like battery health or cycle count, see the <a href="https://github.com/paulcarroty/indicator-upower/blob/master/docs/add_device.md">Docs</a>.')
                onLinkActivated: Qt.openUrlExternally(link)
                visible: false
                opacity: visible ? 1 : 0
                height: visible ? implicitHeight : 0
                anchors.top: infoButton.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Label.AlignHCenter
                verticalAlignment: Label.AlignVCenter
                wrapMode: Label.Wrap
                font.pixelSize: 12
            }
            Label {
              id: refreshSec_Text
              anchors.topMargin: 10
              anchors.leftMargin: 20
              anchors.rightMargin: 20
              anchors.bottomMargin: 20
              anchors.top: infoText.bottom
              anchors.left: parent.left
              anchors.right: parent.right
              width: parent.width
              wrapMode: Label.Wrap
              horizontalAlignment: Qt.AlignHLeft
              font.pixelSize: 12
              text: i18n.tr("Upower queries interval in seconds:")
            }
            TextField {
              anchors.margins: 5
              anchors.leftMargin: 60
              anchors.top: refreshSec_Text.bottom
              anchors.left: parent.left
              anchors.horizontalCenter: Qt.AlignHLeft
              width: swipeView.availableWidth / 4
              font.pixelSize: 12
              id: refreshSec
              placeholderText: "30 - 3600"
              validator: IntValidator {
                  bottom: 30
                  top: 3600
              }
              inputMethodHints: Qt.ImhDigitsOnly

              Component.onCompleted: {
                  if (settings.refreshSec) {
                      text = settings.refreshSec;
                  } else {
                      text = '30';
                  }
              }
              onTextChanged: {
                  settings.refreshSec = text;
              }
            }
            Label {
              id: thresholdCharging_Text
              anchors.topMargin: 10
              anchors.leftMargin: 20
              anchors.rightMargin: 20
              anchors.bottomMargin: 20
              anchors.top: refreshSec.bottom
              anchors.left: parent.left
              anchors.right: parent.right
              width: parent.width
              wrapMode: Label.Wrap
              horizontalAlignment: Qt.AlignHLeft
              font.pixelSize: 12
              text: i18n.tr("Battery charge limit (%):")
                }
            TextField {
                anchors.margins : 5
                anchors.leftMargin: 60
                anchors.top: thresholdCharging_Text.bottom
                anchors.left: parent.left
                anchors.horizontalCenter: Qt.AlignHLeft
                width: swipeView.availableWidth / 4
                id: thresholdCharging
                font.pixelSize: 12
                placeholderText: "70 - 100"
                validator: IntValidator {
                    bottom: 70
                    top: 100
                }
                inputMethodHints: Qt.ImhDigitsOnly
                Component.onCompleted: {
                    if (settings.thresholdCharging) {
                        text = settings.thresholdCharging;
                    } else {
                        text = '85';
                    }
                }
                onTextChanged: {
                    settings.thresholdCharging = text;
                }
              }
          /*    Label {
                 id:text3
                  text: "To disable the alarm set the threshold to 100."
                  font.italic : true
                  anchors.leftMargin: 20
                  anchors.margins: 5
                  anchors.top: thresholdCharging.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  horizontalAlignment: Qt.AlignHLeft
                  wrapMode: Label.Wrap
                  font.pixelSize: 12
              }*/
            Column {
                spacing: 10
                id: repeat_switch
                anchors.margins: 20
                anchors.top: thresholdCharging.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                width: parent.width
                Switch {
                    id: repeat_switch_switch
                    checked: (settings.repeat_alarm == 1) ? true : false
                    text: i18n.tr("Repeat push notification")
                    font.pixelSize: 12
                    onCheckedChanged: {
                        if(checked){
                            settings.repeat_alarm = 1;
                            settings.PUSH_Notification = 1;
                            settings.Stop_Charging = 0;
                        }else{
                            settings.repeat_alarm = 0;
                        }
                    }
                }
            }
            Column {
                spacing: 10
                id: notification_switch
                anchors.margins: 20
                anchors.top: repeat_switch.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                width: parent.width
                Switch {
                    checked: (settings.PUSH_Notification == 1) ? true : false
                    text: i18n.tr("Push notification")
                    font.pixelSize: 12
                    onCheckedChanged: {
                        if(checked){
                            settings.PUSH_Notification = 1;
                        }else{
                            settings.PUSH_Notification = 0;
                        }
                    }
                }
            }
            Column {
                spacing: 10
                id: stop_switch
                anchors.margins: 20
                anchors.top: notification_switch.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                width: parent.width
                Switch {
                    id: stop_switch_switch
                    //checked: (settings.Stop_Charging == 1) ? true : false
                    checked: (settings.Stop_Charging == 1) ? true : false
                    text: i18n.tr("Stop charging after limit is reached")
                    font.pixelSize: 12
                    enabled: (settings.chargingFILE == 1) ? true : false
                    onCheckedChanged: {
                        if(checked){
                            settings.Stop_Charging = 1;
                            settings.repeat_alarm = 0;
                        }else{
                            settings.Stop_Charging = 0;
                        }
                    }
                }
            }
            Button {
              id: save_button
              anchors.topMargin: 10
              anchors.leftMargin: 20
              anchors.rightMargin: 20
              anchors.bottomMargin: 10
              anchors.top: stop_switch.bottom
              anchors.left: parent.left
              anchors.right: parent.right
              anchors.horizontalCenter: parent.horizontalLeft
              text: i18n.tr("Save configuration file")
              onClicked :
              { if (refreshSec.acceptableInput & thresholdCharging.acceptableInput) {
                settings.save();
                onTriggered: dialog_save.open()}
              }
            }
            Button {
                id: install_button
                visible: !Indicator.isInstalled
                anchors.topMargin: 10
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.bottomMargin: 10
                anchors.top: save_button.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.horizontalCenter: parent.horizontalLeft
                ToolTip.visible: pressed
                ToolTip.timeout: 5000
                ToolTip.delay: 5000
                text: i18n.tr("Install Indicator")
                ToolTip.text: i18n.tr("Indicator installed, please reboot")
                onClicked :{
                    dialogue.open();
                    //Indicator.install();
                    //  onTriggered: dialog_Installed.open()
                  }
                }
            Button {
                id: uninstall_button
                visible: Indicator.isInstalled
                anchors.topMargin: 10
                anchors.leftMargin: 20
                anchors.rightMargin: 20
                anchors.bottomMargin: 10
                anchors.top: save_button.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.horizontalCenter: parent.horizontalLeft
                ToolTip.visible: pressed
                ToolTip.timeout: 5000
                ToolTip.delay: 5000
                ToolTip.text: i18n.tr("Reboot before reinstall")
                text: i18n.tr("Uninstall Indicator")
                onClicked :{
                    dialogue.open();
                    // Indicator.unin/stall();
                    // onTriggered: dialog_unInstalled.open()
                }
            }
            Label {
               id:text4
                text: i18n.tr("* Before uninstalling the app, be sure to uninstall the indicator here first.")
                font.italic : true
                font.bold : true
                anchors.leftMargin: 20
                anchors.margins: 5
                anchors.top: install_button.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                horizontalAlignment: Qt.AlignHLeft
                wrapMode: Label.Wrap
                font.pixelSize: 10
            }
          }
        }

        Flickable {
            id: listView2
            contentWidth: swipeView.width
            contentHeight:credits.implicitHeight
            ScrollBar.vertical: ScrollBar {}

        Pane {
          id: credits
          width: swipeView.width
          height: swipeView.height
              Label {
                  id: title_thanks
                  anchors.top: parent.top
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  font.bold : true
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("A big thanks to:")
                  font.pixelSize: 20
              }
              Label {
                  id:upower
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: title_thanks.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("+ %1 command line tool").arg("<a href=\"https://upower.freedesktop.org/\">UPower</a>")
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:brian
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: upower.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr('+ Brian Douglass\'s application %1 and his help').arg("<a href=\"https://gitlab.com/bhdouglass/indicator-weather\">%1</a>").arg(i18n.ctr("For first credits entry. The name of Brians app, which will be used as the link text instead of %1.", "indicator weather"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:biget
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: brian.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("+ BigET\'s application %1").arg("<a href=\"https://github.com/BigET/NotificationPost\">%1</a>").arg(i18n.ctr("For second credits entry. Big ET's app name, which will be used as the link text instead of %1.", "Notification Post"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:reis
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: biget.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("+ Gustavo Reis for the Suru++ logo %1").arg("<a href=\"https://github.com/gusbemacbe/suru-plus\">%1</a>").arg(i18n.ctr("For third credits entry. Gustavo's credits and honors page, which will be used as the link text instead of %1.", "credits and honors"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:brian2
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: reis.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr('+ Brian Douglass\'s %1.').arg("<a href=\"https://gitlab.com/ubports/apps/qqc2-gallery\">%1</a>").arg(i18n.ctr("For forth credits entry. The name of Brians app, which will be used as the link text instead of %1", "QtQuickControls2 Gallery"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:brian3
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: brian2.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr('+ Brian Douglass\'s %1.').arg("<a href=\"http://clickable.bhdouglass.com/en/latest/\">%1</a>").arg(i18n.ctr("For fifth credits entry. The name of Brians app, which will be used as the link text instead of %1", "Clickable tool"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:ubports
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: brian3.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("+ Ubports documentation on %1").arg("<a href=\"https://docs.ubports.com/en/latest/appdev/guides/pushnotifications.html/\">%1</a>").arg(i18n.ctr("For sixth credits entry. The chapter name of UT docs, which will be used as the link text instead of %1.", "push notification"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:donate_l
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: ubports.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Text.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr('+ Consider supporting Ubports: %1').arg("<a href=\"https://ubports.com/donate\">%1</a>").arg(i18n.ctr("For seventh credits entry. Content, which will be used as the link text instead of %1.", "Donate"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id:contributors_l
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: donate_l.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Text.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("+ All testers")
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
              Label {
                  id: application
                  anchors.topMargin: 30
                  anchors.top: contributors_l.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Label.Wrap
                  font.bold : true
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr("Upower Indicator information:")
                  font.pixelSize: 20
              }
              Label {
                  id:source
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: application.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  width: parent.width
                  wrapMode: Text.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr('+ Source code hosts on %1').arg("<a href=\"https://github.com/paulcarroty/indicator-upower\">%1</a>").arg(i18n.ctr("For Github entry. Content, which will be used as the link text instead of %1.", "Github"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)

              }
              Label {
                  id:openstore
                  anchors.leftMargin: 20
                  anchors.margins: 10
                  anchors.top: source.bottom
                  anchors.left: parent.left
                  anchors.right: parent.right
                  anchors.horizontalCenter: parent.horizontalLeft
                  wrapMode: Text.Wrap
                  horizontalAlignment: Qt.AlignHLeft
                  text: i18n.tr('+ Openstore %1').arg("<a href=\"https://github.com/paulcarroty/indicator-upower\">%1</a>").arg(i18n.ctr("For OpenStore entry. Content, which will be used as the link text instead of %1.", "link"))
                  font.pixelSize: 16
                  onLinkActivated: Qt.openUrlExternally(link)
              }
          }
        }
}
    footer: TabBar {
        id: tabBar
        currentIndex: swipeView.currentIndex
        TabButton {
            text: i18n.tr("Settings")
        }
        TabButton {
            text: i18n.tr("Credits")
        }
    }
    Dialog {
      id: dialog_Installed
      modal: true
      focus: true
      title: i18n.tr("Indicator Installed")
      x: (window.width - width) / 2
      y: window.height / 6
      width: Math.min(window.width, window.height) / 3 * 2
      contentHeight: aboutColumn.height
      standardButtons: Dialog.Ok
          Column {
              id: aboutColumn
              spacing: 20

              Label {
                  width: dialog_Installed.availableWidth
                  text: i18n.tr("To take effect please reboot.")
                  wrapMode: Label.Wrap
                  font.pixelSize: 12
              }
          }
      }
    Dialog {
      id: dialog_unInstalled
      modal: true
      focus: true
      title: i18n.tr("Indicator Removed")
      x: (window.width - width) / 2
      y: window.height / 6
      width: Math.min(window.width, window.height) / 3 * 2
      contentHeight: aboutColumn2.height
      standardButtons: Dialog.Ok

          Column {
              id: aboutColumn2
              spacing: 20
              Label {
                  width: dialog_unInstalled.availableWidth
                  horizontalAlignment: Dialog.AlignHCenter
                  text: i18n.tr("To take effect please reboot.")
                  wrapMode: Label.Wrap
                  font.pixelSize: 12
              }
          }
      }
      Dialog {
        id: dialog_save
        modal: true
        focus: true
        title: i18n.tr("Configuration saved")
        x: (window.width - width) / 2
        y: window.height / 6
        width: Math.min(window.width, window.height) / 4 * 3
        contentHeight: aboutColumn3.height
        standardButtons: Dialog.Ok
            Column {
                id: aboutColumn3
                spacing: 20

                Label {
                    width: dialog_save.availableWidth
                    text: i18n.tr("Please reboot.")
                    wrapMode: Label.Wrap
                    font.pixelSize: 12
                }
            }
        }

        property string password : ""


        Component.onCompleted: {
            Indicator.commandRunner = CommandRunner;
        }

        Dialog {
            id: dialogue
            modal: true
            focus: true
            title: i18n.tr("Authentication required")
            //text: "Please enter your user PIN or password to continue:"
            x: (window.width - width) / 2
            y: window.height / 6
            width: Math.min(window.width, window.height) / 3 * 2
            //contentHeight: aboutColumn3.height
            standardButtons: Dialog.Ok | Dialog.Cancel


            function testPassword() {
                window.password = entry.text
                if (CommandRunner.validatePassword()) {
                    if (Indicator.isInstalled) {
                        Indicator.uninstall();
                        onTriggered: dialog_unInstalled.open()
                    } else {
                        Indicator.install();
                        onTriggered: dialog_Installed.open()
                    }
                    dialogue.close();
                }
            }
            onAccepted: dialogue.testPassword()
            onRejected: dialogue.close()

            TextField {
                id: entry
                placeholderText: i18n.tr("PIN or password")
                echoMode: TextInput.Password
                focus: true
                onAccepted: dialogue.testPassword()
            }
        }

        Connections {
            target: CommandRunner
            onPasswordRequested: {
                CommandRunner.providePassword(password)
            }
        }
}
