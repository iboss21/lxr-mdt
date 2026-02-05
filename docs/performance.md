# 🐺 LXR-MDT - Performance Guide

```
  ██████╗ ███████╗██████╗ ███████╗ ██████╗ ██████╗ ███╗   ███╗ █████╗ ███╗  ██╗ ██████╗███████╗
  ██╔══██╗██╔════╝██╔══██╗██╔════╝██╔═══██╗██╔══██╗████╗ ████║██╔══██╗████╗  ██║██╔════╝██╔════╝
  ██████╔╝█████╗  ██████╔╝█████╗  ██║   ██║██████╔╝██╔████╔██║███████║██╔██╗ ██║██║     █████╗  
  ██╔═══╝ ██╔══╝  ██╔══██╗██╔══╝  ██║   ██║██╔══██╗██║╚██╔╝██║██╔══██║██║╚██╗██║██║     ██╔══╝  
  ██║     ███████╗██║  ██║██║     ╚██████╔╝██║  ██║██║ ╚═╝ ██║██║  ██║██║ ╚████║╚██████╗███████╗
  ╚═╝     ╚══════╝╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝ ╚═════╝╚══════╝
```

**🐺 wolves.land Production Resource**  
© 2026 iBoss21 / The Lux Empire

---

## 🎯 Performance Target

**Goal:** `<0.03ms idle | 0.00ms resmon`

LXR-MDT is designed for **zero-tick architecture** - meaning zero wasted resources when idle.

---

## ⚡ Zero-Tick Architecture

### What is Zero-Tick?

**Traditional (Bad) Approach:**
```lua
Citizen.CreateThread(function()
    while true do
        Wait(0)  -- Running every frame!
        -- Check stuff every frame
        -- Wasteful!
    end
end)
```

**Zero-Tick (Good) Approach:**
```lua
-- No idle threads
-- Event-driven only
RegisterNetEvent('lxr-mdt:open', function()
    -- Only runs when event fires
    -- Zero cost when idle
end)
```

### Why It Matters

- **FPS Impact:** Idle threads consume CPU every frame
- **Server Load:** Multiple resources add up
- **Battery Life:** Important for laptop players
- **Professionalism:** Production-grade resources don't waste resources

### How LXR-MDT Achieves Zero-Tick

1. **No While Loops**
   - No `while true` threads
   - No constant checking
   - No idle loops

2. **Event-Driven**
   - Everything triggered by events
   - Only runs when needed
   - Instant response, zero waste

3. **Smart Caching**
   - Cache frequently accessed data
   - Reduce database queries
   - TTL-based cache invalidation

---

## 📊 Performance Metrics

### Measuring Performance

**Using txAdmin:**
1. Resources tab
2. Find `lxr-mdt`
3. Check `ms` column
4. Should show `0.00ms` when idle

**Using resmon:**
```
resmon
```
Look for `lxr-mdt` - should be minimal or absent when idle.

**Using profiler:**
```
profiler record 1000
```
Then check server console for breakdown.

### Expected Metrics

| State | CPU Usage | Memory |
|-------|-----------|--------|
| **Idle** | 0.00ms | ~5MB |
| **Opening MDT** | 0.01-0.02ms | ~8MB |
| **Searching** | 0.02-0.05ms | ~10MB |
| **Heavy Use** | <0.10ms | ~15MB |

---

## 🗄️ Database Optimization

### Indexed Tables

All tables have proper indexes for fast queries:

```sql
-- Example: mdt_players
KEY `citizenid` (`citizenid`)      -- Fast ID lookup
KEY `name_search` (`firstname`, `lastname`)  -- Fast name search
```

### Query Optimization

**Inefficient:**
```sql
SELECT * FROM mdt_medical_records  -- Gets ALL records!
```

**Optimized:**
```sql
SELECT * FROM mdt_medical_records 
WHERE citizenid = ? 
ORDER BY created_at DESC 
LIMIT 50  -- Only recent records
```

### Batch Operations

**Instead of 50 individual inserts:**
```lua
for i = 1, 50 do
    MySQL.insert('INSERT INTO ...', {data[i]})  -- 50 queries!
end
```

**Use batch insert:**
```lua
MySQL.insert('INSERT INTO ... VALUES ' .. batchValues)  -- 1 query!
```

### Connection Pooling

oxmysql handles connection pooling automatically:
- Reuses connections
- Prevents connection spam
- Faster query execution

---

## 💾 Caching System

### What Gets Cached

```lua
Config.Performance = {
    enableCache         = true,   -- Enable caching
    cacheTTL            = 300,    -- 5 minutes
    cachePlayerLimit    = 100,    -- Max 100 players
}
```

**Cached Data:**
- Player records (citizenid, name, job)
- Recent searches
- Active warrants
- Online player list

### Cache Flow

1. **First Request**
   - Check cache
   - Cache miss
   - Query database
   - Store in cache
   - Return result

2. **Subsequent Requests**
   - Check cache
   - Cache hit!
   - Return from cache
   - Skip database

3. **Cache Expiration**
   - TTL expires (5 minutes)
   - Next request refreshes cache
   - Updated data served

### Manual Cache Management

```lua
-- Clear cache for specific player
ClearPlayerCache(citizenid)

-- Clear all cache
ClearAllCache()

-- Refresh cache
RefreshPlayerCache(citizenid)
```

---

## 🚀 Optimization Tips

### 1. Adjust Cache Settings

**Small Server (< 32 players):**
```lua
Config.Performance = {
    cacheTTL            = 600,    -- 10 minutes
    cachePlayerLimit    = 50,     -- Less cache needed
}
```

**Large Server (> 64 players):**
```lua
Config.Performance = {
    cacheTTL            = 300,    -- 5 minutes (fresher data)
    cachePlayerLimit    = 200,    -- More cache capacity
}
```

### 2. Database Tuning

**Add more indexes if needed:**
```sql
-- If searching by job is slow
CREATE INDEX idx_job ON mdt_players(job);

-- If date searches are slow
CREATE INDEX idx_created ON mdt_arrests(created_at);
```

**Monitor slow queries:**
```sql
-- Enable slow query log in MySQL
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 1;  -- Queries > 1 second
```

### 3. Limit Result Sets

Always use `LIMIT` in queries:
```lua
-- Good
MySQL.query('SELECT * FROM mdt_arrests WHERE citizenid = ? LIMIT 50', {id})

-- Bad (could return thousands)
MySQL.query('SELECT * FROM mdt_arrests WHERE citizenid = ?', {id})
```

### 4. Pagination

For large result sets, use pagination:
```lua
local page = 1
local perPage = 25
local offset = (page - 1) * perPage

MySQL.query('SELECT * FROM mdt_arrests LIMIT ? OFFSET ?', {perPage, offset})
```

### 5. Async Operations

Use async when possible:
```lua
-- Async (non-blocking)
MySQL.query.await('SELECT ...')  -- Waits without blocking

-- Sync (blocking)
MySQL.query('SELECT ...', {}, function(result)
    -- Callback
end)
```

---

## 🔧 Performance Configuration

### Recommended Settings

```lua
Config.Performance = {
    -- Threading
    useThreads          = false,  -- NEVER enable
    
    -- Caching
    enableCache         = true,   -- Always enable
    cacheTTL            = 300,    -- 5 minutes
    cachePlayerLimit    = 100,    -- Adjust for server size
    
    -- Database
    batchInserts        = true,   -- Enable batching
    batchSize           = 50,     -- 50 records per batch
    queryTimeout        = 5000,   -- 5 seconds
    
    -- Updates
    playerDataUpdate    = 60000,  -- Every minute
    onlinePlayerCheck   = 30000,  -- Every 30 seconds
}
```

---

## 🐛 Performance Troubleshooting

### High CPU Usage

**Symptoms:**
- MDT using >0.05ms idle
- Server FPS drops
- High resmon numbers

**Causes:**
1. Debug logging enabled
2. Unnecessary threads running
3. Database query issues
4. Memory leaks

**Solutions:**
```lua
-- Disable debug
Config.Debug = {
    printStartup        = true,   -- Keep
    printFramework      = true,   -- Keep
    printEvents         = false,  -- Disable
    printDatabase       = false,  -- Disable
    printPermissions    = false,  -- Disable
}

-- Check for threads
grep -r "CreateThread" .  -- Should be minimal

-- Monitor queries
Config.General.debugSQL = true  -- Temporarily enable
```

### Slow Queries

**Symptoms:**
- MDT takes long to open
- Search is slow
- Database timeout errors

**Causes:**
1. Missing indexes
2. Large result sets
3. Inefficient queries
4. Poor database performance

**Solutions:**
```sql
-- Add indexes
CREATE INDEX idx_name ON mdt_players(firstname, lastname);

-- Optimize tables
OPTIMIZE TABLE mdt_players;
OPTIMIZE TABLE mdt_arrests;

-- Check query execution
EXPLAIN SELECT * FROM mdt_players WHERE firstname = 'John';
```

### Memory Leaks

**Symptoms:**
- Memory usage increases over time
- Server crashes after days
- Restarts fix temporarily

**Causes:**
1. Cache not clearing
2. Event listeners not removed
3. Large data structures not freed

**Solutions:**
```lua
-- Clear cache periodically
SetInterval(function()
    ClearOldCache()
end, 3600000)  -- Every hour

-- Remove event listeners when done
local eventHandler = AddEventHandler('event', function() end)
RemoveEventHandler(eventHandler)  -- When done
```

---

## 📈 Performance Monitoring

### Built-in Profiling

Enable performance debug:
```lua
Config.Debug.printPerformance = true
```

Logs execution times:
```
[LXR-MDT] OpenMDT: 0.12ms
[LXR-MDT] SearchPlayers: 2.34ms
[LXR-MDT] CreateReport: 1.89ms
```

### External Tools

**txAdmin:**
- Resources tab shows real-time usage
- History graphs
- Performance alerts

**New Relic / DataDog:**
- Professional monitoring
- Detailed metrics
- Alerting system

**Custom Logging:**
```lua
local startTime = GetGameTimer()
-- Operation here
local endTime = GetGameTimer()
print('^2[PERF]^7 Operation took ' .. (endTime - startTime) .. 'ms')
```

---

## ✅ Performance Checklist

Before going live:

- [ ] Zero idle CPU usage (0.00ms in resmon)
- [ ] All debug logging disabled
- [ ] Caching enabled and tuned
- [ ] Database indexes present
- [ ] Queries optimized with LIMIT
- [ ] No while loops or idle threads
- [ ] Batch operations where possible
- [ ] Cache TTL appropriate for server
- [ ] Tested with max expected players
- [ ] Monitored over 24+ hours
- [ ] No memory leaks detected
- [ ] Query timeout reasonable

---

## 🎯 Performance Goals

| Metric | Target | Acceptable | Poor |
|--------|--------|------------|------|
| **Idle CPU** | 0.00ms | <0.01ms | >0.03ms |
| **Active CPU** | <0.05ms | <0.10ms | >0.20ms |
| **Memory** | <10MB | <20MB | >50MB |
| **Query Time** | <50ms | <200ms | >1000ms |
| **Cache Hit** | >90% | >70% | <50% |
| **Load Time** | <100ms | <500ms | >1000ms |

---

**🐺 wolves.land** | The Land of Wolves  
**Developer:** iBoss21 / The Lux Empire  
**License:** Proprietary - wolves.land Exclusive

**Performance is not optional. It's a feature.**
