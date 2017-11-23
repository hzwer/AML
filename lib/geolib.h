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
