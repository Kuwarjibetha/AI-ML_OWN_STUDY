let newp = document.createElement('p');
let nex = document.createElement('h3');
console.log(newp.innerText ="Hello i am red");
console.log(nex.innerText="I am blue h3!");
console.log(newp.style.color="red");
console.log(nex.style.color="blue");

let hep = document.querySelector('body');
console.log(hep.appendChild(newp));
console.log(hep.appendChild(nex));



let div = document.createElement('div');
let h1 = document.createElement('h1');
let para2 = document.createElement('p');

console.log(h1.innerText="I'm in a div");
console.log(para2.innerText="ME TOO!");
console.log(div.appendChild(h1));
console.log(div.appendChild(para2));
console.log(div.style.border="2px solid black", div.style.background="pink");


let newt = document.querySelector('body');
console.log(newt.appendChild(div));


