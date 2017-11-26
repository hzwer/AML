{
  open Parser
  exception Eof
}

let ident = ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_']*

let int = '-'? ['0'-'9'] ['0'-'9']*

let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let string = ['"'] ['a'-'z' 'A'-'Z' '0'-'9' '_']* ['"']
              
rule token =
  parse [' ' '\t']     { token lexbuf }
  | "agent"        { AGENT }
  | "init"         { INIT }
  | "step"         { STEP }
  | "func"         { FUNC }
  | "if"           { IF }
  | "else"         { ELSE }
  | "for"          { FOR }
  | "int"          { TINT }  
  | "double"       { TDOUBLE }
  | "string"       { TSTRING }
  | "bool"         { TBOOL }
  | "deg"          { TDEGREE }
  | "vec"          { TVECTOR }
  | "true"         { BOOL (true) }
  | "false"        { BOOL (false) }
  | "println"      { PRINTLN }
  | ['\n']         { EOL }
  | int            { INT (int_of_string (Lexing.lexeme lexbuf)) }
  | float          { FLOAT (float_of_string (Lexing.lexeme lexbuf)) }
  | string         { STRING (Lexing.lexeme lexbuf) }
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
  
