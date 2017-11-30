// produced by AML
#include "geolib.h"
#include <cmath>
#include <cstdio>
#include <cstring>
#include <iostream>
#include <algorithm>  
using namespace std;  
class _Ball: public _Agent{
public:
    vec2f pos;
    vec2f vel;
     _Ball() {
        pos = vec2f(0, 10);
    }
    void _plot(double t, double dt) {
        glColor3f(1., 1., 1.);
        glBegin(GL_LINES);
        plotvec2f(pos);
        plotvec2f((pos + ((vel * 0.1) / dt)));
        glEnd();
        glFlush();
        glColor3f(1., 0., 0.);
        glBegin(GL_POINTS);
        plotvec2f(pos);
        glEnd();
        glFlush();
    }
    int step(double t, double dt) {
        pos = vec2f(0., (10 - ((tim * tim) * 4.9)));
        /* vel = ''pos;*/
    }
};
int main() {
    Ball a;
    register(a);
}
