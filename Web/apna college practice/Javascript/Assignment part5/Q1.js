// Create a program that generates a random number representing a dice roll[The number should be between 1 and 6].
let random_dice_roll = Math.random();

random_dice_roll = Math.floor(random_dice_roll*6) +1;
console.log(random_dice_roll)