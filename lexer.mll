{
  open Parser
  exception Eof
}

let ident = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

rule token =
  parse [' ' '\t']     { token lexbuf }
  | "agent"        { AGENT }
  | "init"         { INIT }
  | "step"         { STEP }
  | "func"         { FUNC }
  | "if"           { IF }
  | "else"         { ELSE }
  | "for"          { FOR }
  | ['\n']         { EOL }
  | ['0'-'9']+ as lxm { INT(int_of_string lxm) }
  | '='            { EQUAL }
  | '+'            { PLUS }
  | '-'            { MINUS }
  | '*'            { TIMES }
  | '/'            { DIV }
  | '%'            { MOD }
  | '!'            { NOT }
  | "=="           { SEQ }
  | "!="           { SNE }
  | '>'            { GT }
  | '<'            { LT }
  | ">="           { GE }
  | "<="           { LE }
  | "&&"           { AND }
  | "||"           { OR }
  | "&"            { BINAND}  
  | "|"            { BINOR }
  | "^"            { BINXOR }
  | '('            { LPAREN }
  | ')'            { RPAREN }
  | '{'            { LBRACE }
  | '}'            { RBRACE }
  | ';'            { SEMICOLON }
  | ','            { COMMA }
  | ident          { IDENTIFIER (Lexing.lexeme lexbuf) }
  | eof            { EOF }
