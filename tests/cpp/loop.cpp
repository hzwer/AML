/*produced by AML*/
#include<cmath>
#include<cstdio>
#include<cstring>
#include<iostream>
#include<algorithm>
using namespace std;  
void loop(int num) {
    for(int i = 0; (i < 2); i = (i + 1)) {
        int j = 0;
        cout << "loop" << endl;
    }
    loop(num);
}
