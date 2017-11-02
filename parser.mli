type token =
  | VARIABLE of (string)
  | INT of (int)
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
  (Lexing.lexbuf  -> token) -> Lexing.lexbuf -> Ast.expr_list
