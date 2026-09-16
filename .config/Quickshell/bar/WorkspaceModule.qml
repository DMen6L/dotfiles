import QtQuick
import "../theme" as Theme

Item {
    id: root

    property var workspaceIds: []
    property int focusedWorkspaceId: 0

    signal workspaceRequested(int workspaceId)

    width: Theme.Metrics.workspaceGroupWidth
    height: Theme.Metrics.workspaceGroupHeight

    HoverHandler {
        id: workspaceHover
    }

    Image {
        anchors.fill: parent
        source: workspaceHover.hovered ? Theme.Assets.workspaceActiveFrame : Theme.Assets.workspaceFrame
        fillMode: Image.Stretch
        smooth: false
        asynchronous: true
    }

    Row {
        anchors.centerIn: parent
        width: root.workspaceIds.length * Theme.Metrics.workspaceIconSize + (root.workspaceIds.length - 1) * Theme.Metrics.workspaceIconSpacing
        height: Theme.Metrics.workspaceIconSize
        spacing: Theme.Metrics.workspaceIconSpacing

        Repeater {
            model: root.workspaceIds

            Item {
                required property int modelData

                readonly property bool active: root.focusedWorkspaceId === modelData

                width: Theme.Metrics.workspaceIconSize
                height: Theme.Metrics.workspaceIconSize

                Image {
                    anchors.fill: parent
                    source: active ? Theme.Assets.workspaceActiveIcon : Theme.Assets.workspaceIcon
                    fillMode: Image.PreserveAspectFit
                    smooth: false
                    asynchronous: true
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.workspaceRequested(modelData)
                }
            }
        }
    }
}
