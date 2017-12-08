#include "geolib.h"
#include "cglib.h"

double _FPS=60.0;
//unit is "meter" for them
double _MAP_X=20,_MAP_Y=20;
vec2f _MAP_CENTER(0,0);//5m
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
//interfaces end

void _AML_Vertex2f(vec2f pos){
    pos = pos - _MAP_CENTER;
    pos = (pos/_MAP_X*2.0, pos/_MAP_Y*2.0);
    glVertex2f(pos.x,pos.y);
}

double L=100;
double PI=acos(-1.0);

void plot_square(vec2f pos){
    double da=1.0;
    vec2f a=pos+vec2f(-da,-da);
    vec2f b=pos+vec2f(+da,-da);
    vec2f c=pos+vec2f(+da,+da);
    vec2f d=pos+vec2f(-da,+da);
    glBegin(GL_POLYGON);
    _AML_Vertex2f(a);
    _AML_Vertex2f(b);
    _AML_Vertex2f(c);
    _AML_Vertex2f(d);
    glEnd();
}

class _Agent{
public:
    string name;
    virtual void _plot(double,double)=0;
    virtual void _step(double,double,_Agent*)=0;
    virtual void _copy_from(_Agent*)=0;
};
template<typename T>
vector<T*> _Global_Filter(bool (*f)(_Agent*));
class _Runner: public _Agent{
public:
    vec2f pos;
    double rate;
    vec2f vel;
    int color;
    _Runner(double x,double y,double r,double deg){
        name="Runner";//compiler add this
        pos=vec2f(x,y);
        rate=r;
        double alpha=deg*180/PI;
        vel=vec2f(cos(alpha),sin(alpha));
        color=0;
    }
    void _plot(double _tim,double _dt){
        //printf("%lf %lf\n",pos.x,pos.y);
        if(color==0){
            glColor3f(1.0,0.0,0.0);
        }
        else{
            glColor3f(0.0,0.0,1.0);
        }
        plot_square(pos);
        glFlush();
    }
    void _step(double _tim,double _dt,_Agent* _last_Agent){
        _Runner* _last=(_Runner*)_last_Agent;
        double t_rate=rate*_dt;
        pos=pos+vel*t_rate;
        if(!((_last->pos).x>=L)&&(pos.x)>=L) vel.x=-vel.x;
        if(!((_last->pos).x<=-L)&&(pos.x)<=-L) vel.x=-vel.x;
        if(!((_last->pos).y>=L)&&(pos.y)>=L) vel.y=-vel.y;
        if(!((_last->pos).y<=-L)&&(pos.y)<=-L) vel.y=-vel.y;
    }
    void _copy_from(_Agent* _from_Agent){
        _Runner* _from=(_Runner*)_from_Agent;
        *this=*_from;
    }
};
bool is_runner(_Agent *a){
    return a->name=="Runner";
}
class _Chaser: public _Agent{
public:
    vec2f pos;
    vec2f vel;
    double rate;
    _Chaser(double x,double y,double r){
        name="Chaser";//compiler add this
        pos=vec2f(x,y);
        vel=vec2f(0,0);
        rate=r;
    }
    void _plot(double _tim,double _dt){
        //printf("%lf %lf\n",pos.x,pos.y);
        glColor3f(1.0,1.0,1.0);
        plot_square(pos);
        glFlush();
    }
    void _step(double _tim,double _dt,_Agent* _last_Agent){
        pos=pos+vel;
        vector<_Runner*> agents=_Global_Filter<_Runner>(is_runner);
        _Runner* near=NULL;
        double sl=-1;
        for(int i=0;i<agents.size();i++){
            vec2f q=agents[i]->pos;
            if(near==NULL||(q-pos)._sqrlen()<sl){
                near=agents[i];
                sl=(q-pos)._sqrlen();
            }
        }
        vel=near->pos-pos;
        vel=vel/sqrt(vel._sqrlen());
        double t_rate=rate*_dt;
        pos=pos+vel*t_rate;
        vel=vel*t_rate;
    }
    void _copy_from(_Agent* _from_Agent){
        _Chaser* _from=(_Chaser*)_from_Agent;
        *this=*_from;
    }
};
vector<pair<_Agent*,_Agent*> > _agents;
double _dt=1/_FPS*_SPEEDUP_RATE;
double _cur_tim=0.0;
template<typename T>
vector<T*> _Global_Filter(bool (*f)(_Agent*)){
    vector<T*> ret;
    for(int i=0;i<_agents.size();i++){
        if(f(_agents[i].second)){
            ret.push_back((T*)_agents[i].second);
        }
    }
    return ret;
}
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

int main(int argc, char *argv[]){
    /*function calls such as _SET_MAP_XY must be filled here
    */
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);//double buffer
    //todo: user shall be able to designate these things in AML
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(1000, 1000); 
    int glut_window = glutCreateWindow("AML");
    //end todo
    _Set_Map_XY(2*L,2*L);
    double R=50;
    for(int i=0;i<10;i++){
        double deg=i*36.0;
        double x=cos(deg)*R;
        double y=sin(deg)*R;
        _Agent *r=new _Runner(x,y,15+i,deg);
        _Agent *_copy_r=new _Runner(x,y,15+i,deg);//our compiler just copy definition of r
        *_copy_r=*r;
        _agents.push_back(make_pair(_copy_r,r));
    }
    _Agent *c=new _Chaser(1,0,5);
    _Agent *_copy_c=new _Chaser(1,0,5);
    *_copy_c=*c;
    _agents.push_back(make_pair(_copy_c,c));
    glutDisplayFunc(&_Plot);
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
    glutMainLoop();
    return 0;
}

