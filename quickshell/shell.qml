import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import Quickshell.Io
import QtQuick
import QtQuick.Layouts


ShellRoot {
  id: root

  property color barColor: "#282828"
  property color emptyWsColor: "#504945"
  property color activeWsColor: "#98971a"
  property color urgentWsColor: "#d79921"
  property color textColor: "#ebdbb2"
  property string timeText
  
  PanelWindow {
    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 40
    color: root.barColor
     
    RowLayout {
      anchors.fill: parent
      anchors.margins: 8

      Repeater {
        model: 10

        Text {
          anchors.verticalCenter: parent.verticalCenter

          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

          text: index + 1
          color: isActive ? root.activeWsColor : (ws ? (ws.urgent ? root.urgentWsColor : root.textColor) : root.emptyWsColor)

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
        color: root.textColor
        font {pixelSize: 18; bold: true}
      }
      
      Text {
        anchors.verticalCenter: parent.verticalCenter
        
        property var ws: Hyprland.workspaces.values.find(w => w === "s[true]")
        property bool isActive: Hyprland.focusedWorkspace?.id === ("s")

        text: "S"
        color: isActive ? root.activeWsColor : (ws ? root.filledWsColor : root.emptyWsColor)

        font {pixelSize: 16; bold: true}

        MouseArea {
          anchors.fill: parent
          //TODO make workspace numbers clickable
        }
      }

      Item { Layout.fillWidth: true }

      Text {
        text: root.timeText
        color: root.textColor
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
