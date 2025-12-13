// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     POWER MENU WINDOW - NORD/ICE THEME                    ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec } from 'resource:///com/github/Aylur/ags/utils.js';

let powerMenuWindow = null;

const powerActions = [
    {
        label: 'Lock',
        icon: '',
        command: 'hyprlock',
        className: 'primary',
    },
    {
        label: 'Logout',
        icon: '',
        command: 'hyprctl dispatch exit',
        className: 'warning',
    },
    {
        label: 'Suspend',
        icon: '',
        command: 'systemctl suspend',
        className: 'primary',
    },
    {
        label: 'Hibernate',
        icon: '',
        command: 'systemctl hibernate',
        className: 'primary',
    },
    {
        label: 'Reboot',
        icon: '',
        command: 'systemctl reboot',
        className: 'warning',
    },
    {
        label: 'Shutdown',
        icon: '',
        command: 'systemctl poweroff',
        className: 'destructive',
    },
];

const togglePowerMenu = () => {
    if (powerMenuWindow) {
        powerMenuWindow.destroy();
        powerMenuWindow = null;
    } else {
        powerMenuWindow = Widget.Window({
            name: 'powermenu',
            className: 'powermenu',
            layer: 'top',
            anchor: ['top'],
            margins: [100, 0, 0, 0],
            child: Widget.Box({
                className: 'box vertical spacing',
                children: [
                    Widget.Label({
                        className: 'title',
                        label: 'Power Menu',
                    }),

                    Widget.Box({
                        className: 'power-actions box vertical spacing',
                        children: powerActions.map(action => Widget.Button({
                            className: action.className,
                            onClicked: () => {
                                exec(action.command);
                                togglePowerMenu(); // Close menu after action
                            },
                            child: Widget.Box({
                                className: 'box horizontal spacing center',
                                children: [
                                    Widget.Label({
                                        className: 'icon',
                                        label: action.icon,
                                    }),
                                    Widget.Label({
                                        className: 'title',
                                        label: action.label,
                                    }),
                                ],
                            }),
                        })),
                    }),

                    Widget.Button({
                        className: 'secondary',
                        onClicked: togglePowerMenu,
                        child: Widget.Label({
                            label: 'Cancel',
                        }),
                    }),
                ],
            }),
        });
    }
};

export default () => {
    // Register toggle function globally for keybinding
    globalThis.togglePowerMenu = togglePowerMenu;

    // Return placeholder window
    return Widget.Window({
        name: 'powermenu-placeholder',
        visible: false,
    });
};
