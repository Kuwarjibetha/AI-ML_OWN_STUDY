function savetoDb(){
    return new Promise((resolve,reject)=>{
        let internetSpeed = Math.floor(Math.random()*10)+1;
        if (internetSpeed >4){
            resolve("sucess : Data is saved");
        }
        else{
            reject("failure : weak connection");
        }
    });
}d 