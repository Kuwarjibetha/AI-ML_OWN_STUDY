
let id = setInterval (() => {
   console.log("Hello World");
},2000);

setTimeout (()=>{
    console.log(clearInterval(id));
},11000);


