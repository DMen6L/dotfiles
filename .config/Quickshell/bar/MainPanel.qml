import Quickshell
import Quickshell.Wayland
import QtQuick
import "../theme" as Theme

PanelWindow {
    id: root

    property var workspaceController
    property var statusData

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.Metrics.windowHeight
    color: "transparent"
    exclusiveZone: Theme.Metrics.windowHeight

    WlrLayershell.layer: WlrLayer.Bottom

    Item {
        id: barContent

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: Theme.Metrics.topMargin
        }

        height: Theme.Metrics.contentHeight

        WorkspaceModule {
            anchors {
                left: parent.left
                leftMargin: Theme.Metrics.screenEdgeMargin
                verticalCenter: parent.verticalCenter
            }

            workspaceIds: root.workspaceController.workspaceIds
            focusedWorkspaceId: root.workspaceController.focusedWorkspaceId
            onWorkspaceRequested: workspaceId => root.workspaceController.activateWorkspace(workspaceId)
        }

        ClockModule {
            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }
        }

        StatusModule {
            anchors {
                right: parent.right
                rightMargin: Theme.Metrics.screenEdgeMargin
                verticalCenter: parent.verticalCenter
            }

            statusData: root.statusData
        }
    }
}
