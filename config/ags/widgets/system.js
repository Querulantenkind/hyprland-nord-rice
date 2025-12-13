// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     SYSTEM WIDGET - NORD/ICE THEME                        ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

export const BatteryWidget = () => Widget.Box({
    className: 'battery-widget box horizontal spacing',
    children: [
        Widget.Label({
            className: 'icon',
            label: Battery.bind('icon-name'),
        }),
        Widget.ProgressBar({
            className: 'battery-progress',
            value: Battery.bind('percent').transform(p => p / 100),
        }),
        Widget.Label({
            className: 'subtitle',
            label: Battery.bind('percent').transform(p => `${p}%`),
        }),
    ],
});

export const CpuWidget = () => Widget.Box({
    className: 'cpu-widget box horizontal spacing',
    children: [
        Widget.Label({
            className: 'icon',
            label: '',
        }),
        Widget.ProgressBar({
            className: 'cpu-progress',
            value: Variable(0, {
                poll: [2000, () => {
                    try {
                        const output = exec('bash -c "top -bn1 | grep \'Cpu(s)\' | sed \'s/.*, *\\([0-9.]*\\)%* id.*/\\1/\' | awk \'{print 100 - $1}\'"');
                        return parseFloat(output) / 100;
                    } catch {
                        return 0;
                    }
                }],
            }),
        }),
        Widget.Label({
            className: 'subtitle',
            label: Variable('', {
                poll: [2000, () => {
                    try {
                        const output = exec('bash -c "top -bn1 | grep \'Cpu(s)\' | sed \'s/.*, *\\([0-9.]*\\)%* id.*/\\1/\' | awk \'{print 100 - $1}\'"');
                        return `${Math.round(parseFloat(output))}%`;
                    } catch {
                        return 'N/A';
                    }
                }],
            }),
        }),
    ],
});

export const RamWidget = () => Widget.Box({
    className: 'ram-widget box horizontal spacing',
    children: [
        Widget.Label({
            className: 'icon',
            label: '',
        }),
        Widget.ProgressBar({
            className: 'ram-progress',
            value: Variable(0, {
                poll: [5000, () => {
                    try {
                        const output = exec('bash -c "free | grep Mem | awk \'{printf \\"%.0f\\", $3/$2 * 100.0}\'"');
                        return parseFloat(output) / 100;
                    } catch {
                        return 0;
                    }
                }],
            }),
        }),
        Widget.Label({
            className: 'subtitle',
            label: Variable('', {
                poll: [5000, () => {
                    try {
                        const output = exec('bash -c "free -h | grep Mem | awk \'{print $3 \"/\" $2}\'"');
                        return output;
                    } catch {
                        return 'N/A';
                    }
                }],
            }),
        }),
    ],
});

export const SystemStats = () => Widget.Box({
    className: 'system-stats box vertical spacing-lg',
    children: [
        Widget.Label({
            className: 'title',
            label: 'System',
        }),
        CpuWidget(),
        RamWidget(),
        BatteryWidget(),
    ],
});
