#include "geolib.h"
#include "cglib.h"

double _FPS=1;
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

int PH=50,PW=50;
double L=1;
const double eps=1e-10;
int facenum;
vec3f *xyzs;//length=3*facenum
vec3f *ambients;//length=facenum
vec3f *diffuses;//length=facenum
vec3f *speculars;//length=facenum
double *shininesses;//length=facenum
int lightnum;
vec3f *lightxyzs;//length=lightnum
vec3f *lightrgbs;//length=lightnum
void print(vec3f p){
    cout<<"("<<p.x<<","<<p.y<<","<<p.z<<")";
}
void read(char *filename){
    FILE *fin = fopen(filename,"r");
    fscanf(fin,"%d%d",&facenum,&lightnum);
    xyzs=new vec3f[3*facenum];
    ambients=new vec3f[facenum];
    diffuses=new vec3f[facenum];
    speculars=new vec3f[facenum];
    shininesses=new double[facenum];
    vec3f now_ambient=vec3f(0,0,0);
    vec3f now_diffuse=vec3f(0,0,0);
    vec3f now_specular=vec3f(0,0,0);
    double now_shininess=0;
    lightxyzs=new vec3f[lightnum];
    lightrgbs=new vec3f[lightnum];
    vec3f now_xyz=vec3f(0,0,0);
    vec3f now_rgb=vec3f(0,0,0);
    int face_cnt=0,light_cnt=0;
    char buf[50];
    while(true){
        if(fscanf(fin,"%s",buf)==EOF) break;
        string cmd=string(buf);
        if(cmd=="face"){
            for(int t=0;t<3;t++){
                double x,y,z;
                fscanf(fin,"%lf%lf%lf",&x,&y,&z);
                xyzs[face_cnt*3+t]=vec3f(x,y,z);
                ambients[face_cnt]=now_ambient;
                diffuses[face_cnt]=now_diffuse;
                speculars[face_cnt]=now_specular;
                shininesses[face_cnt]=now_shininess;
            }
            face_cnt++;
        }
        else if(cmd=="ambient"){
            fscanf(fin,"%lf%lf%lf",&now_ambient.x,&now_ambient.y,&now_ambient.z);
        }
        else if(cmd=="diffuse"){
            fscanf(fin,"%lf%lf%lf",&now_diffuse.x,&now_diffuse.y,&now_diffuse.z);
        }
        else if(cmd=="specular"){
            fscanf(fin,"%lf%lf%lf",&now_specular.x,&now_specular.y,&now_specular.z);
        }
        else if(cmd=="shininess"){
            fscanf(fin,"%lf",&now_shininess);
        }
        else if(cmd=="light"){
            double x,y,z;
            fscanf(fin,"%lf%lf%lf",&x,&y,&z);
            lightxyzs[light_cnt]=vec3f(x,y,z);
            lightrgbs[light_cnt]=now_rgb;
        }
        else if(cmd=="lightcol"){
            double x,y,z;
            fscanf(fin,"%lf%lf%lf",&x,&y,&z);
            now_rgb=vec3f(x,y,z);
        }
    }
    fclose(fin);
}

vec3f normalize(vec3f p){
    return p/p._len();
}

vec3f blinn_phong(vec3f look,vec3f pos,vec3f normal0,vec3f diffuse,vec3f specular,double shininess, vec3f lightpos,vec3f lightcol){
    cout<<"calc phong\n";
	//位置pos,位置向眼睛的方向是look(look已单位化),法向normal(已单位化),物体O,光源light
	vec3f normal=normalize(normal0);
	vec3f L=lightpos-pos;//光源方向
    double L_len=L._len();
	double atten=1.0/(1.0+0.1*L_len+0.05*L_len*L_len);//衰减率
    L=L/L_len;
	vec3f lambert,reflect;//漫射光和反射光
	vec3f H=normalize(L+look);
    double NL=normal*L,NH=normal*H;
    lambert.x=diffuse.x*atten*lightcol.x*max(NL,0.0);
    lambert.y=diffuse.y*atten*lightcol.y*max(NL,0.0);
    lambert.z=diffuse.z*atten*lightcol.z*max(NL,0.0);
    reflect.x=specular.x*atten*lightcol.x*pow(max(NH,0.0),shininess);
    reflect.y=specular.y*atten*lightcol.y*pow(max(NH,0.0),shininess);
    reflect.z=specular.z*atten*lightcol.z*pow(max(NH,0.0),shininess);
    return reflect+lambert;
}

bool ray_triangle_intersection(vec3f P0,vec3f P1,vec3f a,vec3f b,vec3f c,double &t,vec3f &normal){
	//射线方程为P=P0+t*P1,三角形为abc,交点重心分解为alpha*a+beta*b+gamma*c
    //print(P0);print(P1);cout<<endl;print(a);print(b);print(c);cout<<endl;
	vec3f E1=b-a,E2=c-a,T=P0-a;
	vec3f X=P1._crossprd(E2),Y=T._crossprd(E1);
	double k=X*E1;
	if(fabs(k)<eps) return false;
	t=(Y*E2)/k;
	double beta=(X*T)/k;
	double gamma=(Y*P1)/k;
	double alpha=1-beta-gamma;
	if(t<eps) return false;
    //cout<<t<<" "<<beta<<" "<<gamma<<" "<<alpha<<endl;
	if(alpha<-eps) return false;
	if(beta<-eps) return false;
	if(gamma<-eps) return false;
    normal=(b-a)._crossprd(c-a);
	return true;
}

int find_hit(vec3f pos,vec3f dir,double &hit_t,vec3f &normal){
    int k=-1;hit_t=1e15;
    double t;
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

bool light_visible(vec3f p,vec3f light){
    vec3f pos=p;
    vec3f dir=light-p;
    double t;
    vec3f normal;
    if(find_hit(pos,dir,t,normal)){
        if(t+eps<1.0) return false;
    }
    return true;
}

class _Ray: public _Agent{
public:
    vec2f pixel;
    vec3f pos;
    vec3f dir;//it must be normalized
    vec3f color_sum;
    _Ray(vec2f o, vec3f p,vec3f d){
        pixel=o;
        pos=p;
        dir=d;
        color_sum=vec3f(0,0,0);
    }
    void _plot(double _tim,double _dt){
        glColor3f(color_sum.x,color_sum.y,color_sum.z);
        glBegin(GL_POINTS);
        _AML_Vertex2f(pixel);
        glEnd();
        glFlush();
    }
    void _step(double _tim,double _dt,_Agent* _last_Agent){
        //print(pos);print(dir);
        _Ray* _last=(_Ray*)_last_Agent;
        int k;double t;
        vec3f normal;
        k=find_hit(pos,dir,t,normal);
        vec3f color;
        if(k==-1){
            color=vec3f(0,0,0);
        }
        else{
            vec3f hit_p=pos+dir*t;
            vec3f look=normalize(dir*(-1.0));
            vec3f n=normalize(normal);
            color=ambients[k];
            for(int i=0;i<lightnum;i++){
                if(light_visible(hit_p,lightxyzs[i])){
                    color=color+blinn_phong(look,hit_p,n,diffuses[k],speculars[k],shininesses[k],lightxyzs[i],lightrgbs[i]);
                }
            }
            //cout<<"n: ";print(n);
            vec3f rf=n*2-look;
            vec3f dir1=rf-hit_p;
            pos=hit_p;
            dir=dir1;
        }
        color_sum=color_sum+color;
        //print(pos);print(dir);
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
    printf("enter to continue:");
    getchar();
    printf("go\n");
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
    glutInitWindowSize(50,50); 
    int glut_window = glutCreateWindow("AML");
    //end todo
    _Set_Map_XY(2*L,2*L);
    read("1.scn");
    for(int i=0;i<PH;i++){
        for(int j=0;j<PW;j++){
            double y=+L-(i+0.5)*(2*L/PH);
            double x=-L+(j+0.5)*(2*L/PW);
            vec2f o(x,y);
            vec3f p(0,0,1);
            vec3f d(x,y,-1);
            _Agent *r=new _Ray(o,p,d);
            _Agent *_copy_r=new _Ray(o,p,d);
            *_copy_r=*r;
            _agents.push_back(make_pair(_copy_r,r));
            
        }
    }
    glutDisplayFunc(&_Plot);
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
    glutMainLoop();
    return 0;
}

