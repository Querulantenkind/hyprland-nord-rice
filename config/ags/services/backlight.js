// ╔═══════════════════════════════════════════════════════════════════════════╗
// ║                     BACKLIGHT SERVICE - NORD/ICE THEME                    ║
// ╚═══════════════════════════════════════════════════════════════════════════╝

import Service from 'resource:///com/github/Aylur/ags/service.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';

class BacklightService extends Service {
    static instance = null;
    static getInstance() {
        return BacklightService.instance || (BacklightService.instance = new BacklightService());
    }

    static {
        Service.register(this, {
            'screen': [],
        });
    }

    _screen = 0;

    get screen() { return this._screen; }
    set screen(value) {
        if (value < 0) value = 0;
        if (value > 1) value = 1;

        execAsync(`brightnessctl s ${Math.round(value * 100)}%`)
            .then(() => {
                this._screen = value;
                this.emit('changed');
            })
            .catch(err => console.error('Failed to set brightness:', err));
    }

    constructor() {
        super();
        this.#sync();
    }

    #sync() {
        execAsync('brightnessctl g')
            .then(out => {
                const max = exec('brightnessctl m');
                this._screen = parseInt(out) / parseInt(max);
                this.emit('changed');
            })
            .catch(err => console.error('Failed to sync brightness:', err));
    }
}

const service = BacklightService.getInstance();
export default service;
