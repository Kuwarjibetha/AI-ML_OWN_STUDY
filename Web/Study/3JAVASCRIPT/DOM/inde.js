let bod = document.getElementById("BODY");

let para = document.createElement("p");
let h3 = document.createElement("h3");
let div = document.createElement("div");
let p = document.createElement("p");
let hi3 = document.createElement("h3");
para.innerText = "Hey I'm red!"
h3.innerText = "Hey I'm blue h3!"
h3.style.color="blue";
div.style.backgroundColor ="pink";
div.style.border=" 2px solid black";
p.innerText = "I'm in div";
hi3.innerText = "ME TOO!"


bod.appendChild(para);
bod.appendChild(h3)
bod.appendChild(div);
div.appendChild(p);
div.appendChild(hi3);