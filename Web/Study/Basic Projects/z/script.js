let API_KEY = "AIzaSyAPDZ2kBDjU6BPkZCtVc6587X1u164KWdQ";

let button = document.getElementById("checkBtn");
let result = document.getElementById("result");

button.onclick = function () {
  let question = document.getElementById("question").innerText;
  let userAnswer = document.getElementById("answer").value.trim();

  if (userAnswer === "") {
    alert("Please enter an answer");
    return;
  }

  result.innerText = "Checking answer...";

  let prompt = `
Question: ${question}
User Answer: ${userAnswer}

Is the answer correct?
Reply ONLY with YES or NO.
`;

  fetch(
    "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=" + API_KEY,
    {
      method: "POST",
      headers: {
        "Content-Type": "application/json"
      },
      body: JSON.stringify({
        contents: [
          {
            parts: [{ text: prompt }]
          }
        ]
      })
    }
  )
    .then(res => res.json())
    .then(data => {
      console.log(data); 

      let reply =
        data.candidates[0].content.parts[0].text.trim().toUpperCase();

      if (reply.includes("YES")) {
        result.innerText = " Correct Answer";
        result.style.color = "green";
      } else {
        result.innerText = " Wrong Answer";
        result.style.color = "red";
      }
    })
    .catch(err => {
      console.error(err);
      result.innerText = "Error checking answer";
      result.style.color = "black";
    });
};
