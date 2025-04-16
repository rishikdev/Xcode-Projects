// Nothing to do here

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
