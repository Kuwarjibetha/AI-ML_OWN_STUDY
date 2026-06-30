let display = document.getElementById('display');
let currentInput = '';
let currentOperation = null;

function clearDisplay() {
    currentInput = '';
    currentOperation = null;
    display.innerText = '0';
}

function appendNumber(number) {
    if (currentInput === '0') {
        currentInput = number;
    } else {
        currentInput += number;
    }
    display.innerText = currentInput;
}

function appendOperation(operation) {
    if (currentInput === '' && operation !== '-') {
        return;
    }
    if (currentOperation !== null) {
        calculate();
    }
    currentInput += ` ${operation} `;
    currentOperation = operation;
    display.innerText = currentInput;
}

function calculate() {
    try {
        const result = eval(currentInput);
        display.innerText = result;
        currentInput = result.toString();
        currentOperation = null;
    } catch {
        display.innerText = 'Error';
    }
}