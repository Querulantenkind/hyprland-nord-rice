// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     MUSIC WIDGET - NORD/ICE THEME                         ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import { Variable } from 'resource:///com/github/Aylur/ags/utils.js';

const FALLBACK_ICON = '󰎆';
const PLAYER_ICONS = {
    'spotify': '󰓇',
    'firefox': '󰈹',
    'chromium': '',
    'vlc': '󰕼',
    'mpv': '',
    'rhythmbox': '󰓃',
    'default': '󰎆',
};

const getPlayerIcon = (playerName) => {
    const name = playerName?.toLowerCase() || '';
    for (const [key, icon] of Object.entries(PLAYER_ICONS)) {
        if (name.includes(key)) return icon;
    }
    return PLAYER_ICONS.default;
};

const formatTime = (seconds) => {
    if (!seconds || seconds < 0) return '0:00';
    const mins = Math.floor(seconds / 60);
    const secs = Math.floor(seconds % 60);
    return `${mins}:${secs.toString().padStart(2, '0')}`;
};

const getPlayer = () => Mpris.players[0] || null;

// Playback progress variable
const progress = Variable(0, {
    poll: [1000, () => {
        const player = getPlayer();
        if (!player) return 0;
        return player.position / player.length || 0;
    }],
});

// Mini music player for compact views
export const MusicCompact = () => Widget.Box({
    className: 'music-compact',
    visible: Mpris.bind('players').transform(p => p.length > 0),
    children: [
        Widget.Label({
            className: 'music-icon',
            label: Mpris.bind('players').transform(players => 
                players[0] ? getPlayerIcon(players[0].name) : FALLBACK_ICON
            ),
        }),
        Widget.Label({
            className: 'music-title-compact',
            truncate: 'end',
            maxWidthChars: 20,
            label: Mpris.bind('players').transform(players => {
                const player = players[0];
                if (!player) return 'Keine Wiedergabe';
                return player.trackTitle || 'Unbekannt';
            }),
        }),
    ],
});

// Full music player widget
export const MusicWidget = () => Widget.Box({
    className: 'music-widget',
    visible: Mpris.bind('players').transform(p => p.length > 0),
    vertical: true,
    children: [
        // Album art and info
        Widget.Box({
            className: 'music-info-row',
            children: [
                Widget.Box({
                    className: 'music-album-art',
                    css: Mpris.bind('players').transform(players => {
                        const player = players[0];
                        if (!player?.coverPath) {
                            return 'background: linear-gradient(135deg, #4c566a, #3b4252);';
                        }
                        return `background-image: url("${player.coverPath}"); background-size: cover; background-position: center;`;
                    }),
                    child: Widget.Label({
                        className: 'music-album-icon',
                        visible: Mpris.bind('players').transform(p => !p[0]?.coverPath),
                        label: '󰎆',
                    }),
                }),
                Widget.Box({
                    vertical: true,
                    className: 'music-text-info',
                    children: [
                        Widget.Label({
                            className: 'music-title',
                            xalign: 0,
                            truncate: 'end',
                            maxWidthChars: 25,
                            label: Mpris.bind('players').transform(p => 
                                p[0]?.trackTitle || 'Keine Wiedergabe'
                            ),
                        }),
                        Widget.Label({
                            className: 'music-artist',
                            xalign: 0,
                            truncate: 'end',
                            maxWidthChars: 25,
                            label: Mpris.bind('players').transform(p => 
                                p[0]?.trackArtists?.join(', ') || 'Unbekannter Kuenstler'
                            ),
                        }),
                        Widget.Label({
                            className: 'music-album',
                            xalign: 0,
                            truncate: 'end',
                            maxWidthChars: 25,
                            label: Mpris.bind('players').transform(p => 
                                p[0]?.trackAlbum || ''
                            ),
                        }),
                    ],
                }),
            ],
        }),
        
        // Progress bar
        Widget.Box({
            className: 'music-progress-container',
            vertical: true,
            children: [
                Widget.Slider({
                    className: 'music-progress',
                    drawValue: false,
                    value: progress.bind(),
                    onChange: ({ value }) => {
                        const player = getPlayer();
                        if (player) {
                            player.position = value * player.length;
                        }
                    },
                }),
                Widget.Box({
                    className: 'music-time',
                    children: [
                        Widget.Label({
                            className: 'music-time-current',
                            label: Mpris.bind('players').transform(players => {
                                const player = players[0];
                                return formatTime(player?.position);
                            }),
                        }),
                        Widget.Box({ hexpand: true }),
                        Widget.Label({
                            className: 'music-time-total',
                            label: Mpris.bind('players').transform(players => {
                                const player = players[0];
                                return formatTime(player?.length);
                            }),
                        }),
                    ],
                }),
            ],
        }),
        
        // Controls
        Widget.Box({
            className: 'music-controls',
            homogeneous: true,
            children: [
                Widget.Button({
                    className: 'music-btn shuffle',
                    onClicked: () => {
                        const player = getPlayer();
                        if (player) player.shuffle();
                    },
                    child: Widget.Label({
                        label: Mpris.bind('players').transform(p => 
                            p[0]?.shuffleStatus ? '󰒟' : '󰒞'
                        ),
                    }),
                }),
                Widget.Button({
                    className: 'music-btn prev',
                    onClicked: () => {
                        const player = getPlayer();
                        if (player) player.previous();
                    },
                    child: Widget.Label({ label: '󰒮' }),
                }),
                Widget.Button({
                    className: 'music-btn play-pause',
                    onClicked: () => {
                        const player = getPlayer();
                        if (player) player.playPause();
                    },
                    child: Widget.Label({
                        label: Mpris.bind('players').transform(players => {
                            const player = players[0];
                            return player?.playBackStatus === 'Playing' ? '󰏤' : '󰐊';
                        }),
                    }),
                }),
                Widget.Button({
                    className: 'music-btn next',
                    onClicked: () => {
                        const player = getPlayer();
                        if (player) player.next();
                    },
                    child: Widget.Label({ label: '󰒭' }),
                }),
                Widget.Button({
                    className: 'music-btn loop',
                    onClicked: () => {
                        const player = getPlayer();
                        if (player) player.loop();
                    },
                    child: Widget.Label({
                        label: Mpris.bind('players').transform(p => {
                            const status = p[0]?.loopStatus;
                            if (status === 'Track') return '󰑘';
                            if (status === 'Playlist') return '󰑖';
                            return '󰑗';
                        }),
                    }),
                }),
            ],
        }),
        
        // Player name
        Widget.Label({
            className: 'music-player-name',
            label: Mpris.bind('players').transform(players => {
                const player = players[0];
                if (!player) return '';
                const icon = getPlayerIcon(player.name);
                return `${icon} ${player.name}`;
            }),
        }),
    ],
});

// No media placeholder
export const NoMediaWidget = () => Widget.Box({
    className: 'no-media-widget',
    vertical: true,
    visible: Mpris.bind('players').transform(p => p.length === 0),
    children: [
        Widget.Label({
            className: 'no-media-icon',
            label: '󰎊',
        }),
        Widget.Label({
            className: 'no-media-text',
            label: 'Keine Medienwiedergabe',
        }),
        Widget.Label({
            className: 'no-media-hint',
            label: 'Starte Musik in Spotify, Firefox, etc.',
        }),
    ],
});

// Combined music section (shows widget or placeholder)
export const MusicSection = () => Widget.Box({
    className: 'music-section',
    vertical: true,
    children: [
        Widget.Label({
            className: 'section-title',
            xalign: 0,
            label: '󰎆 Medien',
        }),
        Widget.Stack({
            transition: 'slide_left_right',
            transitionDuration: 200,
            shown: Mpris.bind('players').transform(p => 
                p.length > 0 ? 'music' : 'no-media'
            ),
            children: {
                'music': MusicWidget(),
                'no-media': NoMediaWidget(),
            },
        }),
    ],
});

export default MusicWidget;

