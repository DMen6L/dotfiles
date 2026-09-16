import Quickshell
import QtQuick
import "../theme" as Theme

Item {
    id: root

    width: Theme.Metrics.centerModuleWidth * 2 + Theme.Metrics.centerLogoGap
    height: Theme.Metrics.contentHeight

    SystemClock {
        id: clock
        precision: SystemClock.minutes
    }

    Item {
        anchors {
            left: parent.left
            verticalCenter: parent.verticalCenter
        }

        width: Theme.Metrics.centerModuleWidth
        height: Theme.Metrics.contentHeight

        Image {
            anchors.fill: parent
            source: Theme.Assets.moduleFrame
            fillMode: Image.Stretch
            smooth: false
            asynchronous: true
        }

        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "ddd dd")
            color: Theme.Colors.ornamentText
            font.pixelSize: Theme.Metrics.ornamentFontSize
            font.bold: true
        }
    }

    Item {
        anchors.centerIn: parent
        width: Theme.Metrics.centerLogoGap
        height: parent.height
    }

    Item {
        anchors {
            right: parent.right
            verticalCenter: parent.verticalCenter
        }

        width: Theme.Metrics.centerModuleWidth
        height: Theme.Metrics.contentHeight

        Image {
            anchors.fill: parent
            source: Theme.Assets.moduleFrame
            fillMode: Image.Stretch
            smooth: false
            asynchronous: true
        }

        Text {
            anchors.centerIn: parent
            text: Qt.formatDateTime(clock.date, "HH:mm")
            color: Theme.Colors.ornamentText
            font.pixelSize: Theme.Metrics.ornamentFontSize
            font.bold: true
        }
    }
}
