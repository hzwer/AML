{
  open Parser
  exception Eof
}

rule token =
 parse [' ' '\t']     { token lexbuf }
  | ['\n']           {EOL}
  | ['0'-'9']+ as lxm { INT(int_of_string lxm) }
  | ['a'-'z']+ as var_name { VARIABLE(var_name) }
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
