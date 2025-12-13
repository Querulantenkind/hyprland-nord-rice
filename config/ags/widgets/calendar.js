// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     CALENDAR WIDGET - NORD/ICE THEME                      ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { Variable } from 'resource:///com/github/Aylur/ags/utils.js';

const WEEKDAYS = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
const MONTHS = [
    'Januar', 'Februar', 'Maerz', 'April', 'Mai', 'Juni',
    'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'
];

// Current displayed month/year
const displayedDate = Variable(new Date());

const getDaysInMonth = (year, month) => {
    return new Date(year, month + 1, 0).getDate();
};

const getFirstDayOfMonth = (year, month) => {
    const day = new Date(year, month, 1).getDay();
    return day === 0 ? 6 : day - 1; // Convert Sunday=0 to Monday=0 based week
};

const isToday = (year, month, day) => {
    const today = new Date();
    return (
        today.getFullYear() === year &&
        today.getMonth() === month &&
        today.getDate() === day
    );
};

const createCalendarGrid = (date) => {
    const year = date.getFullYear();
    const month = date.getMonth();
    const daysInMonth = getDaysInMonth(year, month);
    const firstDay = getFirstDayOfMonth(year, month);
    const daysInPrevMonth = getDaysInMonth(year, month - 1);
    
    const cells = [];
    
    // Previous month days
    for (let i = firstDay - 1; i >= 0; i--) {
        cells.push({
            day: daysInPrevMonth - i,
            isCurrentMonth: false,
            isToday: false,
        });
    }
    
    // Current month days
    for (let day = 1; day <= daysInMonth; day++) {
        cells.push({
            day: day,
            isCurrentMonth: true,
            isToday: isToday(year, month, day),
        });
    }
    
    // Next month days (fill remaining cells to make 6 rows)
    const remaining = 42 - cells.length;
    for (let day = 1; day <= remaining; day++) {
        cells.push({
            day: day,
            isCurrentMonth: false,
            isToday: false,
        });
    }
    
    return cells;
};

const CalendarDay = (cellData) => Widget.Button({
    className: `calendar-day ${cellData.isCurrentMonth ? 'current-month' : 'other-month'} ${cellData.isToday ? 'today' : ''}`,
    child: Widget.Label({
        label: `${cellData.day}`,
    }),
});

const CalendarGrid = () => Widget.Box({
    className: 'calendar-grid',
    vertical: true,
    children: displayedDate.bind().transform(date => {
        const cells = createCalendarGrid(date);
        const rows = [];
        
        for (let i = 0; i < 6; i++) {
            const rowCells = cells.slice(i * 7, (i + 1) * 7);
            rows.push(Widget.Box({
                className: 'calendar-row',
                homogeneous: true,
                children: rowCells.map(cell => CalendarDay(cell)),
            }));
        }
        
        return rows;
    }),
});

const CalendarHeader = () => Widget.Box({
    className: 'calendar-header',
    children: [
        Widget.Button({
            className: 'calendar-nav',
            onClicked: () => {
                const current = displayedDate.value;
                displayedDate.value = new Date(current.getFullYear(), current.getMonth() - 1, 1);
            },
            child: Widget.Label({ label: '󰅁' }),
        }),
        Widget.Label({
            className: 'calendar-title',
            hexpand: true,
            label: displayedDate.bind().transform(date => 
                `${MONTHS[date.getMonth()]} ${date.getFullYear()}`
            ),
        }),
        Widget.Button({
            className: 'calendar-nav',
            onClicked: () => {
                const current = displayedDate.value;
                displayedDate.value = new Date(current.getFullYear(), current.getMonth() + 1, 1);
            },
            child: Widget.Label({ label: '󰅂' }),
        }),
    ],
});

const WeekdayHeader = () => Widget.Box({
    className: 'weekday-header',
    homogeneous: true,
    children: WEEKDAYS.map(day => Widget.Label({
        className: 'weekday',
        label: day,
    })),
});

// Time display widget
export const TimeWidget = () => {
    const time = Variable('', {
        poll: [1000, () => {
            const now = new Date();
            return now.toLocaleTimeString('de-DE', { 
                hour: '2-digit', 
                minute: '2-digit',
            });
        }],
    });
    
    const date = Variable('', {
        poll: [60000, () => {
            const now = new Date();
            return now.toLocaleDateString('de-DE', { 
                weekday: 'long',
                day: 'numeric', 
                month: 'long',
            });
        }],
    });

    return Widget.Box({
        className: 'time-widget',
        vertical: true,
        children: [
            Widget.Label({
                className: 'time-display',
                label: time.bind(),
            }),
            Widget.Label({
                className: 'date-display',
                label: date.bind(),
            }),
        ],
    });
};

// Full calendar widget
export const CalendarWidget = () => Widget.Box({
    className: 'calendar-widget',
    vertical: true,
    children: [
        CalendarHeader(),
        WeekdayHeader(),
        CalendarGrid(),
        Widget.Button({
            className: 'calendar-today-btn',
            onClicked: () => {
                displayedDate.value = new Date();
            },
            child: Widget.Label({ label: '󰃭 Heute' }),
        }),
    ],
});

// Compact calendar header for dashboard
export const CalendarCompact = () => {
    const dateInfo = Variable({}, {
        poll: [60000, () => {
            const now = new Date();
            return {
                day: now.getDate(),
                weekday: now.toLocaleDateString('de-DE', { weekday: 'short' }),
                month: MONTHS[now.getMonth()],
            };
        }],
    });

    return Widget.Box({
        className: 'calendar-compact',
        children: [
            Widget.Box({
                className: 'calendar-compact-day',
                vertical: true,
                children: [
                    Widget.Label({
                        className: 'compact-weekday',
                        label: dateInfo.bind().transform(d => d.weekday || ''),
                    }),
                    Widget.Label({
                        className: 'compact-day-number',
                        label: dateInfo.bind().transform(d => `${d.day || ''}`),
                    }),
                ],
            }),
            Widget.Label({
                className: 'compact-month',
                label: dateInfo.bind().transform(d => d.month || ''),
            }),
        ],
    });
};

export default CalendarWidget;

