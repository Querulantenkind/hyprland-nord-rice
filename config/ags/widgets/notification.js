// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     NOTIFICATION WIDGET - NORD THEME                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';

// Nord Colors
const NORD0 = '#2e3440';  // Polar Night darkest
const NORD1 = '#3b4252';  // Polar Night
const NORD2 = '#434c5e';  // Polar Night
const NORD3 = '#4c566a';  // Polar Night gray
const NORD4 = '#d8dee9';  // Snow Storm
const NORD5 = '#e5e9f0';  // Snow Storm
const NORD6 = '#eceff4';  // Snow Storm lightest
const NORD7 = '#8fbcbb';  // Frost cyan
const NORD8 = '#88c0d0';  // Frost bright cyan (primary accent)
const NORD9 = '#81a1c1';  // Frost blue
const NORD10 = '#5e81ac'; // Frost dark blue
const NORD11 = '#bf616a'; // Aurora red
const NORD12 = '#d08770'; // Aurora orange
const NORD13 = '#ebcb8b'; // Aurora yellow
const NORD14 = '#a3be8c'; // Aurora green
const NORD15 = '#b48ead'; // Aurora purple

// Get notification icon based on urgency
const getNotificationIcon = (notification) => {
    const urgency = notification.urgency;
    const appIcon = notification.app_icon || notification.image;

    if (appIcon) {
        return appIcon;
    }

    // Default icons based on urgency
    switch (urgency) {
        case 'critical':
            return '󰀦'; // Critical notification
        case 'normal':
            return '󰂚'; // Normal notification
        case 'low':
            return '󰂜'; // Low priority notification
        default:
            return '󰂚';
    }
};

// Get urgency color
const getUrgencyColor = (urgency) => {
    switch (urgency) {
        case 'critical':
            return NORD11; // Red
        case 'normal':
            return NORD8;  // Blue
        case 'low':
            return NORD3;  // Gray
        default:
            return NORD8;
    }
};

// Create notification item
const createNotificationItem = (notification) => {
    const item = Widget.EventBox({
        className: 'notification-item',
        onPrimaryClick: () => {
            notification.close();
        },
        child: Widget.Box({
            className: 'notification-content',
            children: [
                // Icon
                Widget.Box({
                    className: 'notification-icon-container',
                    child: Widget.Label({
                        className: 'notification-icon',
                        label: getNotificationIcon(notification),
                        css: `color: ${getUrgencyColor(notification.urgency)};`,
                    }),
                }),

                // Text content
                Widget.Box({
                    className: 'notification-text',
                    vertical: true,
                    children: [
                        // App name and time
                        Widget.Box({
                            className: 'notification-header',
                            children: [
                                Widget.Label({
                                    className: 'notification-app',
                                    label: notification.app_name || 'Unknown App',
                                    xalign: 0,
                                    hexpand: true,
                                }),
                                Widget.Label({
                                    className: 'notification-time',
                                    label: new Date(notification.time * 1000).toLocaleTimeString([], {
                                        hour: '2-digit',
                                        minute: '2-digit'
                                    }),
                                }),
                            ],
                        }),

                        // Title
                        Widget.Label({
                            className: 'notification-title',
                            label: notification.summary,
                            xalign: 0,
                            wrap: true,
                        }),

                        // Body
                        notification.body ? Widget.Label({
                            className: 'notification-body',
                            label: notification.body,
                            xalign: 0,
                            wrap: true,
                            maxWidthChars: 50,
                        }) : null,

                        // Actions
                        notification.actions.length > 0 ? Widget.Box({
                            className: 'notification-actions',
                            spacing: 8,
                            children: notification.actions.map(action =>
                                Widget.Button({
                                    className: 'notification-action',
                                    label: action.label,
                                    onClicked: () => {
                                        notification.invoke(action.id);
                                        notification.close();
                                    },
                                })
                            ),
                        }) : null,
                    ].filter(Boolean),
                }),

                // Close button
                Widget.Button({
                    className: 'notification-close',
                    onClicked: () => notification.close(),
                    child: Widget.Label({
                        label: '✕',
                        className: 'close-icon',
                    }),
                }),
            ],
        }),
    });

    return item;
};

// Main notification list
export const NotificationList = () => Widget.Scrollable({
    className: 'notification-list',
    vscroll: 'automatic',
    hscroll: 'never',
    child: Widget.Box({
        className: 'notification-container',
        vertical: true,
        spacing: 8,
        children: Notifications.bind('notifications').transform(notifications => {
            // Group notifications by app (show max 3 per app)
            const grouped = {};
            notifications.forEach(notification => {
                const app = notification.app_name || 'Unknown';
                if (!grouped[app]) grouped[app] = [];
                if (grouped[app].length < 3) { // Max 3 notifications per app
                    grouped[app].push(notification);
                }
            });

            // Create notification items
            const items = [];
            Object.entries(grouped).forEach(([app, appNotifications]) => {
                // App separator for multiple apps
                if (Object.keys(grouped).length > 1) {
                    items.push(Widget.Label({
                        className: 'notification-app-separator',
                        label: app,
                        xalign: 0,
                    }));
                }

                // Add notifications for this app
                appNotifications.forEach(notification => {
                    items.push(createNotificationItem(notification));
                });
            });

            return items.length > 0 ? items : [
                Widget.Box({
                    className: 'no-notifications',
                    vertical: true,
                    spacing: 16,
                    children: [
                        Widget.Label({
                            className: 'no-notifications-icon',
                            label: '󰂚',
                        }),
                        Widget.Label({
                            className: 'no-notifications-text',
                            label: 'No notifications',
                        }),
                        Widget.Label({
                            className: 'no-notifications-hint',
                            label: 'You\'re all caught up!',
                        }),
                    ],
                }),
            ];
        }),
    }),
});

// Notification center header
export const NotificationHeader = () => Widget.Box({
    className: 'notification-header',
    children: [
        Widget.Label({
            className: 'notification-center-title',
            label: 'Notifications',
            xalign: 0,
            hexpand: true,
        }),

        // Clear all button
        Widget.Button({
            className: 'clear-all-btn',
            label: 'Clear All',
            visible: Notifications.bind('notifications').transform(n => n.length > 0),
            onClicked: () => {
                Notifications.notifications.forEach(n => n.close());
            },
        }),

        // Do not disturb toggle
        Widget.Button({
            className: 'dnd-toggle',
            onClicked: () => {
                Notifications.dnd = !Notifications.dnd;
            },
            child: Widget.Label({
                label: Notifications.bind('dnd').transform(dnd =>
                    dnd ? '󰂛' : '󰂚'
                ),
                className: 'dnd-icon',
            }),
        }),
    ],
});

// Compact notification indicator for status bars
export const NotificationIndicator = () => Widget.Button({
    className: 'notification-indicator',
    onClicked: () => {
        // This would typically toggle the notification center window
        // Implementation depends on how the center is integrated
    },
    child: Widget.Box({
        spacing: 6,
        children: [
            Widget.Label({
                className: 'notification-indicator-icon',
                label: Notifications.bind('dnd').transform(dnd =>
                    dnd ? '󰂛' : '󰂚'
                ),
            }),
            Widget.Label({
                className: 'notification-count',
                label: Notifications.bind('notifications').transform(notifications =>
                    notifications.length > 0 ? notifications.length.toString() : ''
                ),
                visible: Notifications.bind('notifications').transform(notifications =>
                    notifications.length > 0
                ),
            }),
        ],
    }),
});

