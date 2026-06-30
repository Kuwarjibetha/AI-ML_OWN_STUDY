let but = document.createElement('button');
console.log(but.innerText="Clik Me");

let butt = document.querySelector('body');
console.log(butt.appendChild(but));

but.setAttribute('id', 'btn');
let new_btn = document.getElementById('btn');
console.log(new_btn.style.background="blue", new_btn.style.color="white");

let h1 = document.createElement('h1');
h1.innerText="DOM Practice";
h1.style.color="purple";
h1.style.textDecoration="dotted underline ";
let ex = document.querySelector('body');
console.log(ex.appendChild(h1));

let pa = document.createElement('p');
pa.innerHTML="Apna College <b> Delta</b> Practice";

console.log(ex.appendChild(pa));
