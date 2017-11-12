%{ open Ast %}
%token AGENT
%token INIT
%token STEP
%token <string> VARIABLE
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
%token SEMICOLON
%token LBRACE RBRACE
%left PLUS MINUS
%left DIV TIMES

%start main
%type <Ast.agents> main
                               
%%
  main:
    | def_agent                  {$1};
    | def_agent main           {Multiagent($1, $2)}

  def_agent:
    | AGENT LBRACE init step RBRACE SEMICOLON {Agent($3, $4)};
  init:
    | INIT LBRACE block RBRACE   {$3};
  step:
    | STEP LBRACE block RBRACE   {$3};
  stmt:
    | expr SEMICOLON                       {Expr($1)}
    | declaration SEMICOLON                {$1}
    | assignment SEMICOLON                 {$1}
  block:
    | stmt                       {Stmt($1)}
    | stmt block                 {Multistmt($1,$2)}

  vec:
    | LPAREN expr COMMA expr RPAREN { Vec($2, $4) };
  
  expr:
      | INT                           { Int($1) }
      | vec                           { $1 }
      | VARIABLE                      { Var($1) }
      | LPAREN expr RPAREN            { $2 }
      | expr TIMES expr               { Binop($1, Mul, $3) }
      | expr DIV expr                 { Binop($1, Div, $3) }
      | expr PLUS expr                { Binop($1, Add, $3) }
      | expr MINUS expr               { Binop($1, Sub, $3) };
  declaration:
    | DEFTYPE VARIABLE EQUAL expr     { Declar($1,$2,$4)};

  assignment:
    | VARIABLE EQUAL expr             { Assign($1, $3) };
