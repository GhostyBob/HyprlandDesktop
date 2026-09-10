import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts


ShellRoot {
  id: root

  property color barColor: "#1a1b26"
  property color emptyWsColor: "#444b6a"
  property color filledWsColor: "#0db9d7"
  property color activeWsColor: "#7aaf27"
  property color urgentWsColor: "#ddab48"
  
  
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
          property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
          property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)

          text: index + 1
          color: isActive ? root.activeWsColor : (ws ? (ws.urgent ? root.urgentWsColor : root.filledWsColor) : root.emptyWsColor)

          font {pixelSize: 16; bold: true}

          MouseArea {
            anchors.fill: parent
            //TODO make workspace numbers clickable
          }
        }
      }
      
      Text {
        text: "|"
        color: root.emptyWsColor
        font {pixelSize: 18; bold: true}
      }
      
      Text {
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
    }
  }
}
