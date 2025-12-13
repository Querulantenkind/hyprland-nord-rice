// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     AUDIO VISUALIZER WIDGET - NORD THEME                   ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Variable, exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';

// Configuration
const BAR_COUNT = 8;
const BAR_HEIGHT = 12;
const UPDATE_INTERVAL = 50; // ms

// Nord Colors
const NORD8 = '#88c0d0';  // Frost blue
const NORD9 = '#81a1c1';  // Frost blue-gray
const NORD3 = '#4c566a';  // Polar Night gray
const NORD0 = '#2e3440';  // Polar Night darkest

// Audio data variable
const audioData = Variable([], {
    poll: [UPDATE_INTERVAL, () => {
        try {
            // Check if cava is running and audio is playing
            const cavaRunning = exec('pgrep -x cava');
            if (!cavaRunning) return [];

            // Check for audio playback
            const hasAudio = exec('bash -c "pactl list sink-inputs 2>/dev/null | grep -q \'state: RUNNING\' && echo 1 || echo 0"');
            if (hasAudio !== '1') return [];

            // Try to read from cava FIFO
            const data = exec('bash -c "timeout 0.05 cat /tmp/cava.fifo 2>/dev/null || echo"');
            if (!data || data.trim() === '') return [];

            // Parse space-separated values
            return data.trim().split(/\s+/).map(v => parseInt(v) || 0);
        } catch (error) {
            return [];
        }
    }],
});

// Create individual bar widget
const createBar = (index) => {
    return Widget.Box({
        className: 'visualizer-bar',
        vertical: true,
        vpack: 'end',
        children: Array.from({ length: BAR_HEIGHT }, (_, i) => {
            return Widget.Box({
                className: `bar-segment segment-${i}`,
                setup: (self) => {
                    // Update bar height based on audio data
                    audioData.connect('changed', () => {
                        const data = audioData.value;
                        if (!data || data.length === 0) {
                            self.className = `bar-segment segment-${i} inactive`;
                            return;
                        }

                        // Map data to bar segments
                        const barIndex = Math.floor(index * data.length / BAR_COUNT);
                        const value = data[barIndex] || 0;
                        const height = Math.floor(value * BAR_HEIGHT / 100);

                        if (i < height) {
                            // Active segment - color based on height
                            let colorClass = 'low';
                            if (height > 8) colorClass = 'high';
                            else if (height > 5) colorClass = 'medium';

                            self.className = `bar-segment segment-${i} active ${colorClass}`;
                        } else {
                            self.className = `bar-segment segment-${i} inactive`;
                        }
                    });
                },
            });
        }),
    });
};

// Main visualizer widget
export const AudioVisualizer = () => Widget.Box({
    className: 'audio-visualizer',
    spacing: 2,
    children: Array.from({ length: BAR_COUNT }, (_, i) => createBar(i)),
    setup: (self) => {
        // Add click handler to toggle cava
        self.connect('button-press-event', () => {
            execAsync('bash ~/.config/waybar/scripts/audio-visualizer.sh toggle')
                .catch(err => console.error('Failed to toggle visualizer:', err));
        });
    },
});

// Compact version for status displays
export const AudioVisualizerCompact = () => Widget.Label({
    className: 'audio-visualizer-compact',
    label: Variable('', {
        poll: [100, () => {
            const data = audioData.value;
            if (!data || data.length === 0) return '󰎇';

            // Calculate average for compact display
            const avg = data.reduce((a, b) => a + b, 0) / data.length;
            if (avg > 70) return '󰎆󰎆󰎆';  // High activity
            if (avg > 40) return '󰎆󰎆';    // Medium activity
            return '󰎆';                    // Low activity
        }],
    }),
});

