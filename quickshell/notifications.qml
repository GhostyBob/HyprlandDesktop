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

    onNotification: n => n.tracked = true
  }

  PanelWindow {
    anchors { bottom: true; right: true }
    margins {bottom: 10}
    implicitWidth: 400
    Layout.fillHeight: true
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
          
          Layout.fillWidth: true
          Layout.preferredHeight: 60
          color: modelData.urgency === NotificationUrgency.Critical ? Colors.palette.red : Colors.palette.gray
          border {color: Colors.palette.fg; width: 4}

          RowLayout {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 10

            // Icon
            Image {
              Layout.preferredHeight: 36
              Layout.preferredWidth: 36
              Layout.alignment: Qt.AlignCenter
              fillMode: Image.PreserveAspectFit
              source: popup.modelData.image || popup.modelData.appIcon || ""
              visible: source !== ""
            }

            ColumnLayout {
              Layout.fillWidth: true
              spacing: 2

              // Title text
              Text {
                Layout.fillWidth: true
                text: popup.modelData.summary
                elide: Text.ElideRight
                color: Colors.palette.fg
                font {family: Fonts.family; pixelSize: 18; bold: true}
              }

              // Body text
              Text {
                Layout.fillWidth: true
                text: popup.modelData.body
                visible: text !== ""
                color: Colors.palette.fg
                wrapMode: Text.WordWrap
                font {family: Fonts.family; pixelSize: 16}
              }
            }
          }
        } 
      }
    }
  }
}

