const API_KEY = "Your API Key";

async function sendMessage(){

  const input = document.getElementById("userInput");
  const chatBox = document.getElementById("chatBox");

  const userText = input.value;

  if(userText === "") return;

  // User Message
  chatBox.innerHTML += `
    <div class="message user">
      ${userText}
    </div>
  `;

  input.value = "";

  // Loading
  chatBox.innerHTML += `
    <div class="message bot" id="loading">
      Thinking...
    </div>
  `;

  try{

    const response = await fetch(
      "https://api-inference.huggingface.co/models/microsoft/DialoGPT-medium",
      {
        method:"POST",
        headers:{
          "Authorization":`Bearer ${API_KEY}`,
          "Content-Type":"application/json"
        },
        body:JSON.stringify({
          inputs:userText
        })
      }
    );

    const data = await response.json();

    document.getElementById("loading").remove();

    let botReply = "No response";

    if(data.generated_text){
      botReply = data.generated_text;
    }

    // Some HF models return array
    if(Array.isArray(data)){
      botReply = data[0].generated_text;
    }

    // Bot Message
    chatBox.innerHTML += `
      <div class="message bot">
        ${botReply}
      </div>
    `;

    chatBox.scrollTop = chatBox.scrollHeight;

  }catch(error){

    document.getElementById("loading").remove();

    chatBox.innerHTML += `
      <div class="message bot">
        Error loading AI
      </div>
    `;
  }
}