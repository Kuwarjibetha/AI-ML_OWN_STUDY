#include <iostream>

using namespace std;

int main() {
    int choice;
    double num1, num2;

    while(true) {
        // Get input from the user
        cout << "Enter first number: ";
        cin >> num1;
        cout << "Enter second number: ";
        cin >> num2;

        cout << "Select operation:" << endl;
        cout << "1. Add" << endl;
        cout << "2. Subtract" << endl;
        cout << "3. Multiply" << endl;
        cout << "4. Divide" << endl;

        // Get the operation choice
        cout << "Enter choice (1/2/3/4): ";
        cin >> choice;

        // Perform the calculation based on the user's choice
        switch (choice) {
            case 1:
                cout << num1 << " + " << num2 << " = " << num1 + num2 << endl;
                break;
            case 2:
                cout << num1 << " - " << num2 << " = " << num1 - num2 << endl;
                break;
            case 3:
                cout << num1 << " * " << num2 << " = " << num1 * num2 << endl;
                break;
            case 4:
                if (num2!= 0) {
                    cout << num1 << " / " << num2 << " = " << num1 / num2 << endl;
                } else {
                    cout << "Error: Division by zero is not allowed!" << endl;
                }
                break;
            default:
                cout << "Invalid choice!" << endl;
                break;
        }

        // Ask the user if they want to continue
        char again;
        cout << "Do you want to continue? (y/n): ";
        cin >> again;

        if (again == 'n' || again == 'N') {
            break;
        }
    }

    return 0;
}