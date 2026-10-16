import Quickshell
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

import "colors.js" as Colors
import "font.js" as Fonts

Scope {
  id: root

  NotificationServer {
    id: server

    bodySupported: true
    bodyMarkupSupported: true
    imageSupported: true
    actionsSupported: false // TODO implement notification actions

    onNotification: n => n.tracked = true
  }

  PanelWindow {
    anchors { top: true; right: true }
    margins {bottom: 10; top: 50; right: 8}
    implicitWidth: 400
    // TODO make this properly fill height
    // Layout.fillHeight: true
    implicitHeight: 1000
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    ColumnLayout {
      id: notifStack
      width: parent.width
      spacing: 8

      Repeater {
        model: server.trackedNotifications

        // Background
        Rectangle {
          id: popup
          required property var modelData
          property var localHeight: 20
          
          Layout.fillWidth: true
          Layout.preferredHeight: localHeight + title.contentHeight + ((body.text !== "") ? body.contentHeight : 0)
          color: modelData.urgency === NotificationUrgency.Critical ? Colors.palette.red : Colors.palette.gray
          border.color: modelData.expireTimeout > 0 ? Colors.palette.yellow : Colors.palette.fg
          border.width: 4

          RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 15
            anchors.rightMargin: 15
            spacing: 10

            // Icon
            Image {
              id: icon
              Layout.alignment: Qt.AlignCenter
              fillMode: Image.PreserveAspectFit
              Layout.preferredHeight: 36
              Layout.preferredWidth: 36
              source: popup.modelData.image || popup.modelData.appIcon || ""
              visible: source.toString() !== ""
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 4

              // Top Bar
              RowLayout {
                Layout.fillWidth: true

                // Title text
                Text {
                  id: title
                  Layout.fillWidth: true
                  text: popup.modelData.summary
                  elide: Text.ElideRight
                  color: Colors.palette.fg
                  font {family: Fonts.family; pixelSize: 18; bold: true}
                }

                // Sender Name
                Text {
                  id: sender
                  text: popup.modelData.appName
                  elide: Text.ElideRight
                  color: Colors.palette.blue
                  font {family: Fonts.family; pixelSize: 14}
                }

                // Close Button
                Text {
                  id: closeButton
                  text: "X"
                  color: Colors.palette.red
                  font {family: Fonts.altFamily; pixelSize: 18; bold: true}

                  // Clickable area for the close button
                  MouseArea {
                    anchors.fill: parent
                    onClicked: popup.modelData.dismiss()
                  }
                }
              }

              // Body text
              Text {
                id: body
                Layout.fillWidth: true
                text: popup.modelData.body
                visible: text !== ""
                color: Colors.palette.fg
                wrapMode: Text.WordWrap
                font {family: Fonts.family; pixelSize: 16}
                // popup.localHeight = popup.localHeight + contentHeight
              }

              // Row of action buttons
              /*RowLayout {
                id: actionButtons
                Layout.fillWidth: true
                property var localHeight: (popup.modelData.actions.length > 0) ? 16 : 0

                Repeater {
                  model: popup.modelData.actions

                  Rectangle {
                    required property var modelData
                    color: Colors.palette.bg
                    border {color: Colors.palette.green; width: 2}

                    Text {
                      id: buttonText
                      text: parent.modelData.text
                      color: Colors.palette.fg
                      font {family: Fonts.altFamily; pixelSize: 16}
                    }

                    MouseArea {
                      anchors.fill: parent
                      onClicked: parent.modelData.invoke()
                    }
                  }
                }
              }*/
            }
          }

          // Timer to timeout the popup
          Timer {
            interval: popup.modelData.expireTimeout > 0 ? popup.modelData.expireTimeout : 0
            running: interval > 0
            repeat: false
            onTriggered: popup.modelData.expire()
          }
        }
      }
    }
  }
}

