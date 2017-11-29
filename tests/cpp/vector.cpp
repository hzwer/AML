// produced by AML
#include "geolib.h"
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>  
using namespace std;  
int main() {
    cout << vec2f(1, 2) << endl;
    cout << (vec2f(0, 0) + vec2f(1, 1)) << endl;
    vec2f a = vec2f(3, 5);
    vec2f b = vec2f(1, 5);
    double d = 2.1;
    cout << (a + b) << endl;
    cout << (a - b) << endl;
    cout << (a * b) << endl;
    cout << (a / b) << endl;
    cout << (a * d) << endl;
    cout << (a / d) << endl;
    return 0;
}
