let but = document.querySelector("button");


but.addEventListener("click",function(){
    let h3 = document.querySelector("h3");
    let randomColor = rand()
    h3.innerText = randomColor;
    let div = document.querySelector("div");
    div.style.backgroundColor = randomColor;
})




function rand(){
    let red = Math.floor(Math.random()*255);
    let green = Math.floor(Math.random()*255);
    let blue = Math.floor(Math.random()*255);

    let rgb = `rgb(${red}, ${green}, ${blue})`;
    return rgb;
}

