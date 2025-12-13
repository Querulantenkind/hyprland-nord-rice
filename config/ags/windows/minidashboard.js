// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     MINI DASHBOARD WINDOW - NORD/ICE THEME                   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { VolumeSlider, MicToggle } from '../widgets/audio.js';
import { BrightnessControls } from '../widgets/backlight.js';
import { NetworkControls } from '../widgets/network.js';
import { SystemStats } from '../widgets/system.js';

let miniDashboardWindow = null;

const toggleMiniDashboard = () => {
    if (miniDashboardWindow) {
        miniDashboardWindow.destroy();
        miniDashboardWindow = null;
    } else {
        miniDashboardWindow = Widget.Window({
            name: 'minidashboard',
            className: 'minidashboard',
            layer: 'top',
            anchor: ['top', 'left'],
            margins: [50, 0, 0, 50], // Position below waybar
            child: Widget.Box({
                className: 'container',
                vertical: true,
                children: [
                    // Header with quick actions
                    Widget.Box({
                        className: 'header',
                        children: [
                            Widget.Label({
                                className: 'title',
                                label: ' Quick Access',
                            }),
                            Widget.Box({ hexpand: true }), // Spacer
                            Widget.Button({
                                className: 'close-btn',
                                onClicked: () => toggleMiniDashboard(),
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '✕',
                                }),
                            }),
                        ],
                    }),

                    // Main controls grid
                    Widget.Box({
                        className: 'controls-grid',
                        vertical: true,
                        children: [
                            // Audio & Brightness row
                            Widget.Box({
                                className: 'control-row',
                                children: [
                                    Widget.Box({
                                        className: 'control-item',
                                        vertical: true,
                                        children: [
                                            Widget.Label({
                                                className: 'control-icon',
                                                label: '󰕾',
                                            }),
                                            VolumeSlider(),
                                        ],
                                    }),
                                    Widget.Box({
                                        className: 'control-item',
                                        vertical: true,
                                        children: [
                                            Widget.Label({
                                                className: 'control-icon',
                                                label: '󰃟',
                                            }),
                                            BrightnessControls(),
                                        ],
                                    }),
                                ],
                            }),

                            // Network & System row
                            Widget.Box({
                                className: 'control-row',
                                children: [
                                    Widget.Box({
                                        className: 'control-item',
                                        vertical: true,
                                        children: [
                                            Widget.Label({
                                                className: 'control-icon',
                                                label: '󰖩',
                                            }),
                                            NetworkControls(),
                                        ],
                                    }),
                                    Widget.Box({
                                        className: 'control-item',
                                        vertical: true,
                                        children: [
                                            Widget.Label({
                                                className: 'control-icon',
                                                label: '󰻠',
                                            }),
                                            SystemStats(),
                                        ],
                                    }),
                                ],
                            }),
                        ],
                    }),

                    // Quick action buttons
                    Widget.Box({
                        className: 'quick-actions',
                        children: [
                            Widget.Button({
                                className: 'action-btn primary',
                                onClicked: () => {
                                    // Open full quick settings
                                    globalThis.toggleQuickSettings?.();
                                    toggleMiniDashboard();
                                },
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '',
                                }),
                                tooltipText: 'Full Settings',
                            }),
                            Widget.Button({
                                className: 'action-btn',
                                onClicked: () => {
                                    // Open power menu
                                    globalThis.togglePowerMenu?.();
                                    toggleMiniDashboard();
                                },
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '',
                                }),
                                tooltipText: 'Power Menu',
                            }),
                            Widget.Button({
                                className: 'action-btn',
                                onClicked: () => {
                                    // Open overview
                                    globalThis.toggleOverview?.();
                                    toggleMiniDashboard();
                                },
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '',
                                }),
                                tooltipText: 'Workspace Overview',
                            }),
                            Widget.Button({
                                className: 'action-btn',
                                onClicked: () => {
                                    // Toggle microphone
                                    MicToggle();
                                },
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '',
                                }),
                                tooltipText: 'Toggle Microphone',
                            }),
                        ],
                    }),
                ],
            }),
        });
    }
};

export default () => {
    // Register toggle function globally for keybindings
    globalThis.toggleMiniDashboard = toggleMiniDashboard;

    // Return placeholder window
    return Widget.Window({
        name: 'minidashboard-placeholder',
        visible: false,
    });
};
