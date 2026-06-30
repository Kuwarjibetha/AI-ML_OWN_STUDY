let max = prompt("enter the max number");
let random = Math.floor(Math.random()* max)+1;

let guess = prompt("enter a guessing number and If you want exit enter 'quit'");

while(true){
    if(guess =="quit"){
        console.log("you quit the random game ");
        break;
    }
    if(guess == random){
        console.log("congrat! you guessing write a number",random);
    }
    else if(guess < random){
        console.log("to lowest");
        guess = prompt("to lowest. Please try again");
    }
    else if(guess > random){
        console.log("to large")
        guess = prompt("to large. Please try again");
    }
    else{
       guess = prompt("Wrong guessing. Please try again");
    }
}