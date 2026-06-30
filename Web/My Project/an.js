const card = document.querySelectorAll('.card-cont');
const leftImage = document.querySelector('.left-sider');
const rightImage = document.querySelector('.right-sider');

// Initial position for the card
let cardPosition = 0; // in pixels

// Function to update the card's position
function updateCardPosition() {
    card.style.transform = `translateX(${cardPosition}px)`;
}

// Add event listeners to the images
leftImage.addEventListener('click', () => {
    cardPosition -= 50; // Move left by 50px
    updateCardPosition();
});

rightImage.addEventListener('click', () => {
    cardPosition += 50; // Move right by 50px
    updateCardPosition();
});

// Initial style setup for smooth movement
card.style.transition = 'transform 0.3s ease';
