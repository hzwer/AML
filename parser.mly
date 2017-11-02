%{ open Ast %}
%token <string> VARIABLE
%token <int> INT
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token EQUAL
%token EOL
%token EOF
%token COMMA
%token SEMICOLON
%token LBRACE RBRACE
%left PLUS MINUS
%left DIV TIMES

%start main
%type <Ast.expr_list> main
                               
%%
  main:
    | LBRACE block RBRACE        { $2 };

  block:
    | expr SEMICOLON             { Expr($1) }
    | assignment SEMICOLON       { Expr($1) }
    | expr SEMICOLON block       { Multiexpr($1, $3) };
    | assignment SEMICOLON block { Multiexpr($1, $3) };

  vec:
    | LPAREN expr COMMA expr RPAREN { Vec($2, $4) };
  
  expr:
      | INT                           { Int($1) }
      | vec                           { $1 }
      | VARIABLE                      { Var($1) }
      | LPAREN expr RPAREN            { $2}
      | expr TIMES expr               { Binop($1, Mul, $3) }
      | expr DIV expr                 { Binop($1, Div, $3) }
      | expr PLUS expr                { Binop($1, Add, $3) }
      | expr MINUS expr               { Binop($1, Sub, $3) };

  assignment:
    | VARIABLE EQUAL expr             { Assign($1, $3) };
