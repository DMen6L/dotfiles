import Quickshell
import Quickshell.Networking
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Scope {
    readonly property var wifiDevice: {
        if (!Networking.devices)
            return null;

        const devices = Networking.devices.values;

        for (let index = 0; index < devices.length; index++) {
            if (devices[index].type === DeviceType.Wifi)
                return devices[index];
        }

        return null;
    }

    readonly property var connectedWifi: {
        if (!wifiDevice || !wifiDevice.networks)
            return null;

        const networks = wifiDevice.networks.values;

        for (let index = 0; index < networks.length; index++) {
            if (networks[index].connected)
                return networks[index];
        }

        return null;
    }

    readonly property bool wifiEnabled: Networking.wifiEnabled
    readonly property bool wifiConnected: wifiDevice && wifiDevice.connected && connectedWifi
    readonly property int wifiLevel: connectedWifi ? Math.round(connectedWifi.signalStrength * 100) : 0

    readonly property var audioSink: Pipewire.defaultAudioSink
    readonly property bool audioAvailable: audioSink && audioSink.audio
    readonly property bool audioMuted: audioAvailable && audioSink.audio.muted
    readonly property real volumeLevel: audioAvailable ? audioSink.audio.volume : 0

    readonly property var battery: UPower.displayDevice
    readonly property bool batteryReady: battery && battery.ready
    readonly property bool onBattery: UPower.onBattery
    readonly property int batteryLevel: batteryReady ? Math.round(battery.percentage * 100) : 0

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
}
