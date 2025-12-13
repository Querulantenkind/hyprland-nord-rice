// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     WORKSPACE PREVIEW WINDOW - NORD THEME                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import { WorkspaceIndicator } from '../widgets/workspace-indicator.js';

let workspacePreviewWindow = null;

export default () => {
    if (workspacePreviewWindow) {
        workspacePreviewWindow.destroy();
    }

    workspacePreviewWindow = Widget.Window({
        name: 'workspace-preview',
        className: 'workspace-preview',
        anchor: ['top', 'bottom', 'left', 'right'],
        exclusivity: 'ignore',
        layer: 'overlay',
        keymode: 'exclusive',
        visible: false,
        child: Widget.EventBox({
            onPrimaryClick: () => App.closeWindow('workspace-preview'),
            onSecondaryClick: () => App.closeWindow('workspace-preview'),
            child: Widget.Box({
                className: 'workspace-preview-container',
                children: [
                    // Header with close button
                    Widget.Box({
                        className: 'preview-header',
                        children: [
                            Widget.Label({
                                className: 'preview-title',
                                label: 'Workspace Overview',
                                xalign: 0,
                                hexpand: true,
                            }),
                            Widget.Button({
                                className: 'preview-close',
                                onClicked: () => App.closeWindow('workspace-preview'),
                                child: Widget.Label({
                                    label: '✕',
                                    className: 'close-icon',
                                }),
                            }),
                        ],
                    }),

                    // Workspace grid
                    Widget.Box({
                        className: 'preview-grid',
                        vertical: true,
                        spacing: 20,
                        children: [
                            // Row 1: Workspaces 1-5
                            Widget.Box({
                                className: 'preview-row',
                                spacing: 16,
                                children: Array.from({ length: 5 }, (_, i) => createWorkspacePreview(i + 1)),
                            }),

                            // Row 2: Workspaces 6-10
                            Widget.Box({
                                className: 'preview-row',
                                spacing: 16,
                                children: Array.from({ length: 5 }, (_, i) => createWorkspacePreview(i + 6)),
                            }),
                        ],
                    }),
                ],
            }),
        }),
    });

    return workspacePreviewWindow;
};

// Create enhanced workspace preview with thumbnails
const createWorkspacePreview = (id) => {
    return Widget.Button({
        className: Hyprland.active.workspace.bind('id').transform(activeId =>
            `workspace-preview-btn ${activeId === id ? 'active' : ''}`
        ),
        onClicked: () => {
            Hyprland.message(`dispatch workspace ${id}`);
            App.closeWindow('workspace-preview');
        },
        child: Widget.Box({
            className: 'workspace-preview-content',
            vertical: true,
            spacing: 8,
            children: [
                // Workspace header
                Widget.Box({
                    className: 'workspace-header',
                    spacing: 8,
                    children: [
                        Widget.Label({
                            className: 'workspace-icon-large',
                            label: getWorkspaceIcon(id),
                        }),
                        Widget.Label({
                            className: 'workspace-title',
                            label: `Workspace ${id}`,
                        }),
                        Widget.Label({
                            className: 'workspace-window-count',
                            label: Hyprland.workspaces.bind().transform(workspaces => {
                                const workspace = workspaces.find(ws => ws.id === id);
                                const count = workspace ? workspace.windows : 0;
                                return count > 0 ? `${count} window${count > 1 ? 's' : ''}` : 'Empty';
                            }),
                        }),
                    ],
                }),

                // Window thumbnails area (simplified representation)
                Widget.Box({
                    className: 'window-thumbnails',
                    spacing: 4,
                    setup: (self) => {
                        const updateThumbnails = () => {
                            const workspaces = Hyprland.workspaces;
                            const workspace = workspaces.find(ws => ws.id === id);

                            if (workspace && workspace.windows > 0) {
                                // Create thumbnail representations (simplified)
                                const thumbnails = Array.from({ length: Math.min(workspace.windows, 6) }, (_, i) =>
                                    Widget.Box({
                                        className: 'window-thumbnail',
                                        css: `
                                            min-width: 20px;
                                            min-height: 15px;
                                            border-radius: 3px;
                                            background: linear-gradient(45deg, #88c0d0, #81a1c1);
                                            border: 1px solid rgba(46, 52, 64, 0.3);
                                        `,
                                    })
                                );

                                self.children = thumbnails;
                            } else {
                                self.children = [
                                    Widget.Label({
                                        className: 'empty-workspace',
                                        label: 'No windows',
                                        css: `
                                            color: #4c566a;
                                            font-size: 10px;
                                            font-style: italic;
                                        `,
                                    }),
                                ];
                            }
                        };

                        updateThumbnails();
                        Hyprland.connect('changed', updateThumbnails);
                    },
                }),
            ],
        }),
    });
};

// Get workspace icon (same as in workspace-indicator.js)
const getWorkspaceIcon = (id) => {
    const icons = {
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
    return icons[id] || '󰝦';
};

