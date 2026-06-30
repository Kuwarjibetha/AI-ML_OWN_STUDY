let inp = document.querySelector('input');
let btn = document.querySelector('button');
let uli = document.querySelector('ul');

btn.addEventListener("click", function(){
    let item = document.createElement("li");
    uli.appendChild(item);
    item.innerText = inp.value;
    inp.value = "";
 
    let del = document.createElement('button');
    del.innerText ="Delete";
    del.classList.add("delete");

    item.appendChild(del);
    
});


    uli.addEventListener("click", function(event){
        if(event.target.nodeName == "BUTTON"){
            let listitem = event.target.parentElement;
            listitem.remove();
        };
    });
    


