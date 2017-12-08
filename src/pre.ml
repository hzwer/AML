
open Ast
open Printf

let remove_diff x =
  let len = String.length x
  in
  if (x.[len - 1] = '\'') then (String.sub x 0 (len - 1))
  else x

let is_diff x =
  x != (remove_diff x)
  
let rec gather_diff list = function
    Assign(l, Leftvalue(Identifier e)) ->
    if(is_diff e) then (remove_diff e) :: list
    else list
  | Stmts(h :: t) -> gather_diff (gather_diff list h) (Stmts t)
  | x -> list       
       
let rec pre_agent_fun indentifier = function
    Function(t, "step", identifiers, stmt) ->
    (
      let _stmt = Stmts([
                           Expr(String("_" ^ indentifier ^"* _last = (_" ^ indentifier ^ "*)_last_Agent;"));
                           stmt;
                         ])            
      in Function(t, "_step", [String("double _tim, double _dtim, _Agent* _last_Agent")], _stmt)
    )
  | Function(t, "plot", identifiers, stmt) ->
     let _stmt = Stmts([
                          stmt;
                          Expr(String("glFlush();\n"));
                      ])
     in Function(t, "_plot", [String("double _tim, double _dtim")],              
                 _stmt)
  | Function(t, identifier, identifiers, stmt) ->
     Function(t, "_" ^ identifier, identifiers, stmt)
  | x -> x
       
let pre_agent = function
    Agent(identifier, Stmts(stmt)) ->
    let _stmt = Stmts(List.concat [
                          (List.map (pre_agent_fun identifier) stmt);
                          [
                            Expr(String("void _copy_from(_Agent *_from_Agent){
        _" ^ identifier ^"* _from = (_" ^ identifier ^"*)_from_Agent;
        *this = *_from;
    }"))
                     ]])
    in Agent("_" ^ identifier, _stmt)
  | x -> x;;

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
  Stmts([prev; Function(Builtintype("int"), "main", [String("int argc, char *argv[]")], _stmt)])
  | x -> x;;
    
let register = function
    [Leftvalue(Identifier(x))] -> Stmts([
         Expr(String("_Agent *sp1 = new _" ^ x ^ ";"));
         Expr(String("_Agent *sp2 = new _" ^ x ^ ";"));
         Expr(String("*sp2 = *sp1;"));
         Expr(String("_agents.push_back(make_pair(sp2,sp1));"));
     ])
  | x -> Stmts([Expr(String("fault"))]);;
