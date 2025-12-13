// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     APP LAUNCHER WIDGET - NORD/ICE THEME                  ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import Applications from 'resource:///com/github/Aylur/ags/service/applications.js';
import { Variable, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

const MAX_RESULTS = 20;
const FAVORITES = [
    'firefox',
    'kitty', 
    'thunar',
    'code',
    'spotify',
    'discord',
    'steam',
    'obs',
];

// Search query variable
const searchQuery = Variable('');

// Get app icon or fallback
const getAppIcon = (app) => {
    const iconName = app.iconName;
    if (iconName) return iconName;
    return 'application-x-executable';
};

// Application item widget
const AppItem = (app, closeDashboard) => Widget.Button({
    className: 'app-item',
    onClicked: () => {
        app.launch();
        closeDashboard?.();
    },
    child: Widget.Box({
        vertical: true,
        children: [
            Widget.Icon({
                className: 'app-icon',
                icon: getAppIcon(app),
                size: 48,
            }),
            Widget.Label({
                className: 'app-name',
                label: app.name,
                truncate: 'end',
                maxWidthChars: 12,
            }),
        ],
    }),
    tooltipText: app.description || app.name,
});

// Favorites section
export const FavoriteApps = (closeDashboard) => {
    const favoriteApps = FAVORITES
        .map(name => Applications.list.find(app => 
            app.name?.toLowerCase().includes(name) ||
            app.desktop?.toLowerCase().includes(name)
        ))
        .filter(Boolean);

    return Widget.Box({
        className: 'favorite-apps',
        children: favoriteApps.map(app => AppItem(app, closeDashboard)),
    });
};

// Search results
const SearchResults = (closeDashboard) => Widget.Box({
    className: 'search-results',
    vertical: true,
    visible: searchQuery.bind().transform(q => q.length > 0),
    children: [
        Widget.Scrollable({
            className: 'search-scroll',
            vexpand: true,
            hscroll: 'never',
            vscroll: 'automatic',
            child: Widget.FlowBox({
                className: 'search-grid',
                homogeneous: true,
                minChildrenPerLine: 4,
                maxChildrenPerLine: 8,
                selectionMode: 'none',
                setup: self => {
                    searchQuery.connect('changed', () => {
                        const query = searchQuery.value.toLowerCase();
                        self.get_children().forEach(c => c.destroy());
                        
                        if (query.length === 0) return;
                        
                        const results = Applications.list
                            .filter(app => {
                                const name = app.name?.toLowerCase() || '';
                                const desc = app.description?.toLowerCase() || '';
                                const desktop = app.desktop?.toLowerCase() || '';
                                return name.includes(query) || 
                                       desc.includes(query) || 
                                       desktop.includes(query);
                            })
                            .slice(0, MAX_RESULTS);
                        
                        results.forEach(app => {
                            self.add(AppItem(app, closeDashboard));
                        });
                        
                        self.show_all();
                    });
                },
            }),
        }),
    ],
});

// All apps grid
const AllApps = (closeDashboard) => Widget.Scrollable({
    className: 'all-apps-scroll',
    vexpand: true,
    hscroll: 'never',
    vscroll: 'automatic',
    visible: searchQuery.bind().transform(q => q.length === 0),
    child: Widget.FlowBox({
        className: 'all-apps-grid',
        homogeneous: true,
        minChildrenPerLine: 6,
        maxChildrenPerLine: 10,
        selectionMode: 'none',
        setup: self => {
            Applications.list
                .sort((a, b) => a.name?.localeCompare(b.name || '') || 0)
                .forEach(app => {
                    self.add(AppItem(app, closeDashboard));
                });
        },
    }),
});

// Search entry
const SearchEntry = () => Widget.Entry({
    className: 'app-search',
    placeholderText: '  Apps durchsuchen...',
    hexpand: true,
    onAccept: () => {
        const query = searchQuery.value.toLowerCase();
        if (query.length === 0) return;
        
        const app = Applications.list.find(a => 
            a.name?.toLowerCase().includes(query)
        );
        if (app) app.launch();
    },
    onChange: ({ text }) => {
        searchQuery.value = text || '';
    },
    setup: self => {
        // Focus on show
        self.grab_focus();
    },
});

// Quick launch buttons
const QuickLaunchButton = (icon, command, tooltip) => Widget.Button({
    className: 'quick-launch-btn',
    onClicked: () => execAsync(['bash', '-c', command]),
    child: Widget.Label({
        className: 'quick-launch-icon',
        label: icon,
    }),
    tooltipText: tooltip,
});

const QuickLaunch = () => Widget.Box({
    className: 'quick-launch',
    children: [
        QuickLaunchButton('', 'thunar', 'Dateien'),
        QuickLaunchButton('', 'firefox', 'Browser'),
        QuickLaunchButton('', 'kitty', 'Terminal'),
        QuickLaunchButton('󰨞', 'code', 'VS Code'),
        QuickLaunchButton('󰓇', 'spotify', 'Spotify'),
        QuickLaunchButton('󰙯', 'discord', 'Discord'),
        QuickLaunchButton('', 'steam', 'Steam'),
        QuickLaunchButton('', 'pavucontrol', 'Audio'),
    ],
});

// Full app launcher widget
export const AppLauncher = (closeDashboard) => Widget.Box({
    className: 'app-launcher',
    vertical: true,
    children: [
        // Search bar
        Widget.Box({
            className: 'app-search-container',
            children: [
                Widget.Label({
                    className: 'search-icon',
                    label: '',
                }),
                SearchEntry(),
                Widget.Button({
                    className: 'search-clear',
                    visible: searchQuery.bind().transform(q => q.length > 0),
                    onClicked: () => {
                        searchQuery.value = '';
                    },
                    child: Widget.Label({ label: '󰅖' }),
                }),
            ],
        }),
        
        // Quick launch
        QuickLaunch(),
        
        // Results or all apps
        Widget.Box({
            className: 'apps-container',
            vexpand: true,
            child: Widget.Stack({
                transition: 'crossfade',
                transitionDuration: 150,
                shown: searchQuery.bind().transform(q => 
                    q.length > 0 ? 'search' : 'all'
                ),
                children: {
                    'search': SearchResults(closeDashboard),
                    'all': AllApps(closeDashboard),
                },
            }),
        }),
    ],
});

// Reset search when dashboard closes
export const resetSearch = () => {
    searchQuery.value = '';
};

export default AppLauncher;

