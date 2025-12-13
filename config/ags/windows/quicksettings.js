// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     QUICK SETTINGS WINDOW - NORD/ICE THEME                ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { AudioControls } from '../widgets/audio.js';
import { BrightnessControls } from '../widgets/backlight.js';
import { NetworkControls } from '../widgets/network.js';
import { SystemStats } from '../widgets/system.js';

let quickSettingsWindow = null;

const toggleQuickSettings = () => {
    if (quickSettingsWindow) {
        quickSettingsWindow.destroy();
        quickSettingsWindow = null;
    } else {
        quickSettingsWindow = Widget.Window({
            name: 'quicksettings',
            className: 'quicksettings',
            layer: 'top',
            anchor: ['top', 'right'],
            margins: [8, 8, 0, 0],
            child: Widget.Box({
                className: 'box vertical spacing-lg',
                children: [
                    Widget.Label({
                        className: 'title',
                        label: 'Quick Settings',
                    }),

                    // Media controls placeholder
                    Widget.Box({
                        className: 'media-controls box horizontal center',
                        children: [
                            Widget.Label({
                                className: 'icon',
                                label: '',
                            }),
                            Widget.Label({
                                className: 'subtitle',
                                label: 'No media playing',
                            }),
                        ],
                    }),

                    // Controls section
                    Widget.Box({
                        className: 'controls-section box vertical spacing',
                        children: [
                            AudioControls(),
                            BrightnessControls(),
                            NetworkControls(),
                        ],
                    }),

                    // System stats
                    SystemStats(),

                    // Quick actions
                    Widget.Box({
                        className: 'quick-actions box horizontal spacing',
                        children: [
                            Widget.Button({
                                className: 'primary',
                                onClicked: () => {
                                    // Open settings
                                },
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '',
                                }),
                            }),
                            Widget.Button({
                                className: 'primary',
                                onClicked: () => {
                                    // Open power menu
                                    togglePowerMenu();
                                },
                                child: Widget.Label({
                                    className: 'icon',
                                    label: '',
                                }),
                            }),
                        ],
                    }),
                ],
            }),
        });
    }
};

export default () => {
    // Register toggle function globally for keybinding
    globalThis.toggleQuickSettings = toggleQuickSettings;

    // Return placeholder window
    return Widget.Window({
        name: 'quicksettings-placeholder',
        visible: false,
    });
};
