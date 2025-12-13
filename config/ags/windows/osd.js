// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     OSD WINDOW - NORD/ICE GLASS THEME                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { timeout } from 'resource:///com/github/Aylur/ags/utils.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Brightness from '../services/backlight.js';

let currentOsd = null;

const createOSD = (type, value, icon) => {
    if (currentOsd) {
        currentOsd.destroy();
    }

    const osd = Widget.Window({
        name: 'osd',
        className: 'osd',
        layer: 'overlay',
        anchor: ['top', 'right'],
        margins: [16, 16, 0, 0],
        child: Widget.Box({
            className: `osd-popup ${type}`,
            vertical: true,
            children: [
                Widget.Label({
                    className: 'icon accent',
                    label: icon,
                }),
                Widget.Label({
                    className: 'title',
                    label: type.charAt(0).toUpperCase() + type.slice(1),
                }),
                Widget.ProgressBar({
                    className: 'osd-progress',
                    value: value,
                }),
                Widget.Label({
                    className: 'subtitle',
                    label: `${Math.round(value * 100)}%`,
                }),
            ],
        }),
    });

    currentOsd = osd;

    // Auto-hide after 2 seconds
    timeout(2000, () => {
        if (currentOsd === osd) {
            osd.destroy();
            currentOsd = null;
        }
    });

    return osd;
};

export default () => {
    // Listen for volume changes
    Audio.speaker.connect('changed', () => {
        if (!Audio.speaker.is_muted) {
            createOSD('volume', Audio.speaker.volume, '');
        }
    });

    // Listen for brightness changes
    Brightness.connect('changed', () => {
        createOSD('brightness', Brightness.screen, '');
    });

    // Return empty widget - OSD is created dynamically
    return Widget.Window({
        name: 'osd-placeholder',
        visible: false,
    });
};
