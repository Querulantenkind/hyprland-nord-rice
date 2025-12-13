// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     AUDIO WIDGET - NORD/ICE THEME                         ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';

export const VolumeSlider = () => Widget.Box({
    className: 'volume-control',
    vertical: true,
    children: [
        Widget.Label({
            className: 'title',
            label: 'Volume',
        }),
        Widget.Slider({
            className: 'volume-slider',
            value: Audio.speaker.bind('volume'),
            onChange: ({ value }) => Audio.speaker.volume = value,
            min: 0,
            max: 1,
            step: 0.01,
        }),
        Widget.Label({
            className: 'subtitle',
            label: Audio.speaker.bind('volume').transform(v =>
                `${Math.round(v * 100)}%`
            ),
        }),
    ],
});

export const MicToggle = () => Widget.Button({
    className: Audio.microphone.bind('is-muted').transform(muted =>
        muted ? 'mic-muted' : 'mic-active'
    ),
    onClicked: () => Audio.microphone.is_muted = !Audio.microphone.is_muted,
    child: Widget.Label({
        className: 'icon accent',
        label: Audio.microphone.bind('is-muted').transform(muted =>
            muted ? '' : ''
        ),
    }),
});

export const AudioControls = () => Widget.Box({
    className: 'audio-controls box horizontal spacing',
    children: [
        VolumeSlider(),
        MicToggle(),
    ],
});
