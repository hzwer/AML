type token =
  | INT of (int)
  | PLUS
  | MINUS
  | TIMES
  | DIV
  | LPAREN
  | RPAREN
  | EOL
  | COMMA
  | SEMICOLON

val main :
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr
