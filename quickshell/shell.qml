import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import "colors.js" as Colors

ShellRoot {
  id: root

  property string timeText
  
  PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: Colors.palette.bg
     
    RowLayout {
      anchors.fill: parent
      anchors.margins: 8

      Repeater {
        model: 10

        Text {
          required property int index
          anchors.verticalCenter: parent.verticalCenter

          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

          text: index + 1
          color: isActive ? Colors.palette.green : (ws ? (ws.urgent ? Colors.palette.yellow : Colors.palette.fg) : Colors.palette.gray)

          font {pixelSize: 16; bold: true}

          MouseArea {
            anchors.fill: parent
            //TODO make workspace numbers clickable
          }
        }
      }
      
      Text {
        anchors.verticalCenter: parent.verticalCenter
        
        text: "|"
        color: Colors.palette.fg
        font {pixelSize: 18; bold: true}
      }
      
      Text {
        anchors.verticalCenter: parent.verticalCenter
        
        property var ws: Hyprland.workspaces.values.find(w => w === "s[true]")
        property bool isActive: Hyprland.focusedWorkspace?.id === ("s")

        text: "S"
        color: isActive ? Colors.palette.green : (ws ? Colors.palette.fg : Colors.palette.gray)

        font {pixelSize: 16; bold: true}

        MouseArea {
          anchors.fill: parent
          //TODO make workspace numbers clickable
        }
      }

      Item { Layout.fillWidth: true }

      Text {
        text: root.timeText
        color: Colors.palette.fg
        font {pixelSize: 16}
      }    
    }
  }

  Process {
    id: timeProc
    command: ["date", "+%l:%M %p   %a, %m/%0d"]
    stdout: StdioCollector {
      onStreamFinished: root.timeText = text
    }
    Component.onCompleted: running = true
  }

  Timer {
    id: updateTimer
    interval: 5000
    running: true
    repeat: true
    onTriggered: timeProc.running = true
  }
}
