let minigames = [];

// --- Lock Screen Logic ---
function updateClock() {
    const now = new Date();
    // Format time as HH:MM
    const timeStr = now.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
    document.getElementById('tablet-time').textContent = timeStr;
    document.getElementById('tablet-clock').textContent = timeStr;
    // Format date as e.g. "Monday, 18 April 2022"
    const dateStr = now.toLocaleDateString('en-GB', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
    document.getElementById('tablet-date').textContent = dateStr;
}
setInterval(updateClock, 1000);
updateClock();

// Unlock logic
document.getElementById('tablet-unlock').onclick = function () {
    document.getElementById('tablet-wallpaper').style.display = 'none';
    document.getElementById('app-container').style.display = 'flex';
    // Optionally, render minigames if already loaded
    renderMinigames();
};

// --- Minigame Rendering ---
function renderMinigames() {
    const container = document.getElementById('minigame-list');
    if (!container) return;
    container.innerHTML = '';
    minigames.forEach((game) => {
        const btn = document.createElement('button');
        btn.className = 'desktop-app';
        btn.innerHTML = `
      <i class="${game.icon}"></i>
      <span class="app-title">${game.title}</span>
      <span class="app-desc">${game.description}</span>
    `;
        btn.onclick = () => {
            // Show minigame name (optional)
            showNotification('success', `Starting: ${game.title}`);
            // Close tablet UI
            document.getElementById('tablet-bg').style.display = 'none';
            // Notify Lua to close and start minigame
            fetch(`https://${GetParentResourceName()}/startMinigame`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ startFunction: game.startFunction })
            });
            fetch(`https://${GetParentResourceName()}/closeTablet`, { method: 'POST' });
        };
        container.appendChild(btn);
    });
}

window.addEventListener('message', function (event) {
    if (event.data.action === 'showTablet') {
        minigames = event.data.minigames || [];
        console.log(minigames); // <-- Add this
        renderMinigames();
    }
});

// --- NUI Message Handling ---
window.addEventListener('message', function (event) {
    if (event.data.action === 'showTablet') {
        document.getElementById('tablet-bg').style.display = 'flex';
        document.getElementById('tablet-wallpaper').style.display = 'flex';
        document.getElementById('app-container').style.display = 'none';
        minigames = event.data.minigames || [];
        renderMinigames();
    }
    if (event.data.action === 'notify') {
        showNotification(event.data.type, event.data.message);
    }
});

window.addEventListener('message', function (event) {
    if (event.data.action === 'showTablet') {
        minigames = event.data.minigames || [];
        console.log('Minigames:', minigames);
        renderMinigames();
    }
});

document.addEventListener('keydown', function (e) {
    if (e.key === "Escape") {
        document.getElementById('tablet-bg').style.display = 'none';
        fetch(`https://${GetParentResourceName()}/closeTablet`, { method: 'POST' });
    }
});

// --- Notification Helper ---
function showNotification(type, message) {
    const notif = document.getElementById('notification');
    if (!notif) return;
    notif.className = '';
    notif.classList.add(type);
    notif.innerHTML = message;
    notif.style.display = 'flex';
    setTimeout(() => { notif.style.display = 'none'; }, 1500);
}

document.getElementById('tablet-bg').style.display = 'none';