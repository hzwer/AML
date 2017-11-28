// produced by AML
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>
using namespace std;  
int main() {
    int sum;
    for(int i = 1; (i <= 100); i = (i + 1)) {
        sum = (sum + i);
    }
    cout << sum << endl;
    return 0;
}
