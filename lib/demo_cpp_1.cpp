#include "geolib.h"
#include "cglib.h"

class _Agent{
public:
    virtual void _init()=0;
    virtual void _plot()=0;
    virtual void _step()=0;
};
class _Straight_Ship: public _Agent{
public:
    vec2f p;
    void _init(void){
    }
    void _plot(void){
		glColor3f(1.0, 1.0, 1.0);
		glBegin(GL_LINES);
		glVertex2f(-1,-1);
		glVertex2f(1,1);
		glEnd();
		glFlush();
    }
    void _step(void){
    }
};
vector<_Agent*> _agents[2];
int _cur_row;
void _Plot(void){
    glClear(GL_COLOR_BUFFER_BIT);
    for(int i=0;i<_agents[_cur_row].size();i++){
        _agents[_cur_row][i]->_plot();
    }
    glutSwapBuffers();
}
void _Step_Time(int _time_value){
    printf("step time: %d\n",_time_value);
    for(int i=0;i<_agents[_cur_row].size();i++){
        _agents[_cur_row][i]->_step();
    }
    glutPostRedisplay();
    glutTimerFunc(1000/60, _Step_Time, 1);
}

int main(int argc, char *argv[]){
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);//double buffer
    //todo: user shall be able to designate these things in AML
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(500, 500); 
    int glut_window = glutCreateWindow("AML");
    //end todo
    _cur_row=0;
    _Agent *sp1 = new _Straight_Ship;
    _agents[_cur_row].push_back(sp1);
    glutDisplayFunc(&_Plot);
    glutTimerFunc(1000/60, _Step_Time, 1);
    glutMainLoop();
    return 0;
}

