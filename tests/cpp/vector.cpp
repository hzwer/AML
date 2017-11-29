// produced by AML
#include "geolib.h"
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>  
using namespace std;  
int main() {
    cout << vec(1, 2) << endl;
    cout << (vec(0, 0) + vec(1, 1)) << endl;
    vec a = vec(3, 5);
    vec b = vec(1, 5);
    cout << (a + b) << endl;
    cout << (a - b) << endl;
    cout << (a * b) << endl;
    cout << (a / b) << endl;
    return 0;
}
