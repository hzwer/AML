%{ open Ast %}
%token <int> INT
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token EOL
%token COMMA
%token SEMICOLON
%left PLUS MINUS
%left DIV TIMES

%start main
%type <Ast.expr> main
                               
%%

  main:
    expr EOL                      { $1 };;

  vec:
    | LPAREN INT COMMA INT RPAREN { Vec($2, $4) };;
    
  expr:
      | INT                           { Int($1) }
      | vec                           { $1 }
      | LPAREN expr RPAREN            { $2}
      | expr TIMES expr               { Binop($1, Mul, $3) }
      | expr DIV expr                 { Binop($1, Div, $3) }
      | expr PLUS expr                { Binop($1, Add, $3) }
      | expr MINUS expr               { Binop($1, Sub, $3) }
