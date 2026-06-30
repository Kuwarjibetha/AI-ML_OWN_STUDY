/* Qs5. Write a program to find the largest of 3 numbers.*/

let first = 23;
let sec = 32;
let third = 4;
   
if(first >= sec && first >=third){
    console.log("first is the largest number");
}
else if(sec>=first && sec>=third){
    console.log("sec is the largest number");
}

else {
    if(third>=first && third>=sec){
    console.log("third is the largest number");
}
}