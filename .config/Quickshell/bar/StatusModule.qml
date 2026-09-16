import QtQuick
import "../theme" as Theme

Item {
    id: root

    property var statusData

    width: Theme.Metrics.statusGroupWidth
    height: Theme.Metrics.contentHeight

    HoverHandler {
        id: statusHover
    }

    Image {
        anchors.fill: parent
        source: Theme.Assets.moduleFrame
        fillMode: Image.Stretch
        smooth: false
        asynchronous: true
    }

    Row {
        anchors.centerIn: parent
        spacing: statusHover.hovered ? Theme.Metrics.statusHoverIconSpacing : Theme.Metrics.statusIconSpacing

        Text {
            text: {
                if (statusHover.hovered)
                    return root.statusData && root.statusData.wifiConnected ? root.statusData.wifiLevel + "%" : "--";

                if (!root.statusData || !root.statusData.wifiEnabled || !root.statusData.wifiConnected)
                    return "󰤭";

                if (root.statusData.wifiLevel < 0.25)
                    return "󰤟";
                else if (root.statusData.wifiLevel < 0.50)
                    return "󰤢";
                else if (root.statusData.wifiLevel < 0.75)
                    return "󰤥";
                else
                    return "󰤨";
            }

            color: Theme.Colors.ornamentText
            font.pixelSize: statusHover.hovered ? Theme.Metrics.statusHoverFontSize : Theme.Metrics.ornamentFontSize
        }

        Text {
            text: {
                if (statusHover.hovered)
                    return Math.round(root.statusData ? root.statusData.volumeLevel * 100 : 0) + "%";

                if (!root.statusData || !root.statusData.audioAvailable || root.statusData.audioMuted || root.statusData.volumeLevel <= 0.0)
                    return "󰖁";
                else if (root.statusData.volumeLevel < 0.35)
                    return "󰕿";
                else if (root.statusData.volumeLevel < 0.7)
                    return "󰖀";
                else
                    return "󰕾";
            }

            color: Theme.Colors.ornamentText
            font.pixelSize: statusHover.hovered ? Theme.Metrics.statusHoverFontSize : Theme.Metrics.ornamentFontSize
        }

        Text {
            text: {
                if (!root.statusData || !root.statusData.batteryReady)
                    return "󰂑";

                if (statusHover.hovered)
                    return root.statusData.batteryLevel + "%";

                let batteryIcon = "";

                if (!root.statusData.onBattery)
                    batteryIcon += "󱐋";

                if (root.statusData.batteryLevel <= 10)
                    batteryIcon += "󰁺";
                else if (root.statusData.batteryLevel <= 20)
                    batteryIcon += "󰁻";
                else if (root.statusData.batteryLevel <= 30)
                    batteryIcon += "󰁼";
                else if (root.statusData.batteryLevel <= 40)
                    batteryIcon += "󰁽";
                else if (root.statusData.batteryLevel <= 50)
                    batteryIcon += "󰁾";
                else if (root.statusData.batteryLevel <= 60)
                    batteryIcon += "󰁿";
                else if (root.statusData.batteryLevel <= 70)
                    batteryIcon += "󰂀";
                else if (root.statusData.batteryLevel <= 80)
                    batteryIcon += "󰂁";
                else if (root.statusData.batteryLevel <= 90)
                    batteryIcon += "󰂂";
                else
                    batteryIcon += "󰁹";

                return batteryIcon;
            }

            color: Theme.Colors.ornamentText
            font.pixelSize: statusHover.hovered ? Theme.Metrics.statusHoverFontSize : Theme.Metrics.ornamentFontSize
        }
    }
}
