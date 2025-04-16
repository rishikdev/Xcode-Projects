function show(platform, enabled, useSettingsInsteadOfPreferences) {
    document.body.classList.add(`platform-${platform}`);

    if (useSettingsInsteadOfPreferences) {
        document.getElementsByClassName('platform-mac state-on')[0].innerText = "RYTD’s extension is currently on. You can turn it off in the Extensions section of Safari Settings. Platform:";
        document.getElementsByClassName('platform-mac state-off')[0].innerText = "RYTD’s extension is currently off. You can turn it on in the Extensions section of Safari Settings.";
        document.getElementsByClassName('platform-mac state-unknown')[0].innerText = "You can turn on RYTD’s extension in the Extensions section of Safari Settings.";
        document.getElementsByClassName('platform-mac open-preferences')[0].innerText = "Quit and Open Safari Settings…";
        
        if(platform === "mac") {
            const cards = document.querySelectorAll('.card');
            
            cards.forEach(card => {
                card.classList.remove('mt-3');
            });
        }
    }

    if (typeof enabled === "boolean") {
        document.body.classList.toggle(`state-on`, enabled);
        document.body.classList.toggle(`state-off`, !enabled);
    } else {
        document.body.classList.remove(`state-on`);
        document.body.classList.remove(`state-off`);
    }    
}

function openPreferences() {
    webkit.messageHandlers.controller.postMessage("open-preferences");
}

document.querySelector("button.open-preferences").addEventListener("click", openPreferences);

// Function to update the class of all .card elements based on the colour scheme
function updateCardClasses() {
    // Get all card elements
    const cards = document.querySelectorAll('.card');

    // Check the user's preferred colour scheme
    if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
        // If dark mode is active, add the 'text-bg-secondary' class
        cards.forEach(card => {
            card.classList.add('text-bg-dark');
            card.classList.remove('text-bg-light');
        });
    } else {
        // If light mode is active, add the 'text-bg-light' class
        cards.forEach(card => {
            card.classList.add('text-bg-light');
            card.classList.remove('text-bg-dark');
        });
    }
}

// Call the function to set the initial theme on page load
updateCardClasses();

// Listen for changes to the colour scheme and update the classes dynamically
window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', updateCardClasses);

