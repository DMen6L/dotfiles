import Quickshell
import Quickshell.Wayland
import QtQuick
import "../theme" as Theme

PanelWindow {
    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: Theme.Metrics.stripHeight
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Bottom

    Image {
        anchors.fill: parent
        source: Theme.Assets.mainBarStrip
        fillMode: Image.PreserveAspectCrop
        verticalAlignment: Image.AlignBottom
        smooth: false
        asynchronous: true
    }
}
