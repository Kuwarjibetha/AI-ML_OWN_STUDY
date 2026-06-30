let arr =[];

let user = prompt("enter what you want");
while(true){
    if(user =="quit"){
        console.log("you are quit");
        break;
    }

    if(user == "list"){
        console.log("-------------------");
          for(let i=0; i<arr.length; i++){
            console.log(i, arr[i]);
          }
        console.log("-------------------");
    }
    else if(user == "add"){
        let task = prompt("enter what you want add");
        arr.push(task);
        console.log("task added");
    }
    else if(user == "delete"){
          let idx=prompt("enter which indexyou want to delet");
          arr.splice(idx ,1);
          console.log("deleted");
    }
    user = prompt("enter what you want");
}