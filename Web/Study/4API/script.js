let jsonReq = '{"fact":"Approximately 1/3 of cat owners think their pets are able to read their minds.", "length": 78}';

let validReq = JSON.parse(jsonReq);
console.log(validReq);
console.log(validReq.fact);
console.log(validReq.length);