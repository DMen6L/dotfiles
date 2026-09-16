pragma Singleton

import QtQml

QtObject {
    readonly property int contentHeight: 40
    readonly property int topMargin: 20
    readonly property int windowHeight: contentHeight + topMargin
    readonly property int stripHeight: 102
    readonly property int screenEdgeMargin: 8

    readonly property int workspaceGroupWidth: 116
    readonly property int workspaceGroupHeight: 33
    readonly property int workspaceIconSize: 16
    readonly property int workspaceIconSpacing: 4

    readonly property int centerLogoGap: 60
    readonly property int centerModuleWidth: 110

    readonly property int statusGroupWidth: 116
    readonly property int statusIconSpacing: 8
    readonly property int statusHoverIconSpacing: 4

    readonly property int ornamentFontSize: 14
    readonly property int statusHoverFontSize: 11
}
