Agent Ball{
    vec2f pos;
    vec2f vel;
    Ball(){
        pos = vec2f(0, 10);
    }
    void plot(){
        glColor3f(1.0, 1.0, 1.0);
        glBegin(GL_LINES);
        plotvec2f(pos); 
        plotvec2f(pos + vel * 0.1 / _dtim);
        glEnd();
        glColor3f(1.0, 0.0, 0.0);
        glBegin(GL_POINTS);
        plotvec2f(pos);
        glEnd();
    }
    void step(){
        pos = vec2f(0.0, 10 - _tim * _tim * 4.9);
        vel = pos;
    }
};

project(){
    register(Ball);
}
