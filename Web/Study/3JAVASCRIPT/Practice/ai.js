const API_KEY = "AIzaSyCU5pnMzEIxllveX593lO-YPrOR8WtWCdw";

async function sendMessage() {

  const input = document.getElementById("user-input");
  const chatBox = document.getElementById("chat-box");

  const userMessage = input.value.trim();

  if (!userMessage) return;

  // User message
  chatBox.innerHTML += `
    <p><b>You:</b> ${userMessage}</p>
  `;

  input.value = "";

  // Loading
  const loadingId = "loading";

  chatBox.innerHTML += `
    <p id="${loadingId}"><b>AI:</b> Typing...</p>
  `;

  try {

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=${API_KEY}`,
      {
        method: "POST",
        headers: {
          "Content-Type": "application/json"
        },
        body: JSON.stringify({
          contents: [
            {
              parts: [
                { text: userMessage }
              ]
            }
          ]
        })
      }
    );

    const data = await response.json();

    // Remove loading text
    document.getElementById(loadingId).remove();

    const aiReply =
      data?.candidates?.[0]?.content?.parts?.[0]?.text ||
      "No response received.";

    // AI message
    chatBox.innerHTML += `
      <p><b>AI:</b> ${aiReply}</p>
    `;

    // Auto scroll
    chatBox.scrollTop = chatBox.scrollHeight;

  } catch (error) {

    document.getElementById(loadingId).remove();

    chatBox.innerHTML += `
      <p><b>AI:</b> Error fetching response.</p>
    `;

    console.error(error);
  }
}

// Enter key support
document
  .getElementById("user-input")
  .addEventListener("keypress", function(event) {

    if (event.key === "Enter") {
      sendMessage();
    }

});