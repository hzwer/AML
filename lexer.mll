{
  open Parser
  exception Eof
}

let ident = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token =
  parse [' ' '\t']     { token lexbuf }
  | "Agent"        {AGENT}
  | "Init"         {INIT}
  | "Step"         {STEP}
  | "Func"         {FUNC}
  | ['\n']         {EOL}
  | ['0'-'9']+ as lxm { INT(int_of_string lxm) }
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
  | ident          { IDENTIFIER (Lexing.lexeme lexbuf) }
  | eof            { EOF }
