# 🐺 LXR-MDT - Medical & Law Database Terminal System

```
  ███████╗██╗  ██╗███╗   ███╗ █████╗ ███╗   ██╗██╗███████╗███████╗███████╗████████╗
  ██╔════╝╚██╗██╔╝████╗ ████║██╔══██╗████╗  ██║██║██╔════╝██╔════╝██╔════╝╚══██╔══╝
  █████╗   ╚███╔╝ ██╔████╔██║███████║██╔██╗ ██║██║█████╗  █████╗  ███████╗   ██║   
  ██╔══╝   ██╔██╗ ██║╚██╔╝██║██╔══██║██║╚██╗██║██║██╔══╝  ██╔══╝  ╚════██║   ██║   
  ██║     ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║██║ ╚████║██║██║     ███████╗███████║   ██║   
  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   
```

**🐺 The Land of Wolves** | Georgian RP | მგლების მიწა  
**ისტორია ცოცხლდება აქ!** - *History Lives Here!*

---

## 📋 Overview

**LXR-MDT** is a production-grade, role-based Mobile Data Terminal system for **RedM 1899 Era Roleplay**. Built exclusively for **wolves.land** community, this system provides immersive database management for **Medical Professionals** and **Law Enforcement**.

This is not a toy UI. This is a **persistent world database** where:
- 🏥 **Doctors record life**
- ⭐ **Law records sin**
- 🗂️ **The server remembers everything**

---

## 🎯 Key Features

### 🏥 Medical MDT
- **Patient Search & Records** - Complete medical history database
- **Treatment Logging** - Track all treatments, surgeries, and procedures
- **Prescription System** - Issue and track prescriptions
- **Death Certificates** - Official death records with cause and investigation
- **Medical Reports** - Gunshot reports, autopsy reports, insanity reports
- **Supply Tracking** - Hospital inventory management

### ⭐ Law Enforcement MDT
- **Citizen/Criminal Search** - Complete criminal history database
- **Warrant System** - Arrest, search, execution, and bounty warrants
- **Arrest Reports** - Detailed arrest records with evidence
- **Evidence Locker** - Physical and digital evidence tracking
- **Jail & Sentence Tracking** - Complete incarceration history
- **Bounty Board** - Active bounty management
- **BOLO System** - Be On the Lookout alerts

### 🔒 Security & Performance
- **Server-Authority Model** - All validation server-side
- **Zero-Tick Architecture** - No idle threads, event-driven only
- **Anti-Abuse System** - Cooldowns, rate limiting, distance checks
- **Permission System** - Grade-based access control
- **Action Logging** - Complete audit trail
- **Discord Integration** - Optional webhook logging

### 🎨 Framework Support
- ✅ **LXR-Core** (Primary - Full Support)
- ✅ **RSG-Core** (Primary - Full Support)
- ✅ **VORP Core** (Supported - Legacy Compatible)
- ✅ **Standalone** (Auto-fallback)

---

## 📂 Repository Structure

```
lxr-mdt/
├── client/              # Client-side scripts
│   ├── main.lua         # Core client initialization
│   ├── medical.lua      # Medical MDT client
│   ├── law.lua          # Law MDT client
│   ├── commands.lua     # Command handlers
│   ├── items.lua        # Item usage handlers
│   └── targets.lua      # Target/prompt interactions
├── server/              # Server-side scripts
│   ├── main.lua         # Core server initialization
│   ├── medical.lua      # Medical MDT server
│   ├── law.lua          # Law MDT server
│   ├── database.lua     # Database operations
│   ├── security.lua     # Security & validation
│   ├── commands.lua     # Server command handlers
│   └── version.lua      # Version checker
├── shared/              # Shared scripts
│   ├── bridge.lua       # Framework adapter layer
│   └── utils.lua        # Utility functions
├── html/                # NUI Interface
│   ├── index.html       # Main UI structure
│   ├── css/             # Stylesheets (1899 immersive design)
│   ├── js/              # JavaScript logic
│   ├── img/             # Images and assets
│   └── sounds/          # Sound effects
├── sql/                 # Database schema
│   └── install.sql      # Installation script
├── docs/                # Documentation
│   ├── overview.md
│   ├── installation.md
│   ├── configuration.md
│   ├── frameworks.md
│   ├── events.md
│   ├── security.md
│   ├── performance.md
│   └── screenshots.md
├── config.lua           # Configuration file
├── fxmanifest.lua       # Resource manifest
├── LICENSE              # License file
└── README.md            # This file
```

---

## 🚀 Quick Start

### Prerequisites
- RedM Server (latest prerelease)
- MySQL/MariaDB database
- oxmysql resource
- One of: LXR-Core, RSG-Core, or VORP Core

### Installation

1. **Download and Extract**
   ```bash
   cd resources
   git clone https://github.com/iBoss21/lxr-mdt.git
   ```

2. **Database Setup**
   - Import `sql/install.sql` into your database
   - Creates all required tables with `mdt_` prefix

3. **Configure**
   - Edit `config.lua`
   - Set your server info, jobs, permissions
   - Configure framework (auto-detect recommended)

4. **Start Resource**
   ```
   ensure lxr-mdt
   ```

5. **Verify**
   - Check console for successful initialization
   - Framework should be auto-detected
   - Test with `/mdt` command

---

## 📖 Documentation

Full documentation is available in the `/docs` folder:

- **[Installation Guide](docs/installation.md)** - Step-by-step setup
- **[Configuration](docs/configuration.md)** - All config options explained
- **[Framework Support](docs/frameworks.md)** - Multi-framework architecture
- **[Events & Callbacks](docs/events.md)** - API reference
- **[Security](docs/security.md)** - Security model and best practices
- **[Performance](docs/performance.md)** - Optimization guide

---

## 🎮 Usage

### Commands
- `/mdt` - Open MDT (auto-detects your role)
- `/medmdt` - Open Medical MDT
- `/lawmdt` - Open Law MDT

### Access Methods
- **Command** - Type `/mdt` in chat
- **Items** - Use doctor_book, law_book, etc.
- **Terminals** - Interact with physical terminals (configurable locations)
- **Keybind** - Optional keybind (disabled by default)

---

## 🛡️ Security

LXR-MDT implements **server-authority security**:

- ✅ All actions validated server-side
- ✅ Job and permission checks
- ✅ Cooldown system prevents spam
- ✅ Rate limiting on queries
- ✅ Distance checks for terminals
- ✅ SQL injection protection
- ✅ Input sanitization
- ✅ Action logging and audit trail

**Never trust the client.** All critical operations happen server-side.

---

## ⚡ Performance

**Target:** `<0.03ms idle | 0.00ms resmon`

- ✅ **Zero-Tick Architecture** - No idle threads
- ✅ **Event-Driven** - Responds only when needed
- ✅ **Caching System** - In-memory player data cache
- ✅ **Batch Operations** - Efficient database inserts
- ✅ **Optimized Queries** - Indexed database tables

---

## 🎨 Design Philosophy

LXR-MDT follows the **wolves.land production standards**:

1. **Immersive 1899 Design** - Leather, paper, ink aesthetics
2. **Server-Authority Model** - Client never trusted
3. **Multi-Framework Support** - Works with LXR/RSG/VORP
4. **Production-Grade Code** - Enterprise-level architecture
5. **Complete Documentation** - Every feature documented
6. **Security First** - Anti-abuse built-in
7. **Performance Optimized** - Zero wasted resources

---

## 🤝 Support

### Server Information
- **Website:** [wolves.land](https://www.wolves.land)
- **Discord:** [Join Our Community](https://discord.gg/CrKcWdfd3A)
- **Store:** [The Lux Empire Tebex](https://theluxempire.tebex.io)
- **Server Listing:** [RedM Servers](https://servers.redm.net/servers/detail/8gj7eb)

### Developer
- **Author:** iBoss21
- **GitHub:** [@iBoss21](https://github.com/iBoss21)
- **Organization:** The Lux Empire

---

## 📜 License

© 2026 iBoss21 / The Lux Empire. All Rights Reserved.  
**Proprietary License** - wolves.land Exclusive

This resource is proprietary software developed for wolves.land community.

---

## 🏷️ Tags

`#RedM` `#MDT` `#Medical` `#Law` `#Database` `#Roleplay` `#1899` `#Western`  
`#LXR-Core` `#RSG-Core` `#VORP` `#Multi-Framework` `#Production-Ready`

---

## 🐺 About wolves.land

**The Land of Wolves** is a serious hardcore roleplay community for RedM, focused on Georgian culture and immersive 1899 Western gameplay.

- 🇬🇪 **Georgian RP** - მგლების მიწა (The Land of Wolves)
- 🎭 **Serious Roleplay** - Whitelist required
- 🌟 **Quality Standards** - Production-grade resources only
- 🔐 **Discord Integrated** - Active community

**ისტორია ცოცხლდება აქ!** - *History Lives Here!*

---

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🐺 LXR-MDT - Where Doctors Record Life and Law Records Sin             ║
║                                                                           ║
║   Built with ❤️ for wolves.land by iBoss21 / The Lux Empire              ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```
