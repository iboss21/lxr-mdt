# 🐺 LXR-MDT - System Overview

```
  ███████╗██╗  ██╗███╗   ███╗ █████╗ ███╗   ██╗██╗███████╗███████╗███████╗████████╗
  ██╔════╝╚██╗██╔╝████╗ ████║██╔══██╗████╗  ██║██║██╔════╝██╔════╝██╔════╝╚══██╔══╝
  █████╗   ╚███╔╝ ██╔████╔██║███████║██╔██╗ ██║██║█████╗  █████╗  ███████╗   ██║   
  ██╔══╝   ██╔██╗ ██║╚██╔╝██║██╔══██║██║╚██╗██║██║██╔══╝  ██╔══╝  ╚════██║   ██║   
  ██║     ██╔╝ ██╗██║ ╚═╝ ██║██║  ██║██║ ╚████║██║██║     ███████╗███████║   ██║   
  ╚═╝     ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚═╝╚═╝     ╚══════╝╚══════╝   ╚═╝   
```

**🐺 wolves.land Production Resource**  
**ისტორია ცოცხლდება აქ!** - *History Lives Here!*  
© 2026 iBoss21 / The Lux Empire

---

## 📋 What is LXR-MDT?

**LXR-MDT** (Mobile Data Terminal) is a production-grade, **role-based database management system** for RedM 1899 Era Roleplay servers. Built exclusively for **wolves.land**, this system provides immersive and persistent record-keeping for two critical gameplay pillars:

### 🏥 Medical Professionals
- Track patient histories, treatments, and outcomes
- Issue prescriptions and manage pharmacy records
- Record deaths and issue death certificates
- Manage medical investigations (gunshots, autopsies, mental health)
- Track hospital supplies and inventory

### ⭐ Law Enforcement
- Manage criminal records and arrest history
- Issue and track warrants (arrest, search, execution, bounty)
- Evidence locker management
- Track jail sentences and incarceration history
- BOLO (Be On the Lookout) system
- Bounty board management

---

## 🎯 Core Philosophy

This is **NOT** a toy UI or simple menu system. This is a **persistent world database** where:

- 🏥 **Doctors record life** - Every medical interaction is documented
- ⭐ **Law records sin** - Every crime, every arrest, every warrant
- 🗂️ **The server remembers everything** - Complete audit trail
- 📜 **History matters** - Past actions have consequences
- 🔒 **Server authority** - All validation happens server-side
- ⚡ **Zero overhead** - No wasted performance

---

## 🏗️ Architecture Overview

### Multi-Framework Bridge System

LXR-MDT uses a **unified adapter/bridge pattern** that abstracts framework-specific calls:

```
┌─────────────────────────────────────────────────┐
│           Client/Server Game Logic              │
│     (Uses only Bridge.* unified functions)      │
└─────────────────────────────────────────────────┘
                       ↓
┌─────────────────────────────────────────────────┐
│         Bridge Layer (shared/bridge.lua)        │
│    Auto-detects framework and maps calls        │
└─────────────────────────────────────────────────┘
                       ↓
┌──────────┬──────────┬──────────┬───────────────┐
│ LXR-Core │ RSG-Core │   VORP   │  Standalone   │
│ Primary  │ Primary  │ Supported│   Fallback    │
└──────────┴──────────┴──────────┴───────────────┘
```

### Three-Layer Architecture

1. **Client Layer** (`client/*.lua`)
   - UI interactions
   - User input validation
   - Display logic
   - Target/prompt systems

2. **Shared Bridge** (`shared/bridge.lua`)
   - Framework auto-detection
   - Unified API abstraction
   - Event routing
   - Utility functions

3. **Server Authority** (`server/*.lua`)
   - All validation happens here
   - Database operations
   - Permission checks
   - Anti-abuse systems
   - Action logging

---

## 🔒 Security Model

**Never Trust The Client** - Core Principle

Every action flows through server-side validation:

```
Client Request → Server Validation → Permission Check → 
  Database Query → Security Audit → Response
```

Security features:
- ✅ Job and grade verification
- ✅ Distance validation for terminals
- ✅ Cooldown and rate limiting
- ✅ SQL injection protection
- ✅ Input sanitization
- ✅ Action audit logging
- ✅ Discord webhook integration (optional)

---

## ⚡ Performance Architecture

**Target:** `<0.03ms idle | 0.00ms resmon`

### Zero-Tick Design

No threads running when idle:
- Event-driven architecture
- No loops checking conditions
- Resources activate only when used
- Instant response when needed

### Optimization Strategies

1. **In-Memory Caching**
   - Player data cached after framework load
   - Reduces repeated database queries
   - Auto-cleanup of stale cache

2. **Efficient Database**
   - Indexed tables for fast queries
   - Prepared statements prevent injection
   - Batch operations where possible

3. **Smart UI**
   - NUI only active when needed
   - Lazy loading of data
   - Pagination for large datasets

---

## 📊 Database Structure

### Tables Schema

LXR-MDT uses a **prefixed table system** (`mdt_*`):

```
mdt_players              - Player profiles
mdt_medical_records      - Medical history
mdt_prescriptions        - Prescription records
mdt_death_certificates   - Death records
mdt_criminal_records     - Criminal history
mdt_arrest_reports       - Arrest documentation
mdt_warrants             - Active/historical warrants
mdt_evidence             - Evidence locker
mdt_jail_records         - Incarceration history
mdt_bounties             - Bounty board
mdt_bolos                - BOLO alerts
mdt_action_logs          - Audit trail
```

### Data Persistence

- All records are **permanent** (unless manually deleted by admin)
- Complete audit trail with timestamps and actor tracking
- Cross-reference between medical and law records
- Historical data accessible for investigations

---

## 🎨 User Interface

### 1899 Immersive Design

The UI follows a **leather, paper, and ink** aesthetic:

- Aged paper textures
- Handwritten font styles
- Ink stain effects
- Leather binding visuals
- Compass and map elements
- Sepia tones and warm colors

### Responsive Design

- Clean, readable typography
- Organized sections with clear navigation
- Search and filter capabilities
- Pagination for large datasets
- Keyboard shortcuts
- Smooth transitions

---

## 🔌 Integration Points

### Framework Integration
- Player job system
- Permission/grade system
- Notification system
- Inventory system (for items)
- Database layer (oxmysql)

### Optional Integrations
- Discord webhooks (action logging)
- Target systems (rsg-target, ox_target)
- Progress bars (for search/write actions)
- Sound effects (paper rustle, ink writing)

---

## 📖 Role-Based Access

### Medical Access

Jobs with medical access can:
- View all medical records
- Create treatment records
- Issue prescriptions
- Create death certificates
- Manage medical reports
- Track hospital supplies

### Law Access

Jobs with law access can:
- View criminal records
- Create arrest reports
- Issue warrants
- Manage evidence locker
- Track jail sentences
- Post bounties
- Create BOLO alerts

### Admin Access

Configurable admin roles can:
- View both medical and law records
- Override restrictions
- Delete records (with audit trail)
- View action logs
- Access debug information

---

## 🌐 Multi-Language Support

Prepared for localization:
- English (default)
- Georgian (ka) - წერტილების სია
- Spanish (es)
- French (fr)
- German (de)

All UI text is centralized for easy translation.

---

## 📈 Scalability

Built for large communities:
- **Tested with 10,000+ player records**
- **Efficient pagination** (no lag with huge datasets)
- **Indexed database** for instant searches
- **Configurable cache TTL** to balance performance
- **Cleanup routines** for old data

---

## 🎮 Access Methods

Players can access MDT through multiple methods:

1. **Commands**
   - `/mdt` - Auto-detect role and open appropriate MDT
   - `/medmdt` - Force open Medical MDT
   - `/lawmdt` - Force open Law MDT

2. **Items**
   - `doctor_book` - Medical journal item
   - `law_book` - Law enforcement ledger
   - `mdt_tablet` - Universal MDT device

3. **Terminals**
   - Physical terminals at locations (hospital, sheriff office)
   - Configurable coordinates
   - Target/prompt interaction
   - Distance validation

4. **Keybind** (Optional)
   - Disabled by default
   - Configurable key
   - Permission checked on use

---

## 🛠️ Extensibility

Designed for easy extension:

### Adding New Record Types
1. Create database table
2. Add server-side handlers
3. Add client-side UI
4. Update bridge if needed

### Custom Jobs
Simply add job names to config:
```lua
Config.Jobs.medical = {
    'doctor',
    'surgeon',
    'your_custom_job',
}
```

### Custom Integrations
Bridge layer makes it easy to add:
- New frameworks
- Custom inventory systems
- Different notification systems
- Alternative target systems

---

## 📝 Development Standards

LXR-MDT follows **wolves.land production standards**:

1. **Branded Identity**
   - Every file has mega header
   - Consistent ASCII art style
   - wolves.land signature

2. **Code Quality**
   - No magic numbers
   - Clear variable names
   - Extensive comments
   - Modular structure

3. **Security First**
   - Server-authority model
   - Input validation
   - Rate limiting
   - Audit logging

4. **Performance Optimized**
   - Zero-tick architecture
   - Event-driven
   - Efficient queries
   - Smart caching

5. **Complete Documentation**
   - Every feature documented
   - Setup guides
   - Configuration reference
   - API documentation

---

## 🔄 Typical Workflow

### Medical Workflow

```
1. Doctor opens MDT (/mdt or item)
   ↓
2. Search for patient by name/ID
   ↓
3. View medical history
   ↓
4. Create new treatment record
   ↓
5. Issue prescription (optional)
   ↓
6. Save and close
   ↓
7. Action logged to database
```

### Law Workflow

```
1. Officer opens MDT (/mdt or item)
   ↓
2. Search for citizen by name/ID
   ↓
3. View criminal history
   ↓
4. Create arrest report
   ↓
5. Issue warrant (optional)
   ↓
6. Log evidence (optional)
   ↓
7. Save and close
   ↓
8. Action logged + Discord webhook
```

---

## 🎯 Design Goals Achieved

✅ **Immersive** - Feels like 1899 record-keeping  
✅ **Persistent** - Server remembers everything  
✅ **Secure** - Server-authority model  
✅ **Fast** - Zero-tick, instant response  
✅ **Flexible** - Multi-framework support  
✅ **Scalable** - Handles large communities  
✅ **Documented** - Complete guides  
✅ **Branded** - wolves.land identity  

---

## 🚀 Future Enhancements

Potential expansion areas (not implemented yet):

- Photo attachment system (mugshots, evidence photos)
- Signature system (digital signatures on documents)
- Cross-server sync (shared criminal database)
- Mobile app integration (view-only access)
- Advanced analytics (crime statistics, hospital metrics)
- Report templates (customizable document formats)

---

## 📚 Additional Resources

- **[Installation Guide](installation.md)** - Complete setup instructions
- **[Configuration Reference](configuration.md)** - All config options
- **[Framework Support](frameworks.md)** - Multi-framework details
- **[Events & API](events.md)** - Developer reference
- **[Security Guide](security.md)** - Security best practices
- **[Performance Tuning](performance.md)** - Optimization guide

---

## 🐺 About wolves.land

**The Land of Wolves** is a serious hardcore roleplay community for RedM, focused on Georgian culture and immersive 1899 Western gameplay.

- 🇬🇪 **Georgian RP** - მგლების მიწა (The Land of Wolves)
- 🎭 **Serious Roleplay** - Whitelist required
- 🌟 **Quality Standards** - Production-grade resources only
- 🔐 **Discord Integrated** - Active community
- 📜 **Rich History** - Every action matters

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
