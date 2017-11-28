type token =
  | AGENT
  | INIT
  | STEP
  | IDENTIFIER of (string)
  | DEFTYPE of (string)
  | INT of (int)
  | IF
  | ELSE
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
  | FUNC
  | SEMICOLON
  | LBRACE
  | RBRACE

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.t
