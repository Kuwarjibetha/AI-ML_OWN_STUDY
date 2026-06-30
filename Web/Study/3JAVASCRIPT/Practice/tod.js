let inp = document.querySelector("input");
let but = document.querySelector("button");
let bod = document.querySelector("body");


but.addEventListener("click", function(){
    let li = document.createElement("li");
    let del = document.createElement("button");
    del.className = ".delete"
    del.innerText = "Delete";
    li.innerText = inp.value;

    del.addEventListener("click",function(){
        bod.removeChild(li);
    })

    bod.appendChild(li);
    li.appendChild(del);
    inp.value = "";
})


