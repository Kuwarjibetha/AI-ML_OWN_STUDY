let input = document.getElementById("taskInput");
let button = document.getElementById("BtnAdd");
let list = document.getElementById("TaskList");

button.onclick = function(){
  if(input.value ===""){
    alert("Please enter a task");
    return;
  }
                                
  let li = document.createElement("li");
  li.innerText = input.value;

  let deleteBtn = document.createElement("button");
  deleteBtn.classList.add('delete-btn');
  deleteBtn.innerText = "Delete";

  deleteBtn.onclick = function(){
    list.removeChild(li);
  };

  li.appendChild(deleteBtn);
  list.appendChild(li);
  input.value = "";
}
