{
  open Parser

  exception SyntaxError of string
}

let ident = ['*' '&']? ['a'-'z' 'A'-'Z' '_'] ['a'-'z' 'A'-'Z' '0'-'9' '_' '[' ']' '-' '>' '.']*
let int = '-'? ['0'-'9'] ['0'-'9']*
let digit = ['0'-'9']
let frac = '.' digit*
let exp = ['e' 'E'] ['-' '+']? digit+
let float = digit* frac? exp?
let white = [' ' '\t']+
let string = ['"'] ['a'-'z' 'A'-'Z' '0'-'9' '_' ' ']* ['"']
let newline = '\r' | '\n' | "\r\n"
              
rule token =
  parse
  | newline        { token lexbuf }
  | white          { token lexbuf }
  | "/*"           { read_comment (Buffer.create 128) lexbuf }
  | "//"           { read_line_comment (Buffer.create 128) lexbuf }
  | "Agent"        { AGENT }
  | "if"           { IF }
  | "else"         { ELSE }
  | "for"          { FOR }
  | "int"          { TINT }  
  | "double"       { TDOUBLE }
  | "string"       { TSTRING }
  | "bool"         { TBOOL }
  | "ang"          { TANGLE }
  | "vec2f"        { TVECTOR }
  | "void"         { VOID }
  | "true"         { BOOL (true) }
  | "false"        { BOOL (false) }
  | "println"      { PRINTLN }
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
  | '|'            { BINOR }
  | '^'            { BINXOR }
  | '('            { LPAREN }
  | ')'            { RPAREN }
  | '{'            { LBRACE }
  | '}'            { RBRACE }
  | ';'            { SEMICOLON }
  | ','            { COMMA }
  | ident          { IDENTIFIER (Lexing.lexeme lexbuf) }
  | eof            { EOF }
  | _              { raise (SyntaxError (
                                "Unexpected char: " ^ Lexing.lexeme lexbuf)) }
  
and read_comment buf =
  parse
  | "*/"     { COMMENT (Buffer.contents buf) }
  | _        { Buffer.add_string buf (Lexing.lexeme lexbuf);
               read_comment buf lexbuf }

and read_line_comment buf =
  parse
  | eof      { COMMENT (Buffer.contents buf) }
  | "//"     { COMMENT (Buffer.contents buf) }
  | newline  { COMMENT (Buffer.contents buf) }
  | _        { Buffer.add_string buf (Lexing.lexeme lexbuf);
               read_line_comment buf lexbuf }
