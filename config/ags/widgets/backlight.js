// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     BACKLIGHT WIDGET - NORD/ICE THEME                     ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Brightness from '../services/backlight.js';

export const BrightnessSlider = () => Widget.Box({
    className: 'brightness-control',
    vertical: true,
    children: [
        Widget.Label({
            className: 'title',
            label: 'Brightness',
        }),
        Widget.Slider({
            className: 'brightness-slider',
            value: Brightness.bind('screen'),
            onChange: ({ value }) => Brightness.screen = value,
            min: 0,
            max: 1,
            step: 0.01,
        }),
        Widget.Label({
            className: 'subtitle',
            label: Brightness.bind('screen').transform(v =>
                `${Math.round(v * 100)}%`
            ),
        }),
    ],
});

export const BrightnessControls = () => Widget.Box({
    className: 'brightness-controls box horizontal center',
    children: [
        Widget.Label({
            className: 'icon accent',
            label: '',
        }),
        BrightnessSlider(),
    ],
});
