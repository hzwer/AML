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

class _Agent{
public:
    string name;
    virtual void _plot(double,double)=0;
    virtual void _step(double,double,_Agent*)=0;
    virtual void _copy_from(_Agent*)=0;
};
template<typename T>
vector<T*> _Global_Filter(bool (*f)(_Agent*));

const double eps=-1e10;
int facenum;
vec3 *xyzs;//length=3*facenum
double *rgbs;//length=3*facenum
bool ray_triangle_intersection(vec3 P0,vec3 P1,vec3 a,vec3 b,vec3 c,double &t,vec3 &normal){
	//射线方程为P=P0+t*P1,三角形为abc,交点重心分解为alpha*a+beta*b+gamma*c
	vec3 E1=b-a,E2=c-a,T=P0-a;
	vec3 X=P1._crossprd(E2),Y=T._crossprd(E1);
	double k=X*E1;
	if(fabs(k)<eps) return false;
	t=(Y*E2)/k;
	double beta=(X*T)/k;
	double gamma=(Y*P1)/k;
	double alpha=1-beta-gamma;
	if(t<eps) return false;
	if(alpha<-eps) return false;
	if(beta<-eps) return false;
	if(gamma<-eps) return false;
    normal=(b-a)._crossprd(c-a);
	return true;
}

int find_hit(vec3f pos,vec3f dir,double &hit_t){
    int k=-1;hit_t=1e15;
    double t;
    vec3f normal;
    for(int i=0;i<facenum;i++){
        if(ray_triangle_intersection(pos,dir,xyzs[3*i+0],xyzs[3*i+1],xyzs[3*i+2],t,normal)){
            if(t>0){
                if(t<hit_t){
                    hit_t=t;
                    k=i;
                }
            }
        }
    }
    return k;
}

class _Ray: public _Agent{
public:
    vec2f pixel;
    vec3f pos;
    vec3f dir;//it must be normalized
    vec3f color;
    _Ray(vec2f o, vec3f p,vec3f d){
        pixel=o;
        pos=p;
        dir=d;
        color=vec3f(0,0,0);
    }
    void _plot(double _tim,double _dt){
        glColor3f(color.x,color.y,color.z);
        glBegin(GL_POINTS);
        _AML_Vertex2f(pixel);
        glEnd();
        glFlush();
    }
    void _step(double _tim,double _dt,_Agent* _last_Agent){
        _Ray* _last=(_Agent*)_last_Agent;
        int k;double t;
        k=find_hit(pos,dir,t);
        if(k==-1){
            color=vec3f(0,0,0);
        }
        else{
            color=vec3f(rgbx[3*k+0],rgbs[3*k+1],rgbs[3*k+2]);
        }
    }
    void _copy_from(_Agent* _from_Agent){
        _Ray* _from=(_Ray*)_from_Agent;
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

