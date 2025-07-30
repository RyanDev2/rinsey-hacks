let minigames = [];

// Close button functionality
document.getElementById('close-btn').onclick = function() {
  document.getElementById('tablet-bg').style.display = 'none';
  fetch(`https://${GetParentResourceName()}/closeTablet`, { method: 'POST' });
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
      // Show minigame name
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

// --- NUI Message Handling ---
window.addEventListener('message', function (event) {
  if (event.data.action === 'showTablet') {
    document.getElementById('tablet-bg').style.display = 'flex';
    minigames = event.data.minigames || [];
    console.log('Minigames:', minigames);
    renderMinigames();
  }
  if (event.data.action === 'notify') {
    showNotification(event.data.type, event.data.message);
  }
});

// ESC key to close
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
  
  const icon = type === 'success' ? 'fas fa-check-circle' : 'fas fa-exclamation-circle';
  notif.innerHTML = `<i class="${icon}"></i><span>${message}</span>`;
  notif.style.display = 'flex';
  
  setTimeout(() => { 
    notif.style.display = 'none'; 
  }, 3000);
}

// Hide on initial load
document.getElementById('tablet-bg').style.display = 'none';