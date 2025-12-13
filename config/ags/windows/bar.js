// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     BAR WINDOW - NORD/ICE THEME                            ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { WindowPill } from '../widgets/window.js';
import { AudioVisualizerCompact } from '../widgets/audio-visualizer.js';

export default () => Widget.Window({
    name: 'bar',
    className: 'bar',
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    layer: 'top',
    margins: [5, 10, 0, 10],
    child: Widget.CenterBox({
        className: 'bar-content',
        startWidget: Widget.Box({
            className: 'bar-left',
            children: [
                // Hier können weitere Widgets hinzugefügt werden
            ],
        }),
        centerWidget: WindowPill(),
        endWidget: Widget.Box({
            className: 'bar-right',
            children: [
                AudioVisualizerCompact(),
            ],
        }),
    }),
});
