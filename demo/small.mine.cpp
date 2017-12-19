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

struct Ray { vec3f o, d; Ray(vec3f o_, vec3f d_) : o(o_), d(d_) {} Ray(){}}; 
//0:DIFF, 1:SPEC, 2:REFR
struct Sphere {
    double rad;       // radius 
    vec3f p, e, c;      // position, emission, color 
    int refl;      // reflection type (0=diffuse, 1=specular, 2=refractive) 
    Sphere(double rad_, vec3f p_, vec3f e_, vec3f c_, int refl_): 
        rad(rad_), p(p_), e(e_), c(c_), refl(refl_) {} 
    double intersect(Ray r){ // returns distance, 0 if nohit 
        vec3f op = p-r.o; // Solve t^2*d.d + 2*t*(o-p).d + (o-p).(o-p)-R^2 = 0 
        double t, eps=1e-4, b=op._dot(r.d), det=b*b-op._dot(op)+rad*rad; 
        if (det<0) return 0; else det=sqrt(det); 
        return (t=b-det)>eps ? t : ((t=b+det)>eps ? t : 0); 
    } 
};
const int SPHERE_NUM=9;
Sphere spheres[SPHERE_NUM] = {//Scene: radius, position, emission, color, material 
  Sphere(1e5, vec3f( 1e5+1,40.8,81.6), vec3f(),vec3f(.75,.25,.25),0),//Left 
  Sphere(1e5, vec3f(-1e5+99,40.8,81.6),vec3f(),vec3f(.25,.25,.75),0),//Rght 
  Sphere(1e5, vec3f(50,40.8, 1e5),     vec3f(),vec3f(.75,.75,.75),0),//Back 
  Sphere(1e5, vec3f(50,40.8,-1e5+170), vec3f(),vec3f(),           0),//Frnt 
  Sphere(1e5, vec3f(50, 1e5, 81.6),    vec3f(),vec3f(.75,.75,.75),0),//Botm 
  Sphere(1e5, vec3f(50,-1e5+81.6,81.6),vec3f(),vec3f(.75,.75,.75),0),//Top 
  Sphere(16.5,vec3f(27,16.5,47),       vec3f(),vec3f(1,1,1)*.999, 1),//Mirr 
  Sphere(16.5,vec3f(73,16.5,78),       vec3f(),vec3f(1,1,1)*.999, 2),//Glas 
  Sphere(600, vec3f(50,681.6-.27,81.6),vec3f(12,12,12),  vec3f(), 0) //Lite 
}; 
double clamp(double x){ return x<0 ? 0 : x>1 ? 1 : x; } 
int toInt(double x){ return int(pow(clamp(x),1/2.2)*255+.5); } 
bool intersect(const Ray &r, double &t, int &id){ 
    double d,inf=t=1e20;
    for(int i=SPHERE_NUM;i--;) if((d=spheres[i].intersect(r))&&d<t){t=d;id=i;} 
    return t<inf; 
}
vec3f mult(vec3f a,vec3f b){
    return vec3f(a.x*b.x,a.y*b.y,a.z*b.z);
}
class RayBeam:public _Agent{
public:
    vec2f pxl;
    Ray r;
    vec3f colsum;
    vec3f raycol;
    int depth;
    unsigned short seed[3];
    RayBeam(vec2f _p,Ray _r,double scl,int s2){
        pxl=_p;
        r=_r;
        colsum=vec3f(0,0,0);
        raycol=vec3f(scl,scl,scl);
        depth=0;
        seed[0]=seed[1]=0;
        seed[2]=s2;
    };
    void _plot(double _tim,double _dtim){
        glColor3f(colsum.x,colsum.y,colsum.z);
        glBegin(GL_POINTS);
        _AML_Vertex2f(pxl);
        glEnd();
    }
    void _step(double _tim,double _dtim,_Agent* _last_Agent){
        double t;                               // distance to intersection 
        int id=0;                               // id of intersected object 
        if (!intersect(r, t, id)) return;       // if miss, do not update colsum
        Sphere obj = spheres[id];               // the hit object 
        vec3f x=r.o+r.d*t, n=(x-obj.p)._norm(), nl=n._dot(r.d)<0?n:n*-1, f=obj.c; 
        double p = f.x>f.y && f.x>f.z ? f.x : f.y>f.z ? f.y : f.z; // max refl 
        depth++;
        if (obj.refl == 0){                  // Ideal diffuse reflection 
            double r1=2*M_PI*erand48(seed), r2=erand48(seed), r2s=sqrt(r2); 
            vec3f w=nl, u=((fabs(w.x)>.1?vec3f(0,1,0):vec3f(1,0,0))._crossprd(w))._norm(), v=w._crossprd(u); 
            vec3f d = (u*cos(r1)*r2s + v*sin(r1)*r2s + w*sqrt(1-r2))._norm();
            colsum=colsum+mult(raycol,obj.e);
            raycol=mult(raycol,f);
            r=Ray(x,d);
        }
        else if (obj.refl == 1){            // Ideal 1ULAR reflection 
            colsum=colsum+mult(raycol,obj.e);
            raycol=mult(raycol,f);
            r=Ray(x,r.d-n*2*n._dot(r.d));
        }
        else{
            Ray reflRay=Ray(x, r.d-n*2*n._dot(r.d));     // Ideal dielectric refraction 
            bool into = n._dot(nl)>0;                // Ray from outside going in? 
            double nc=1, nt=1.5, nnt=into?nc/nt:nt/nc, ddn=r.d._dot(nl), cos2t; 
            if ((cos2t=1-nnt*nnt*(1-ddn*ddn))<0){    // Total internal reflection 
                colsum=colsum+mult(raycol,obj.e);
                raycol=mult(raycol,f);
                r=reflRay;
            }
            else{
                vec3f tdir = (r.d*nnt - n*((into?1:-1)*(ddn*nnt+sqrt(cos2t))))._norm(); 
                double a=nt-nc, b=nt+nc, R0=a*a/(b*b), c = 1-(into?-ddn:tdir._dot(n)); 
                double Re=R0+(1-R0)*c*c*c*c*c,Tr=1-Re,P=.25+.5*Re,RP=Re/P,TP=Tr/(1-P); 
                colsum=colsum+mult(raycol,obj.e);
                raycol=mult(raycol,f);
                if(depth>2){
                    if(erand48(seed)<P){r=reflRay;raycol=raycol*RP;}
                    else{r=Ray(x,tdir);raycol=raycol*TP;}
                }
                else{//these two temrs are supposed to be added together
                    if(rand()&1){r=reflRay;raycol=raycol*Re;}
                    else{r=Ray(x,tdir);raycol=raycol*Tr;}
                }
            }
        }
    }
	void _copy_from(_Agent* _from_Agent){
        RayBeam* _from=(RayBeam*)_from_Agent;
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
	glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);//double buffer
    //todo: user shall be able to designate these things in AML
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(50,50); 
    int glut_window = glutCreateWindow("AML");

    int w=1024, h=768;//, samps = argc==2 ? atoi(argv[1])/4 : 1; // # samples 
    int samps=1;
	_Set_Map_XY(w,h);
    _Set_Map_Center(w/2.0,h/2.0);
    Ray cam(vec3f(50,52,295.6), vec3f(0,-0.042612,-1)._norm()); // cam pos, dir 
    vec3f cx=vec3f(w*.5135/h), cy=(cx._crossprd(cam.d))._norm()*.5135, r, *c=new vec3f[w*h]; 
    for (int y=0; y<h; y++){                       // Loop over image rows 
        fprintf(stderr,"\rRendering (%d spp) %5.2f%%",samps*4,100.*y/(h-1)); 
        for (unsigned short x=0, seed[3]={0,0,y*y*y}; x<w; x++)   // Loop cols
            for (int sy=0, i=(h-y-1)*w+x; sy<2; sy++)     // 2x2 subpixel rows 
                for (int sx=0; sx<2; sx++, r=vec3f()){        // 2x2 subpixel cols 
                    for (int s=0; s<samps; s++){ 
                        double r1=2*erand48(seed), dx=r1<1 ? sqrt(r1)-1: 1-sqrt(2-r1); 
                        double r2=2*erand48(seed), dy=r2<1 ? sqrt(r2)-1: 1-sqrt(2-r2); 
                        vec3f d = cx*( ( (sx+.5 + dx)/2 + x)/w - .5) + 
                            cy*( ( (sy+.5 + dy)/2 + y)/h - .5) + cam.d;
                        vec2f ray_pxl=vec2f(x+(sx+0.5+dx)/2,y+(sy+0.5+dy)/2);
                        vec3f ray_o=cam.o+d*140;
                        vec3f ray_dir=d._norm();
                        double ray_scl=1.0/samps*0.25;
                        Ray ray_r(ray_o,ray_dir);
						_Agent *r=new RayBeam(ray_pxl,ray_r,ray_scl,y*y*y);
						_Agent *_copy_r=new RayBeam(ray_pxl,Ray(ray_o,ray_dir),ray_scl,y*y*y);
						*_copy_r=*r;
						_agents.push_back(make_pair(_copy_r,r));
                    } // Camera rays are pushed ^^^^^ forward to start in interior 
                } 
    }
	glutDisplayFunc(&_Plot);
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
    glutMainLoop();
    return 0; 
 } 
