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

    implicitHeight: Theme.Metrics.stripHeight + 6
    color: "transparent"
    exclusionMode: ExclusionMode.Ignore

    WlrLayershell.layer: WlrLayer.Bottom

    Image {
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            topMargin: -8
        }

        height: Theme.Metrics.stripHeight
        source: Theme.Assets.mainBarStrip
        fillMode: Image.PreserveAspectCrop
        // The decorative rail sits in the upper part of the source image.
        // Cropping from the top keeps that rail behind the panel content.
        verticalAlignment: Image.AlignTop
        smooth: false
        asynchronous: true
    }
}
