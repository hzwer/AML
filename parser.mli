type token =
  | AGENT
  | INIT
  | STEP
  | VARIABLE of (string)
  | DEFTYPE of (string)
  | INT of (int)
  | DEFINT
  | DEFVEC2I
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | LPAREN
  | RPAREN
  | EQUAL
  | EOL
  | EOF
  | COMMA
  | SEMICOLON
  | LBRACE
  | RBRACE

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.agents
