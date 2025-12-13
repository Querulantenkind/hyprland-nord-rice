// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     NETWORK WIDGET - NORD/ICE THEME                       ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';

export const NetworkToggle = () => Widget.Button({
    className: Network.wifi.bind('enabled').transform(enabled =>
        enabled ? 'network-active' : 'network-disabled'
    ),
    onClicked: () => {
        const wifi = Network.wifi;
        wifi.enabled = !wifi.enabled;
    },
    child: Widget.Box({
        className: 'box horizontal spacing',
        children: [
            Widget.Label({
                className: 'icon',
                label: Network.wifi.bind('icon-name'),
            }),
            Widget.Label({
                className: 'title',
                label: Network.wifi.bind('ssid').transform(ssid =>
                    ssid || 'Wi-Fi'
                ),
            }),
        ],
    }),
});

export const NetworkControls = () => Widget.Box({
    className: 'network-controls box vertical spacing',
    children: [
        Widget.Label({
            className: 'title',
            label: 'Network',
        }),
        NetworkToggle(),
    ],
});
