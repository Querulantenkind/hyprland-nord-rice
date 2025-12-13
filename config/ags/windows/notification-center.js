// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     NOTIFICATION CENTER WINDOW - NORD THEME                ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { NotificationList, NotificationHeader } from '../widgets/notification.js';

let notificationCenterWindow = null;

export default () => {
    if (notificationCenterWindow) {
        notificationCenterWindow.destroy();
    }

    notificationCenterWindow = Widget.Window({
        name: 'notification-center',
        className: 'notification-center',
        anchor: ['top', 'right'],
        exclusivity: 'normal',
        layer: 'overlay',
        margins: [8, 8, 8, 8],
        keymode: 'exclusive',
        visible: false,
        child: Widget.EventBox({
            onPrimaryClick: () => {}, // Don't close on content click
            onSecondaryClick: () => App.closeWindow('notification-center'),
            child: Widget.Box({
                className: 'notification-center-container',
                vertical: true,
                children: [
                    // Header
                    NotificationHeader(),

                    // Notification list
                    Widget.Box({
                        className: 'notification-center-content',
                        child: NotificationList(),
                    }),

                    // Footer with settings
                    Widget.Box({
                        className: 'notification-footer',
                        children: [
                            Widget.Label({
                                className: 'notification-settings-hint',
                                label: 'Right-click to close • Middle-click to clear all',
                                xalign: 0.5,
                            }),
                        ],
                    }),
                ],
            }),
        }),
    });

    return notificationCenterWindow;
};

