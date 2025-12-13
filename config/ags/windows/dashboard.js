// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     FULLSCREEN DASHBOARD - NORD/ICE THEME                 ║
// ║         Inspired by macOS Launchpad & GNOME Overview                       ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import { Variable, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// Import widgets
import { WeatherWidget, WeatherCompact } from '../widgets/weather.js';
import { CalendarWidget, TimeWidget, CalendarCompact } from '../widgets/calendar.js';
import { MusicSection } from '../widgets/music.js';
import { AppLauncher, resetSearch } from '../widgets/applauncher.js';
import { SystemStats } from '../widgets/system.js';

let dashboardWindow = null;

// Close dashboard function
const closeDashboard = () => {
    if (dashboardWindow) {
        resetSearch(); // Reset app search
        dashboardWindow.destroy();
        dashboardWindow = null;
    }
};

// Greeting based on time
const getGreeting = () => {
    const hour = new Date().getHours();
    if (hour < 6) return 'Gute Nacht';
    if (hour < 12) return 'Guten Morgen';
    if (hour < 18) return 'Guten Tag';
    return 'Guten Abend';
};

const greeting = Variable(getGreeting(), {
    poll: [60000, getGreeting],
});

// User info
const username = Variable('', {
    poll: [3600000, () => {
        try {
            return execAsync('whoami').then(name => name.trim());
        } catch {
            return 'User';
        }
    }],
});

// System uptime
const uptime = Variable('', {
    poll: [60000, async () => {
        try {
            const result = await execAsync('uptime -p');
            return result.replace('up ', '').trim();
        } catch {
            return '';
        }
    }],
});

// Header section with time, greeting, weather
const DashboardHeader = () => Widget.Box({
    className: 'dashboard-header',
    children: [
        // Left: Time and greeting
        Widget.Box({
            className: 'header-left',
            vertical: true,
            children: [
                TimeWidget(),
                Widget.Label({
                    className: 'greeting',
                    xalign: 0,
                    label: greeting.bind().transform(g => 
                        `${g}, ${username.value || 'User'}`
                    ),
                }),
            ],
        }),
        
        Widget.Box({ hexpand: true }), // Spacer
        
        // Right: Weather compact
        WeatherCompact(),
    ],
});

// Workspace overview section
const WorkspacePreview = () => {
    const createWorkspaceButton = (id) => Widget.Button({
        className: Hyprland.active.workspace.bind('id').transform(activeId =>
            `workspace-btn ${activeId === id ? 'active' : ''}`
        ),
        onClicked: () => {
            Hyprland.message(`dispatch workspace ${id}`);
            closeDashboard();
        },
        child: Widget.Box({
            vertical: true,
            children: [
                Widget.Label({
                    className: 'workspace-number',
                    label: `${id}`,
                }),
                Widget.Label({
                    className: 'workspace-windows',
                    label: Hyprland.bind('workspaces').transform(ws => {
                        const workspace = ws.find(w => w.id === id);
                        const count = workspace?.windows || 0;
                        return count > 0 ? `${count}` : '';
                    }),
                }),
            ],
        }),
    });

    return Widget.Box({
        className: 'workspace-preview',
        children: [
            Widget.Label({
                className: 'section-title',
                label: ' Workspaces',
            }),
            Widget.Box({
                className: 'workspace-grid',
                children: Array.from({ length: 10 }, (_, i) => createWorkspaceButton(i + 1)),
            }),
        ],
    });
};

// Quick info panel (battery, uptime, etc.)
const QuickInfo = () => Widget.Box({
    className: 'quick-info',
    children: [
        // Battery
        Widget.Box({
            className: 'info-item',
            children: [
                Widget.Label({
                    className: 'info-icon',
                    label: Battery.bind('percent').transform(p => {
                        if (Battery.charging) return '󰂄';
                        if (p > 80) return '󰁹';
                        if (p > 60) return '󰂀';
                        if (p > 40) return '󰁾';
                        if (p > 20) return '󰁻';
                        return '󰂃';
                    }),
                }),
                Widget.Label({
                    className: 'info-value',
                    label: Battery.bind('percent').transform(p => `${p}%`),
                }),
            ],
        }),
        
        // Uptime
        Widget.Box({
            className: 'info-item',
            children: [
                Widget.Label({
                    className: 'info-icon',
                    label: '󰅐',
                }),
                Widget.Label({
                    className: 'info-value',
                    label: uptime.bind(),
                }),
            ],
        }),
        
        // Active windows
        Widget.Box({
            className: 'info-item',
            children: [
                Widget.Label({
                    className: 'info-icon',
                    label: '󰖯',
                }),
                Widget.Label({
                    className: 'info-value',
                    label: Hyprland.bind('clients').transform(c => `${c.length}`),
                }),
            ],
        }),
    ],
});

// Power buttons
const PowerButtons = () => Widget.Box({
    className: 'power-buttons',
    children: [
        Widget.Button({
            className: 'power-btn lock',
            onClicked: () => {
                closeDashboard();
                execAsync('hyprlock');
            },
            child: Widget.Label({ label: '󰌾' }),
            tooltipText: 'Sperren',
        }),
        Widget.Button({
            className: 'power-btn logout',
            onClicked: () => {
                closeDashboard();
                globalThis.togglePowerMenu?.();
            },
            child: Widget.Label({ label: '󰗼' }),
            tooltipText: 'Abmelden',
        }),
        Widget.Button({
            className: 'power-btn settings',
            onClicked: () => {
                closeDashboard();
                globalThis.toggleQuickSettings?.();
            },
            child: Widget.Label({ label: '' }),
            tooltipText: 'Einstellungen',
        }),
    ],
});

// Left sidebar with widgets
const LeftSidebar = () => Widget.Box({
    className: 'dashboard-sidebar left',
    vertical: true,
    children: [
        // Weather full
        Widget.Box({
            className: 'sidebar-section',
            child: WeatherWidget(),
        }),
        
        // Music player
        Widget.Box({
            className: 'sidebar-section',
            child: MusicSection(),
        }),
    ],
});

// Right sidebar with calendar and system
const RightSidebar = () => Widget.Box({
    className: 'dashboard-sidebar right',
    vertical: true,
    children: [
        // Calendar
        Widget.Box({
            className: 'sidebar-section',
            child: CalendarWidget(),
        }),
        
        // System stats
        Widget.Box({
            className: 'sidebar-section',
            vertical: true,
            children: [
                Widget.Label({
                    className: 'section-title',
                    xalign: 0,
                    label: '󰻠 System',
                }),
                SystemStats(),
            ],
        }),
    ],
});

// Main content area with app launcher
const MainContent = () => Widget.Box({
    className: 'dashboard-main',
    vertical: true,
    hexpand: true,
    vexpand: true,
    children: [
        // Workspace preview
        WorkspacePreview(),
        
        // App launcher (takes remaining space)
        Widget.Box({
            className: 'app-launcher-container',
            vexpand: true,
            child: AppLauncher(closeDashboard),
        }),
    ],
});

// Footer with quick info and power
const DashboardFooter = () => Widget.Box({
    className: 'dashboard-footer',
    children: [
        QuickInfo(),
        Widget.Box({ hexpand: true }),
        PowerButtons(),
    ],
});

// Toggle dashboard function
const toggleDashboard = () => {
    if (dashboardWindow) {
        closeDashboard();
    } else {
        dashboardWindow = Widget.Window({
            name: 'dashboard',
            className: 'dashboard',
            layer: 'overlay',
            exclusivity: 'ignore',
            keymode: 'exclusive',
            anchor: ['top', 'left', 'right', 'bottom'],
            margins: [0, 0, 0, 0],
            child: Widget.EventBox({
                onPrimaryClick: (_, event) => {
                    // Close when clicking the background
                    if (event.target === event.widget) {
                        closeDashboard();
                    }
                },
                child: Widget.Box({
                    className: 'dashboard-container',
                    vertical: true,
                    children: [
                        // Header
                        DashboardHeader(),
                        
                        // Main layout
                        Widget.Box({
                            className: 'dashboard-body',
                            vexpand: true,
                            children: [
                                LeftSidebar(),
                                MainContent(),
                                RightSidebar(),
                            ],
                        }),
                        
                        // Footer
                        DashboardFooter(),
                    ],
                }),
            }),
            setup: self => {
                // Close on Escape key
                self.keybind('Escape', closeDashboard);
                self.keybind('Super_L', closeDashboard);
            },
        });
    }
};

export default () => {
    // Register toggle function globally for keybindings
    globalThis.toggleDashboard = toggleDashboard;

    // Return placeholder window (the actual dashboard is created dynamically)
    return Widget.Window({
        name: 'dashboard-placeholder',
        visible: false,
    });
};

