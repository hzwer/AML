// Add the header for agent
#include "cglib.h"
                    
double _FPS=60.0;
// unit is "meter" for them
double _MAP_X=10,_MAP_Y=10;
vec2f _MAP_CENTER(0,5); // 5m
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
