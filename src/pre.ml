open Ast

let pre_main = function
    Function(t, identifier, identifiers, stmt) ->
  let _stmt = 
    Stmts(
        [Expr(String("glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowPosition(100, 100);
    glutInitWindowSize(500, 500);
    int glut_window = glutCreateWindow(\"AML\");"));
         stmt;
         Expr(String("glutDisplayFunc(&_Plot);
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
    glutMainLoop();"));
      ])
  and prev =
    Expr(String("
vector<pair<_Agent*,_Agent*> > _agents;
double _dt=1/_FPS*_SPEEDUP_RATE;
double _cur_tim=0.0;
void _Plot(void){
    glClear(GL_COLOR_BUFFER_BIT);
    for(int i=0;i<_agents.size();i++){
        _agents[i].second->_plot(_cur_tim, _dt);
    }
    glutSwapBuffers();
}
void _Step_Time(int _time_value){
    //printf(\"step time: %d\\n\",_time_value);
    for(int i=0;i<_agents.size();i++){
        _agents[i].second->_step(_cur_tim,_dt,_agents[i].first);
        _agents[i].first->_copy_from(_agents[i].second);
    }
    _cur_tim+=_dt;
    glutPostRedisplay();
    glutTimerFunc(1000/_FPS, _Step_Time, 1);
}
"))        
  in
  Stmts([prev; Function(t, "main", identifiers, _stmt)])
  | x -> x;;
    
let register = function
    [Leftvalue(Identifier(x))] -> Stmts([
         Expr(String("_Agent *sp1 = new _" ^ x ^ ";"));
         Expr(String("_Agent *sp2 = new _" ^ x ^ ";"));
         Expr(String("*sp2 = *sp1;"));
         Expr(String("_agents.push_back(make_pair(sp2,sp1));"));
     ])
  | x -> Stmts([Expr(String("fault"))]);;
