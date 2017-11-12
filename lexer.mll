{
  open Parser
  exception Eof
}

rule token =
 parse [' ' '\t']     { token lexbuf }
  | "Agent"        {AGENT}
  | "Init"         {INIT}
  | "Step"         {STEP}
  | "int"          {DEFINT}
  | "vec2i"        {DEFVEC2I}
  | ['\n']         {EOL}
  | ['0'-'9']+ as lxm { INT(int_of_string lxm) }
  | ['a'-'z']+ as var_name { VARIABLE(var_name) }
  | ['a'-'z']+ as def_typ  { DEFTYPE(def_typ) }
  | '='            { EQUAL }
  | '+'            { PLUS }
  | '-'            { MINUS }
  | '*'            { TIMES }
  | '/'            { DIV }
  | '('            { LPAREN }
  | ')'            { RPAREN }
  | '{'            { LBRACE }
  | '}'            { RBRACE }
  | ';'            { SEMICOLON }
  | ','            { COMMA }
  | eof            { EOF }
