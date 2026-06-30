/* Qs4. A string is a golden string if it starts with the character ‘A’ or ‘a’ and has a total length greater than 5 .
For a given string print if it is golden or not.*/
let golden = "Apna college";

if(golden[0]==="a" || golden[0]=== "A" && golden.length >= 5){
    console.log("A string is a golden string");
}
else{
    console.log("A string is not a golden string");
}