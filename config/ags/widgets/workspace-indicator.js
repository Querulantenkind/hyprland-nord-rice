// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     WORKSPACE INDICATOR WIDGET - NORD THEME                ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

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

// Workspace icons mapping
const WORKSPACE_ICONS = {
    1: '󰲠',   // Terminal/Home
    2: '󰲢',   // Web Browser
    3: '󰲤',   // Code Editor
    4: '󰲦',   // Communication
    5: '󰲨',   // Media
    6: '󰲪',   // Graphics
    7: '󰲬',   // Documents
    8: '󰲮',   // Gaming
    9: '󰲰',   // System
    10: '󰿬',  // Special/Scratchpad
};

// Get workspace icon
const getWorkspaceIcon = (id) => {
    return WORKSPACE_ICONS[id] || '󰝦'; // Default icon
};

// Create workspace button with preview
const createWorkspaceButton = (id) => {
    const button = Widget.Button({
        className: Hyprland.active.workspace.bind('id').transform(activeId =>
            `workspace-btn ${activeId === id ? 'active' : ''}`
        ),
        onClicked: () => {
            Hyprland.message(`dispatch workspace ${id}`);
        },
        child: Widget.Box({
            vertical: true,
            spacing: 4,
            children: [
                // Workspace icon and number
                Widget.Box({
                    spacing: 6,
                    children: [
                        Widget.Label({
                            className: 'workspace-icon',
                            label: getWorkspaceIcon(id),
                        }),
                        Widget.Label({
                            className: 'workspace-number',
                            label: `${id}`,
                        }),
                    ],
                }),

                // Window preview dots
                Widget.Box({
                    className: 'workspace-windows',
                    spacing: 2,
                    setup: (self) => {
                        // Update window count
                        const updateWindows = () => {
                            const workspaces = Hyprland.workspaces;
                            const workspace = workspaces.find(ws => ws.id === id);

                            if (workspace && workspace.windows > 0) {
                                // Create dots for windows (max 5 dots)
                                const dotCount = Math.min(workspace.windows, 5);
                                const dots = Array.from({ length: dotCount }, () =>
                                    Widget.Box({
                                        className: 'window-dot',
                                        css: `
                                            min-width: 4px;
                                            min-height: 4px;
                                            border-radius: 2px;
                                            background: ${NORD8};
                                            opacity: 0.7;
                                        `,
                                    })
                                );

                                // Add overflow indicator if more than 5 windows
                                if (workspace.windows > 5) {
                                    dots.push(Widget.Label({
                                        className: 'window-overflow',
                                        label: '+',
                                        css: `
                                            font-size: 8px;
                                            color: ${NORD4};
                                            font-weight: bold;
                                        `,
                                    }));
                                }

                                self.children = dots;
                                self.visible = true;
                            } else {
                                self.children = [];
                                self.visible = false;
                            }
                        };

                        // Initial update
                        updateWindows();

                        // Listen for workspace changes
                        Hyprland.connect('changed', updateWindows);
                    },
                }),
            ],
        }),
    });

    return button;
};

// Main workspace indicator widget
export const WorkspaceIndicator = () => Widget.Box({
    className: 'workspace-indicator',
    spacing: 8,
    children: Array.from({ length: 10 }, (_, i) => createWorkspaceButton(i + 1)),
});

// Compact version for status displays
export const WorkspaceIndicatorCompact = () => Widget.Box({
    className: 'workspace-indicator-compact',
    spacing: 4,
    children: Array.from({ length: 10 }, (_, i) => {
        const id = i + 1;
        return Widget.Button({
            className: Hyprland.active.workspace.bind('id').transform(activeId =>
                `workspace-btn-compact ${activeId === id ? 'active' : ''}`
            ),
            onClicked: () => {
                Hyprland.message(`dispatch workspace ${id}`);
            },
            child: Widget.Label({
                className: 'workspace-number-compact',
                label: `${id}`,
            }),
        });
    }),
});

// Workspace overview popup
export const WorkspaceOverview = () => Widget.Window({
    name: 'workspace-overview',
    className: 'workspace-overview',
    anchor: ['top', 'bottom', 'left', 'right'],
    exclusivity: 'ignore',
    layer: 'overlay',
    visible: false,
    child: Widget.Box({
        className: 'workspace-overview-container',
        children: [
            // Close button
            Widget.Button({
                className: 'overview-close',
                onClicked: () => App.closeWindow('workspace-overview'),
                child: Widget.Label({
                    label: '✕',
                    className: 'close-icon',
                }),
            }),

            // Workspace grid
            Widget.Box({
                className: 'workspace-grid',
                vertical: true,
                spacing: 16,
                children: [
                    // Row 1: Workspaces 1-5
                    Widget.Box({
                        className: 'workspace-row',
                        spacing: 12,
                        children: Array.from({ length: 5 }, (_, i) => createWorkspaceButton(i + 1)),
                    }),

                    // Row 2: Workspaces 6-10
                    Widget.Box({
                        className: 'workspace-row',
                        spacing: 12,
                        children: Array.from({ length: 5 }, (_, i) => createWorkspaceButton(i + 6)),
                    }),
                ],
            }),
        ],
    }),
});

