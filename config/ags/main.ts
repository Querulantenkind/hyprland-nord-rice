#!/usr/bin/env -S ags run

// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     AGS MAIN - NORD/ICE GLASS UI                         ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

// Main entry point for AGS - Nord/Ice themed glass UI overlays for Hyprland

import { App } from 'resource:///com/github/Aylur/ags/app.js';
import { monitorFile } from 'resource:///com/github/Aylur/ags/utils.js';

// Import our custom windows
import OSD from './windows/osd.js';
import QuickSettings from './windows/quicksettings.js';
import PowerMenu from './windows/powermenu.js';
import Overview from './windows/overview.js';
import MiniDashboard from './windows/minidashboard.js';

// Import service modules for reactive updates
import './services/audio.js';
import './services/backlight.js';
import './services/bluetooth.js';
import './services/network.js';
import './services/battery.js';

// Apply our Nord/Ice theme
App.applyCss('./style.scss');

// Register LayerShell windows
App.config({
    windows: [
        OSD(),
        QuickSettings(),
        PowerMenu(),
        Overview(),
        MiniDashboard(),
    ],
});

// Monitor config file for hot reloading during development
monitorFile('./style.scss', () => {
    App.resetCss();
    App.applyCss('./style.scss');
});

monitorFile('./main.ts', () => {
    App.quit();
    App.launch();
});

export default { style: './style.scss' };
