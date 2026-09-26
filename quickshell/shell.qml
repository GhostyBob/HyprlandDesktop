import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "colors.js" as Colors
import "font.js" as Fonts

ShellRoot {
  id: root

  property string timeText
  property string batteryText
  property color batteryTextColor

  // The top bar
  PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: Colors.palette.bg

    RowLayout {
      anchors.fill: parent
      anchors.leftMargin: 8
      spacing: 6

      // Shows the status of the 10 workspaces
      Repeater {
        model: 10

        Text {
          required property int index
          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

          anchors.verticalCenter: parent.verticalCenter
          text: index + 1

          // Green if the workspace is focused, fg if it isn't but has windows, gray otherwsie.
          color: isActive ? Colors.palette.green : (ws ? (ws.urgent ? Colors.palette.yellow : Colors.palette.fg) : Colors.palette.gray)

          font {pixelSize: 16; bold: true; family: Fonts.family}

          MouseArea {
            anchors.fill: parent
            //TODO make workspace numbers clickable
          }
        }
      }

      // Spacer for the workspace display
      Text {
        anchors.verticalCenter: parent.verticalCenter
        
        text: "|"
        color: Colors.palette.fg
        font {pixelSize: 18; bold: true; family: Fonts.family}
      }

      // Reminder that the special workspace exists. 
      // Currently doesn't accurately display the color.
      Text {
        anchors.verticalCenter: parent.verticalCenter
        
        property var ws: Hyprland.workspaces.values.find(w => w === "s[true]")
        property bool isActive: Hyprland.focusedWorkspace?.id === ("s")

        text: "S"
        color: isActive ? Colors.palette.green : (ws ? Colors.palette.fg : Colors.palette.gray)

        font {pixelSize: 16; bold: true; family: Fonts.family}

        MouseArea {
          anchors.fill: parent
          //TODO make workspace numbers clickable
        }
      }
      
      // Pushes elements to the edges of the bar
      Item { Layout.fillWidth: true }

      // Displays the date & time
      Text {
        Layout.fillHeight: true
        verticalAlignment: Text.AlignVCenter
        text: root.timeText
        color: Colors.palette.fg
        font.pixelSize: 16
        font.family: Fonts.family
      }

      // Spacer
      Item { width: 8 }

      // Displays the battery percentage
      Rectangle {
        id: batteryBoundingRect
        color: Colors.palette.gray
        implicitWidth: 80
        Layout.fillHeight: true

        Text {
          anchors.centerIn: parent
          verticalAlignment: Text.AlignVCenter
          text: root.batteryText

          color: root.batteryTextColor
          font {pixelSize: 16; family: Fonts.family; bold: true}

          // Click to display time to empty instead of percentage
          MouseArea {
            anchors.fill: parent
            onClicked: batteryTimeProc.running = true
          }
        }
      }
    }
  }

  // Queries the date & time. Stores the result in timeText.
  Process {
    id: timeProc
    command: ["date", "+%l:%M %p   %a, %m/%0d"]
    stdout: StdioCollector {
      onStreamFinished: root.timeText = text
    }
    Component.onCompleted: running = true
  }

  // Queries the battery percentage. Stores the result in batteryText.
  // Also sets batteryTextColor based on batteryText.
  Process {
    id: batteryProc
    command: ["sh", "-c", "upower -b | grep percentage"]
    stdout: StdioCollector {
      onStreamFinished: () => {
        root.batteryText = text.slice(15).trim()
        // Text color: 50-99 = aqua; 20-49 = orange; 0-19 = red
        var tens = root.batteryText[0]
        root.batteryTextColor = tens > '5' ? Colors.palette.aqua : (tens > '1' ? Colors.palette.orange : Colors.palette.red)
      }
    }
    Component.onCompleted: running = true
  }

  // Queries the battery's time to empty. Stores the result in batteryText.
  // Also sets batteryTextColor based on batteryText.
  Process {
    id: batteryTimeProc
    command: ["sh", "-c", "upower -b | grep to\\ empty"]
    stdout: StdioCollector {
      onStreamFinished: () => {
        root.batteryText = text.slice(18).trim().slice(0, 5)
        // Text color: >=2 = aqua; 1-1.9 = orange; <1 = red
        var hours = root.batteryText[0]
        root.batteryTextColor = hours >= '2' ? Colors.palette.aqua : (hours > '1' ? Colors.palette.orange : Colors.palette.red)
      }
    }
  }

  // Periodically re-runs processes to keep things up to date.
  Timer {
    id: updateTimer
    interval: 5000
    running: true
    repeat: true
    onTriggered: () => {
      timeProc.running = true
      batteryProc.running = true
    }
  }
}
