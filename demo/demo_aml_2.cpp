Agent Blinker{
    angle theta;
    vec2f pos;
    int color;
    float PI;
    Bliker(void){
        theta=0;
        color=0;
        pi=acos(-1.0);
    }
    void plot(Float t, Float dt){
        vec2f a=pos+vec2f(0,1);
        vec2f b=pos+vec2f(-0.866,-0.5);
        vec2f c=pos+vec2f(+0.866,-0.5);
        if(color==0){
            glColor3f(1.0,0.0,0.0);
        }
        else{
            glColor3f(0.0,0.0,1.0);
        }
        glBegin(GL_TRIANGLES);
        _AML_Vertex2f(a);
        _AML_Vertex2f(b);
        _AML_Vertex2f(c);
        glEnd();
        glFlush();
    }
    void step(Float t, Float dt){
        double dlt=dt/10*2*PI;
        theta+=dlt;
        pos=vec2f(cos(theta),sin(theta))*5;
        if(theta:>0){//operator :> means "when > holds true for the first time"
            color^=1;
        }
    }
};
void main(void){
    Blinker a;
    register(a);
}
