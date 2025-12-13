// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     WEATHER WIDGET - NORD/ICE THEME                       ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Variable, exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

// Weather icons mapping (Nerd Fonts)
const getWeatherIcon = (condition) => {
    const conditionLower = condition?.toLowerCase() || '';
    
    if (conditionLower.includes('sunny') || conditionLower.includes('clear')) return '󰖙';
    if (conditionLower.includes('partly cloudy')) return '󰖕';
    if (conditionLower.includes('cloudy') || conditionLower.includes('overcast')) return '󰖐';
    if (conditionLower.includes('rain') || conditionLower.includes('drizzle')) return '󰖗';
    if (conditionLower.includes('snow')) return '󰖘';
    if (conditionLower.includes('thunder') || conditionLower.includes('storm')) return '󰖓';
    if (conditionLower.includes('fog') || conditionLower.includes('mist')) return '󰖑';
    if (conditionLower.includes('wind')) return '󰖝';
    return '󰖐';
};

// Weather data variable with polling
const weatherData = Variable({
    temp: '--',
    condition: 'Laden...',
    humidity: '--',
    wind: '--',
    feelsLike: '--',
    location: '',
    icon: '󰖐',
}, {
    poll: [600000, async () => { // Update every 10 minutes
        try {
            const response = await execAsync('curl -s "https://wttr.in/?format=%C|%t|%f|%h|%w|%l"');
            const parts = response.split('|');
            
            if (parts.length >= 6) {
                const condition = parts[0].trim();
                return {
                    condition: condition,
                    temp: parts[1].replace('+', '').trim(),
                    feelsLike: parts[2].replace('+', '').trim(),
                    humidity: parts[3].trim(),
                    wind: parts[4].trim(),
                    location: parts[5].trim(),
                    icon: getWeatherIcon(condition),
                };
            }
        } catch (e) {
            console.error('Weather fetch error:', e);
        }
        return {
            temp: '--',
            condition: 'Offline',
            humidity: '--',
            wind: '--',
            feelsLike: '--',
            location: '',
            icon: '󰖐',
        };
    }],
});

// Compact weather for dashboard header
export const WeatherCompact = () => Widget.Box({
    className: 'weather-compact',
    children: [
        Widget.Label({
            className: 'weather-icon-large',
            label: weatherData.bind().transform(w => w.icon),
        }),
        Widget.Box({
            vertical: true,
            className: 'weather-info',
            children: [
                Widget.Label({
                    className: 'weather-temp',
                    label: weatherData.bind().transform(w => w.temp),
                }),
                Widget.Label({
                    className: 'weather-condition',
                    label: weatherData.bind().transform(w => w.condition),
                }),
            ],
        }),
    ],
});

// Full weather widget with all details
export const WeatherWidget = () => Widget.Box({
    className: 'weather-widget',
    vertical: true,
    children: [
        // Main weather display
        Widget.Box({
            className: 'weather-main',
            children: [
                Widget.Label({
                    className: 'weather-icon-xlarge',
                    label: weatherData.bind().transform(w => w.icon),
                }),
                Widget.Box({
                    vertical: true,
                    className: 'weather-primary',
                    children: [
                        Widget.Label({
                            className: 'weather-temp-large',
                            label: weatherData.bind().transform(w => w.temp),
                        }),
                        Widget.Label({
                            className: 'weather-condition-main',
                            label: weatherData.bind().transform(w => w.condition),
                        }),
                        Widget.Label({
                            className: 'weather-location',
                            label: weatherData.bind().transform(w => w.location || 'Standort ermitteln...'),
                        }),
                    ],
                }),
            ],
        }),
        
        // Weather details grid
        Widget.Box({
            className: 'weather-details',
            homogeneous: true,
            children: [
                Widget.Box({
                    className: 'weather-detail-item',
                    vertical: true,
                    children: [
                        Widget.Label({
                            className: 'detail-icon',
                            label: '󰔏',
                        }),
                        Widget.Label({
                            className: 'detail-value',
                            label: weatherData.bind().transform(w => w.feelsLike),
                        }),
                        Widget.Label({
                            className: 'detail-label',
                            label: 'Gefuehlt',
                        }),
                    ],
                }),
                Widget.Box({
                    className: 'weather-detail-item',
                    vertical: true,
                    children: [
                        Widget.Label({
                            className: 'detail-icon',
                            label: '󰖎',
                        }),
                        Widget.Label({
                            className: 'detail-value',
                            label: weatherData.bind().transform(w => w.humidity),
                        }),
                        Widget.Label({
                            className: 'detail-label',
                            label: 'Feuchtigkeit',
                        }),
                    ],
                }),
                Widget.Box({
                    className: 'weather-detail-item',
                    vertical: true,
                    children: [
                        Widget.Label({
                            className: 'detail-icon',
                            label: '󰖝',
                        }),
                        Widget.Label({
                            className: 'detail-value',
                            label: weatherData.bind().transform(w => w.wind),
                        }),
                        Widget.Label({
                            className: 'detail-label',
                            label: 'Wind',
                        }),
                    ],
                }),
            ],
        }),
        
        // Refresh button
        Widget.Button({
            className: 'weather-refresh',
            onClicked: () => weatherData.poll(),
            child: Widget.Label({
                label: '󰑓 Aktualisieren',
            }),
        }),
    ],
});

export default WeatherWidget;

