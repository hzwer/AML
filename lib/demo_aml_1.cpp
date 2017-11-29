Agent Ball{
    vec2f pos;
    vec2f vel;
    Ball(void){
        pos=vec2f(0,10);
    }
    void plot(Float t, Float dt){
        glColor3f(1.0,1.0,1.0);
        glBegin(GL_LINES);
        plotvec2f(pos);//our reserved system function
        plotvec2f(pos+vel*0.1/dt);
        glEnd();
        glFlush();
        glColor3f(1.0,0.0,0.0);
        glBegin(GL_POINTS);
        plotvec2f(pos);
        glEnd();
        glFlush();
    }
    void step(Float t,Float dt){
        pos = vec2f(0.0,10-tim*tim*4.9);
        vel = ''pos;
    }
};

void main(void){
    Ball a;
    register(a);
}
