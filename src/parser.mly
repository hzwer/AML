%{ open Ast %}
%token AGENT
%token INIT
%token STEP
%token <float> FLOAT
%token <string> STRING
%token <string> IDENTIFIER
%token <int> INT
%token <bool> BOOL
%token TINT
%token TDOUBLE
%token TSTRING
%token TBOOL
%token TDEGREE
%token TVECTOR
%token true
%token false
%token IF
%token ELSE
%token FOR
%token MOD
%token PRINTLN
%token PLUS MINUS TIMES DIV
%token LPAREN RPAREN
%token NOT
%token SEQ
%token SNE
%token EQUAL
%token EOL
%token EOF
%token COMMA
%token FUNC
%token SEMICOLON
%token LBRACE RBRACE
%token AND
%token OR
%token BINAND
%token BINXOR
%token BINOR
%token GT
%token LT
%token GE
%token LE

%left AND OR
%left BINAND BINXOR BINOR
%nonassoc SEQ SNE
%nonassoc GT LT GE LE
%left PLUS MINUS
%left DIV TIMES MOD
%nonassoc IF
%nonassoc ELSE

%start main
%type <Ast.t> main
                               
%%
  main:
    toplevel_list EOF               { $1 }

  toplevel:
    | FUNC IDENTIFIER LPAREN identifier_list RPAREN
      LBRACE block_list RBRACE
      { Function($2, $4, $7) }
    | AGENT LBRACE init step RBRACE { Agent($3, $4) }
    
  toplevel_list:
    | { [] }
    | toplevel toplevel_list      { $1 :: $2 }

  init:
    | INIT LBRACE block_list RBRACE    { $3 }
  
  step:
    | STEP LBRACE block_list RBRACE   { $3 }
    
  identifier_list:
    | { [] }
    | IDENTIFIER                         { [$1] }
    | IDENTIFIER COMMA identifier_list   { $1 :: $3 }
    
  expr:
    | INT                           { Int($1) }
    | BOOL                          { Bool($1) }
    | STRING                        { String($1) }
    | FLOAT                         { Float($1) }
    | vec                           { $1 }
    | leftvalue                     { Leftvalue($1) }
    | LPAREN expr RPAREN            { $2 }
    | binary_op                     { $1 }
    | unary_op                      { $1 }

  expr_list:
    | { [] }
    | expr                          { [$1] }
    | expr COMMA expr_list          { $1 :: $3 }
      
    
  for_stmt:
    | FOR LPAREN assignment SEMICOLON expr SEMICOLON assignment RPAREN
    LBRACE block_list RBRACE
          { For($3, $5, $7, $10) }

  call_stmt:
    | IDENTIFIER LPAREN identifier_list RPAREN { Call($1, $3) }
    | PRINTLN LPAREN expr_list RPAREN { Println($3) }
      
  if_stmt:
    | IF LPAREN expr RPAREN LBRACE block_list RBRACE
         { If($3, $6) }
    | IF LPAREN expr RPAREN
         LBRACE block_list RBRACE
         ELSE LBRACE block_list RBRACE
         { IfElse($3, $6, $10) }
    
  stmt:
    | call_stmt SEMICOLON                  { $1 }
    | if_stmt                              { $1 }
    | for_stmt                             { $1 }
    | assignment SEMICOLON                 { Stmt($1) }
    | declaration SEMICOLON                { Stmt($1) }
    
  block_list:
    | { [] }
    | stmt block_list                 { $1 :: $2 }
    
  vec:
    | LPAREN expr COMMA expr RPAREN { Vec($2, $4) }

  builtintype:
    | TINT                          { Builtintype("int") }
    | TDOUBLE                       { Builtintype("double") }
    | TSTRING                       { Builtintype("string") }
    | TBOOL                         { Builtintype("bool") }
    | TDEGREE                       { Builtintype("Deg") }
    | TVECTOR                       { Builtintype("Vec") }

  unary_op:
    | NOT expr                      { Unop ("!", $2) }
    
  binary_op:
    | expr TIMES expr               { Binop("*", $1, $3) }
    | expr DIV expr                 { Binop("/", $1, $3) }
    | expr PLUS expr                { Binop("+", $1, $3) }
    | expr MINUS expr               { Binop("-", $1, $3) }
    | expr MOD expr                 { Binop("%", $1, $3) }
    | expr GT expr                  { Binop(">", $1, $3) }
    | expr LT expr                  { Binop("<", $1, $3) }
    | expr GE expr                  { Binop(">=", $1, $3) }
    | expr LE expr                  { Binop("<=", $1, $3) }
    | expr SEQ expr                 { Binop("==", $1, $3) }
    | expr SNE expr                 { Binop("!=", $1, $3) }
    | expr AND expr                 { Binop("&&", $1, $3) }
    | expr OR expr                  { Binop("||", $1, $3) }
    | expr BINAND expr              { Binop("&", $1, $3) }
    | expr BINOR expr               { Binop("|", $1, $3) }
    | expr BINXOR expr              { Binop("^", $1, $3) }
    
  declaration:
      | builtintype leftvalue EQUAL expr        { Declaration($1, $2, $4) }
      | TINT leftvalue                        { Declaration(Builtintype("int"), $2, Int(0)) }
      | TDOUBLE leftvalue                        { Declaration(Builtintype("double"), $2, Float(0.0)) }
      | TSTRING leftvalue                        { Declaration(Builtintype("string"), $2, String("")) }
      | TBOOL leftvalue                        { Declaration(Builtintype("bool"), $2, Bool(false)) }
      | TDEGREE leftvalue                        { Declaration(Builtintype("Deg"), $2, Degree((1., 0.))) }
      | TVECTOR leftvalue                        { Declaration(Builtintype("Vec"), $2, Vector((0., 0.))) }
    
  assignment:
      | leftvalue EQUAL expr             { Assign($1, $3) }    

  leftvalue:
      | IDENTIFIER                       { Identifier($1) }
