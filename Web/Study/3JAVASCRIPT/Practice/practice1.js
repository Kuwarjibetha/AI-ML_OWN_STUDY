function vowelCount(str){
    let count = 0;
    const vowels = ['a', 'e', 'i', 'o', 'u'];
    for (let i =0; i<str.length; i++){
        if(vowels.includes(str[i].toLowerCase())){
            count++;
        }
    }
    return count;
}

const inputString = "Hello World!";
const result = vowelCount(inputString);
console.log(`The number of vowels in "${inputString}" is: ${result}`);



const vowelC = (str)=>{
    let count = 0;
    const vowels = ['a', 'e', 'i', 'o', 'u'];
    for (let i =0; i<str.length; i++){
        if(vowels.includes(str[i].toLowerCase())){
            count++;
        }
    }
    return count;   
}

const inputStr = "Hello World!";
const res = vowelC(inputStr);
console.log(`The number of vowels in "${inputStr}" is: ${res}`);

