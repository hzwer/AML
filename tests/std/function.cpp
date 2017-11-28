// produced by AML
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;  
int fibonacci(int num) {
    if(((num == 0) || (num == 1))) {
        return 0;
    }
    else {
        return 1;
    }
}
int main() {
    cout << fibonacci(3) << endl;
    return 0;
}
