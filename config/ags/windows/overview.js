// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     OVERVIEW WINDOW - NORD/ICE THEME                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';

let overviewWindow = null;

const createWorkspaceButton = (ws) => Widget.Button({
    className: Hyprland.active.workspace.bind('id').transform(activeId =>
        activeId === ws.id ? 'workspace-active' : 'workspace-inactive'
    ),
    onClicked: () => {
        Hyprland.message(`dispatch workspace ${ws.id}`);
        toggleOverview(); // Close overview after switching
    },
    child: Widget.Box({
        className: 'box vertical center',
        children: [
            Widget.Label({
                className: 'icon',
                label: Hyprland.active.workspace.bind('id').transform(activeId =>
                    activeId === ws.id ? '' : ''
                ),
            }),
            Widget.Label({
                className: 'subtitle',
                label: `${ws.id}`,
            }),
            Widget.Label({
                className: 'subtitle',
                label: ws.windows > 0 ? `${ws.windows} windows` : 'empty',
            }),
        ],
    }),
});

const toggleOverview = () => {
    if (overviewWindow) {
        overviewWindow.destroy();
        overviewWindow = null;
    } else {
        overviewWindow = Widget.Window({
            name: 'overview',
            className: 'overview',
            layer: 'top',
            anchor: ['top', 'left', 'right', 'bottom'],
            margins: [16, 16, 16, 16],
            child: Widget.Box({
                className: 'box vertical spacing',
                children: [
                    Widget.Label({
                        className: 'title',
                        label: 'Workspace Overview',
                    }),

                    Widget.Box({
                        className: 'workspaces-grid box horizontal spacing center',
                        children: Array.from({ length: 10 }, (_, i) => i + 1).map(id =>
                            createWorkspaceButton({
                                id,
                                windows: Hyprland.workspaces.find(ws => ws.id === id)?.windows || 0,
                            })
                        ),
                    }),

                    Widget.Box({
                        className: 'overview-actions box horizontal spacing center',
                        children: [
                            Widget.Button({
                                className: 'primary',
                                onClicked: toggleOverview,
                                child: Widget.Label({
                                    label: 'Close',
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
    globalThis.toggleOverview = toggleOverview;

    // Return placeholder window
    return Widget.Window({
        name: 'overview-placeholder',
        visible: false,
    });
};
