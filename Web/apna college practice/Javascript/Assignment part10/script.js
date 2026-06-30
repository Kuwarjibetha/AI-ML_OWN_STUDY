let inp = document.querySelector("input");
let btn = document.querySelector("button");
let un = document.querySelector("ul")
let item = document.createElement("li");


btn.addEventListener("click", function () {
    item.innerText = inp.value;
    un.appendChild(item);
    inp.value = "";
      
});

 let del = document.createElement("button");
 del.innerText="Delete";
 del.addEventListener("click", function(){
    console.log("dele");
    item.appendChild(del);
 })
// let del = document.createElement("button");

//  del.addEventListener("click", function(){

//     del.innerText = "Delete";
//     item.appendChild(del);
//  })

