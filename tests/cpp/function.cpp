// produced by AML
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;  
int fibonacci(int num) {
    if((num == 0)) {
        return 0;
    }
    else {
        if((num == 1)) {
            return 1;
        }
        else {
            return (fibonacci((num - 2)) + fibonacci((num - 1)));
        }
    }
}
int main() {
    cout << fibonacci(3) << endl;
    return 0;
}
