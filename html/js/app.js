/*
  ═══════════════════════════════════════════════════════════════════════════════════
  🐺 LXR-MDT - NUI JAVASCRIPT
  ═══════════════════════════════════════════════════════════════════════════════════
  © 2026 iBoss21 / The Lux Empire | wolves.land
  ═══════════════════════════════════════════════════════════════════════════════════
*/

let currentMDTType = null;
let currentJobData = null;

// Message handler from client
window.addEventListener('message', function(event) {
    const data = event.data;
    
    switch(data.action) {
        case 'openMDT':
            openMDT(data.mdtType, data.jobData);
            break;
        case 'closeMDT':
            closeMDT();
            break;
    }
});

// Open MDT
function openMDT(mdtType, jobData) {
    currentMDTType = mdtType;
    currentJobData = jobData;
    
    const container = document.getElementById('mdt-container');
    const subtitle = document.getElementById('mdt-type');
    
    if (mdtType === 'medical') {
        subtitle.textContent = 'Medical Database Terminal';
    } else if (mdtType === 'law') {
        subtitle.textContent = 'Law Enforcement Database Terminal';
    }
    
    container.classList.remove('hidden');
}

// Close MDT
function closeMDT() {
    const container = document.getElementById('mdt-container');
    container.classList.add('hidden');
    
    // Send close callback to client
    fetch(`https://${GetParentResourceName()}/close`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({})
    });
}

// Navigation
document.querySelectorAll('.nav-btn').forEach(btn => {
    btn.addEventListener('click', function() {
        const page = this.getAttribute('data-page');
        switchPage(page);
    });
});

function switchPage(pageName) {
    // Update nav buttons
    document.querySelectorAll('.nav-btn').forEach(btn => {
        btn.classList.remove('active');
    });
    document.querySelector(`[data-page="${pageName}"]`).classList.add('active');
    
    // Update pages
    document.querySelectorAll('.mdt-page').forEach(page => {
        page.classList.remove('active');
    });
    document.getElementById(`${pageName}-page`).classList.add('active');
}

// Search players
function searchPlayers() {
    const searchTerm = document.getElementById('search-input').value;
    
    if (!searchTerm || searchTerm.trim() === '') {
        return;
    }
    
    fetch(`https://${GetParentResourceName()}/searchPlayer`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({
            searchTerm: searchTerm
        })
    });
}

// ESC key to close
document.addEventListener('keydown', function(event) {
    if (event.key === 'Escape') {
        closeMDT();
    }
});

// Get resource name helper
function GetParentResourceName() {
    return window.location.hostname === 'nui-game-internal' 
        ? 'lxr-mdt' 
        : 'lxr-mdt';
}
