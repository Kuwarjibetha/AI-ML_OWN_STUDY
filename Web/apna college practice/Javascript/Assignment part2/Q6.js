/* Qs6(Bonus).
Write a program to check if 2 numbers have the same last digit.Eg: 32 and 47852 have the same last digit i.e.2 */

let num1 = 32;
let num2 = 47857 ;

if((num1 % 10) == (num2 % 10 )){
    console.log("both number have a same last digit");
}
else{
    console.log("both numbeer is not have a same last digit");
}