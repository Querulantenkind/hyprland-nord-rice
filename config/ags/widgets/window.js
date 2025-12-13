// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     WINDOW WIDGET - NORD/ICE THEME                          ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// Window icons mapping
const WINDOW_ICONS = {
    'firefox': '🌐',
    'chromium': '🌐',
    'chrome': '🌐',
    'code': '💻',
    'code-oss': '💻',
    'kitty': '🐱',
    'alacritty': '🐱',
    'terminal': '🐱',
    'thunar': '📁',
    'nautilus': '📁',
    'dolphin': '📁',
    'vlc': '🎵',
    'spotify': '🎵',
    'steam': '🎮',
    'discord': '💬',
    'telegram': '💬',
    'obsidian': '📝',
    'gimp': '🎨',
    'inkscape': '🎨',
    'default': ''
};

// Get window icon based on class
const getWindowIcon = (className) => {
    if (!className) return WINDOW_ICONS.default;

    const lowerClass = className.toLowerCase();
    for (const [key, icon] of Object.entries(WINDOW_ICONS)) {
        if (lowerClass.includes(key)) {
            return icon;
        }
    }
    return WINDOW_ICONS.default;
};

export const WindowPill = () => Widget.Box({
    className: 'window-pill',
    children: [
        Widget.Label({
            className: 'window-icon',
            label: Variable('', {
                poll: [1000, () => {
                    try {
                        const output = exec('hyprctl activewindow -j');
                        const window = JSON.parse(output);
                        return getWindowIcon(window.class);
                    } catch {
                        return WINDOW_ICONS.default;
                    }
                }],
            }),
        }),
        Widget.Label({
            className: 'window-title',
            label: Variable('', {
                poll: [1000, () => {
                    try {
                        const output = exec('hyprctl activewindow -j');
                        const window = JSON.parse(output);
                        const title = window.title || window.class || 'Desktop';
                        return title.length > 25 ? title.substring(0, 22) + '...' : title;
                    } catch {
                        return 'Desktop';
                    }
                }],
            }),
        }),
        Widget.Label({
            className: 'window-workspace',
            label: Variable('', {
                poll: [1000, () => {
                    try {
                        const output = exec('hyprctl activewindow -j');
                        const window = JSON.parse(output);
                        const workspace = window.workspace?.name || '1';
                        return `W${workspace}`;
                    } catch {
                        return 'W1';
                    }
                }],
            }),
        }),
    ],
});
