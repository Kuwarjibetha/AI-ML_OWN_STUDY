let btn = document.querySelector("button");
let ino = document.querySelector(".num1");
let ins = document.querySelector(".num2");

btn.addEventListener("click",function(){
    const number1 = parseFloat(document.querySelector(".num1").value);
    const number2 = parseFloat(document.querySelector(".num2").value);
    const sum = number1 +number2;
    
    ino.value="";
    ins.value="";

    document.querySelector("h4").innerText='Result :'+ sum;
})

