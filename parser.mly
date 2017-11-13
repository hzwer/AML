%{ open Ast %}
%token AGENT
%token INIT
%token STEP
%token <string> IDENTIFIER
%token <string> DEFTYPE
%token <int> INT
%token DEFINT
%token DEFVEC2I
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token EQUAL
%token EOL
%token EOF
%token COMMA
%token FUNC
%token SEMICOLON
%token LBRACE RBRACE
%left PLUS MINUS
%left DIV TIMES

%start main
%type <Ast.t> main
                               
%%
  main:
    toplevel_list EOF               { $1 }

  toplevel:
    | stmt {Stmt $1}    
    | FUNC IDENTIFIER LPAREN identifier_list RPAREN
      LBRACE stmt_list RBRACE
      { Function($2, $4, $7) }
    | AGENT LBRACE init step RBRACE {Agent($3, $4)}
    
  toplevel_list:
    | { [] }
    | toplevel toplevel_list      { $1 :: $2 }

  init:
    | INIT LBRACE stmt_list RBRACE   {$3}
  
  step:
    | STEP LBRACE stmt_list RBRACE   {$3}
    
  identifier_list:
    | { [] }
    | IDENTIFIER
      { [$1] }
    | IDENTIFIER COMMA identifier_list
      { $1 :: $3 }
      
  stmt:
    | declaration SEMICOLON                {$1}
    | assignment SEMICOLON                 {$1}
    
  stmt_list:
    | { [] }
    | stmt stmt_list                 { $1 :: $2 }

  vec:
    | LPAREN expr COMMA expr RPAREN { Vec($2, $4) }
  
  expr:
      | INT                           { Int($1) }
      | vec                           { $1 }
      | IDENTIFIER                      { Var($1) }
      | LPAREN expr RPAREN            { $2 }
      | expr TIMES expr               { Binop($1, Mul, $3) }
      | expr DIV expr                 { Binop($1, Div, $3) }
      | expr PLUS expr                { Binop($1, Add, $3) }
      | expr MINUS expr               { Binop($1, Sub, $3) };
  
  declaration:
    | DEFTYPE IDENTIFIER EQUAL expr     { Declar($1, $2, $4)};

  assignment:
    | IDENTIFIER EQUAL expr             { Assign($1, $3) };
