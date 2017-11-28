#include<iostream>
#include<cstdio>
#include<algorithm>
#include<cstring>
#include<cmath>
using namespace std;
typedef double Float;
class vec2f{
public:
    Float x,y;
    vec2f(){}
    vec2f(Float _x,Float _y):x(_x),y(_y){}
    vec2f operator + (const vec2f &b){return vec2f(x+b.x,y+b.y);}
    vec2f operator - (const vec2f &b){return vec2f(x-b.x,y-b.y);}
    Float operator * (const vec2f &b){return x*b.x+y*b.y;}
    vec2f operator * (Float b){return vec2f(x*b,y*b);}
    vec2f operator / (Float b){return vec2f(x/b,y/b);}
    Float _sqrlen(void){return x*x+y*y;}
    Float _crossprd(const vec2f &b){return x*b.y-b.x*y;}
};
class vec3f{
public:
    Float x,y,z;
    vec3f(){}
    vec3f(Float _x,Float _y,Float _z):x(_x),y(_y),z(_z){}
    vec3f operator + (const vec3f &b){return vec3f(x+b.x,y+b.y,z+b.z);}
    vec3f operator - (const vec3f &b){return vec3f(x-b.x,y-b.y,z-b.z);}
    Float operator * (const vec3f &b){return x*b.x+y*b.y+z*b.z;}
    vec3f operator * (Float b){return vec3f(x*b,y*b,z*b);}
    vec3f operator / (Float b){return vec3f(x/b,y/b,z/b);}
    Float _sqrlen(void){return x*x+y*y;}
    vec3f _crossprd(const vec3f &b){return vec3f(y*b.z-z*b.y,z*b.x-x*b.z,x*b.y-y*b.x);}
};
const Float _PI=acos(-1.0);
class angle{//[-PI,PI]
public:
    Float x,y;
    angle(){}
    angle(Float r){
        x=cos(r);
        y=sin(r);
    }
    angle(Float _x,Float _y){
        x=_x;
        y=_y;
    }
    angle operator + (Float d){
        //cos(a+b)=cos(a)cos(b)-sin(a)sin(b)
        //sin(a+b)=cos(a)sin(b)+sin(a)cos(b)
        return angle(x*cos(d)-y*sin(d),  x*sin(d)+y*cos(d));
    }
    angle operator - (Float d){
        //cos(a-b)=cos(a)cos(b)+sin(a)sin(b)
        //sin(a-b)=sin(a)cos(b)-cos(a)sin(b)
        return angle(x*cos(d)+y*sin(d), -x*sin(d)+y*cos(d));
    }
    angle operator * (Float d){
        Float r=atan2(y,x);
        return angle(r*d);
    }
    angle _approach(const angle &tgt,const angle &lw,const angle &hi){
        //instead of approaching this angle to tgt, "approach" tgt to this angle
    }
};
