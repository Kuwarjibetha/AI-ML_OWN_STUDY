function saveDb(act , success , failure){
  let internetSpeed = Math.floor(Math.random()*10)+1;
  if(internetSpeed > 4){
    success(); 
  }
  else{
    failure();
  }
}

saveDb("hello Developer" ,
    ()=>{
        alert("success1!");

    } ,
    ()=>{
        alert("failure1");
    }


);
