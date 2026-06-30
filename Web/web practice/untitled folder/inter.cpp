#include <iostream>
#include <sstream>
#include <string>
#include <stack>

using namespace std;

double performOperation(double num1, double num2, char op) {
    switch(op) {
        case '+': return num1 + num2;
        case '-': return num1 - num2;
        case '*': return num1 * num2;
        case '/': return num2 != 0 ? num1 / num2 : throw invalid_argument("Division by zero");
        default: throw invalid_argument("Invalid operator");
    }
}

double evaluateExpression(const string& expression) {
    stack<double> numbers;
    stack<char> operations;

    istringstream iss(expression);
    double number;
    char operation;

    iss >> number;
    numbers.push(number);

    while (iss >> operation) {
        iss >> number;
        while (!operations.empty() && ((operation == '+' || operation == '-') || (operation == '*' || operation == '/'))) {
            double num2 = numbers.top();
            numbers.pop();
            double num1 = numbers.top();
            numbers.pop();
            char op = operations.top();
            operations.pop();
            numbers.push(performOperation(num1, num2, op));
        }
        operations.push(operation);
        numbers.push(number);
    }

    while (!operations.empty()) {
        double num2 = numbers.top();
        numbers.pop();
        double num1 = numbers.top();
        numbers.pop();
        char op = operations.top();
        operations.pop();
        numbers.push(performOperation(num1, num2, op));
    }

    return numbers.top();
}

int main() {
    string expression;
    char choice;

    do {
        cout << "Enter an expression (e.g., 2+3-5*): ";
        cin >> expression;

        try {
            double result = evaluateExpression(expression);
            cout << "Result: " << result << endl;
        } catch (const invalid_argument& e) {
            cout << "Error: " << e.what() << endl;
        }

        cout << "Do you want to enter another expression? (y/n): ";
        cin >> choice;

    } while (choice == 'y' || choice == 'Y');

    return 0;
}
