# lua-calibration-module

> Industrial calibration framework in Lua for embedded testing equipment.
> Handles sensor calibration, dead-time compensation, and configuration-driven
> test workflows on resource-constrained devices.

---

## 🎯 What This Is

A modular Lua framework used in industrial testing equipment for:

- **Sensor calibration** — linearization, offset/gain compensation
- **Dead-time compensation** — for thermal and electrical response lag
- **Configuration-driven workflows** — define test sequences declaratively
- **Hardware abstraction** — clean interface layer over instruments

This is part of the calibration toolkit used at CYGIA (Changyuan Group) for
battery testing and industrial automation equipment.

---

## 📁 Project Structure

```
lua_calibration_module/
├── calibration.lua       # Core calibration algorithms
├── run.lua                # Main test runner
├── run_dead_time.lua      # Dead-time compensation routines
├── common.lua             # Shared utilities
├── config.lua             # Global configuration
├── interface.lua          # Hardware interface abstraction
├── interface/             # Protocol-specific implementations
├── cal_config/            # Calibration configuration files
├── test/                  # Test cases
└── ...
```

---

## 🛠️ Tech Stack

- **Lua 5.x** — embedded scripting for industrial devices
- **C-bindings** (where required) for hardware I/O
- **Configuration-driven** — workflows defined in declarative config files

---

## 🏭 Why Lua?

In industrial testing equipment, Lua is commonly used because:

- ✅ **Tiny footprint** — runs on embedded controllers with limited RAM
- ✅ **Real-time friendly** — deterministic GC behavior, fast startup
- ✅ **Hot-reloadable** — calibration logic updates without firmware reflash
- ✅ **C-extensible** — direct access to hardware registers when needed

---

## 👤 Author

**Howie** — Founder @ Yaocheng Software · Former Director of Software R&D @ CYGIA

- 🚀 Currently building industrial software + AI agent systems at Yaocheng Software
- 🏭 10+ years building industrial automation & testing systems
- ⚙️ Hardware-software integration specialist
- 💼 [GitHub Profile](https://github.com/hongweiduan)

---

## 📜 License

Proprietary — code shared for reference. Contact author for licensing inquiries.
