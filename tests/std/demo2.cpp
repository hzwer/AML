// Produced by AML
#include "geolib.h"
// Add the header for agent
#include "cglib.h"
                    
double _FPS=60.0;
// unit is "meter" for them
double _MAP_X=20,_MAP_Y=20;
vec2f _MAP_CENTER(0,0); // 5m
double _SPEEDUP_RATE=1;

//must allowed user-defination interfaces:
void _Set_Map_XY(double _X,double _Y){
    _MAP_X = _X;
    _MAP_Y = _Y;
}
void _Set_Map_Center(double _x,double _y){
    _MAP_CENTER = vec2f(_x,_y);
}
void _Set_Speedup_Rate(double _rate){
    _SPEEDUP_RATE=_rate;
}
void _SET_FPS(double _fps){
    _FPS = _fps;
}
void _AML_Vertex2f(vec2f pos){
    pos = pos - _MAP_CENTER;
    pos = (pos/_MAP_X*2.0, pos/_MAP_Y*2.0);
    glVertex2f(pos.x,pos.y);
}
class _Agent{
public:
    virtual void _plot(double,double)=0;
    virtual void _step(double,double,_Agent*)=0;
    virtual void _copy_from(_Agent*)=0;
};
class _Blinker: public _Agent{
public:
    angle theta;
    vec2f pos;
    int color;
    double PI;
     _Blinker() {
        theta = 0;
        color = 0;
        PI = acos(-1.);
    }
    void _plot(double _tim, double _dtim) {
        vec2f a = (pos + vec2f(0, 1));
        vec2f b = (pos + vec2f(-0.866, -0.5));
        vec2f c = (pos + vec2f(0.866, -0.5));
        if((color == 0)) {
            glColor3f(1., 0., 0.);
        }
        else {
            glColor3f(0., 0., 1.);
        }
        glBegin(GL_TRIANGLES);
        _AML_Vertex2f(a);
        _AML_Vertex2f(b);
        _AML_Vertex2f(c);
        glEnd();
        glFlush();

    }
    void _step(double _tim, double _dtim, _Agent* _last_Agent) {
        _Blinker* _last = (_Blinker*)_last_Agent;
        double dlt = (((_dtim / 10) * 2) * PI);
        theta = (theta + dlt);
        pos = (vec2f(cos(theta), sin(theta)) * 5);
        /* operator :> means "when > holds true for the first time"*/
        if((!(_last->theta > angle(0))&&(theta > angle(0)))) {
            color = (color ^ 1);
        }
    }
    void _copy_from(_Agent *_from_Agent){
        _Blinker* _from = (_Blinker*)_from_Agent;
        *this = *_from;
    }
};

vector<pair<_Agent*,_Agent*> > _agents;
double _dt=1/_FPS*_SPEEDUP_RATE;
double _cur_tim=0.0;
void _Plot(void){
    glClear(GL_COLOR_BUFFER_BIT);
    for(int i=0;i<_agents.size();i++){
        _agents[i].second->_plot(_cur_tim, _dt);
    }
    glutSwapBuffers();
}
void _Step_Time(int _time_value){
    //printf("step time: %d\n",_time_value);
    for(int i=0;i<_agents.size();i++){
        _agents[i].second->_step(_cur_tim,_dt,_agents[i].first);
        _agents[i].first->_copy_from(_agents[i].second);
    }
    _cur_tim+=_dt;
    glutPostRedisplay();
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
}

int main(int argc, char *argv[]) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(500, 500);
    int glut_window = glutCreateWindow("AML");
    _Agent *sp1 = new _Blinker;
    _Agent *sp2 = new _Blinker;
    *sp2 = *sp1;
    _agents.push_back(make_pair(sp2,sp1));
    glutDisplayFunc(&_Plot);
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
    glutMainLoop();
}
