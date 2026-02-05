# 🐺 LXR-MDT - Client Scripts

```
   ██████╗██╗     ██╗███████╗███╗   ██╗████████╗
  ██╔════╝██║     ██║██╔════╝████╗  ██║╚══██╔══╝
  ██║     ██║     ██║█████╗  ██╔██╗ ██║   ██║   
  ██║     ██║     ██║██╔══╝  ██║╚██╗██║   ██║   
  ╚██████╗███████╗██║███████╗██║ ╚████║   ██║   
   ╚═════╝╚══════╝╚═╝╚══════╝╚═╝  ╚═══╝   ╚═╝   
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 📋 Overview

This folder contains all **client-side Lua scripts** for LXR-MDT.

## Files

- **main.lua** - Core client initialization and MDT opening logic
- **medical.lua** - Medical MDT client-side handlers
- **law.lua** - Law MDT client-side handlers
- **commands.lua** - Client command handlers
- **items.lua** - Item usage handlers (books, journals)
- **targets.lua** - Physical terminal interactions

## Purpose

Client scripts handle:
- UI interaction triggering
- NUI communication
- Local player state
- Event reception from server
- User input collection

**Note:** Client scripts DO NOT handle validation, permissions, or critical logic.  
All important operations are server-side.

---

```
╔═══════════════════════════════════════════════════════════════════════════╗
║                                                                           ║
║   🐺 LXR-MDT Client Layer - UI & Interaction                             ║
║                                                                           ║
║   Built with ❤️ for wolves.land by iBoss21 / The Lux Empire              ║
║                                                                           ║
╚═══════════════════════════════════════════════════════════════════════════╝
```
