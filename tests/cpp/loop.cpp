// Produced by AML
#include "geolib.h"
int main() {
    int sum;
    for(int i = 1, j; (i <= 10); (i++)) {
        for(j = 1; (j <= 10); (j++)) {
            sum = ((sum + i) + j);
        }
    }
    cout << sum << endl;
    return 0;
}
