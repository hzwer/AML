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

open Parsing;;
let _ = parse_error;;
# 1 "parser.mly"
 open Ast 
# 32 "parser.ml"
let yytransl_const = [|
  257 (* AGENT *);
  258 (* INIT *);
  259 (* STEP *);
  263 (* IF *);
  264 (* ELSE *);
  265 (* DEFINT *);
  266 (* DEFVEC2I *);
  267 (* PLUS *);
  268 (* MINUS *);
  269 (* TIMES *);
  270 (* DIV *);
  271 (* LPAREN *);
  272 (* RPAREN *);
  273 (* EQUAL *);
  274 (* EOL *);
    0 (* EOF *);
  275 (* COMMA *);
  276 (* FUNC *);
  277 (* SEMICOLON *);
  278 (* LBRACE *);
  279 (* RBRACE *);
    0|]

let yytransl_block = [|
  260 (* IDENTIFIER *);
  261 (* DEFTYPE *);
  262 (* INT *);
    0|]

let yylhs = "\255\255\
\001\000\003\000\003\000\003\000\003\000\002\000\002\000\006\000\
\007\000\005\000\005\000\005\000\008\000\008\000\010\000\010\000\
\010\000\004\000\004\000\013\000\009\000\009\000\009\000\009\000\
\009\000\009\000\009\000\009\000\011\000\012\000\000\000"

let yylen = "\002\000\
\002\000\001\000\003\000\008\000\005\000\000\000\002\000\004\000\
\004\000\000\000\001\000\003\000\007\000\011\000\001\000\002\000\
\002\000\000\000\002\000\005\000\001\000\001\000\001\000\003\000\
\003\000\003\000\003\000\003\000\004\000\003\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\031\000\000\000\000\000\002\000\015\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\001\000\007\000\
\019\000\016\000\017\000\000\000\000\000\023\000\021\000\000\000\
\000\000\022\000\000\000\000\000\000\000\003\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\005\000\024\000\000\000\000\000\
\000\000\025\000\026\000\000\000\000\000\000\000\008\000\000\000\
\000\000\000\000\012\000\000\000\009\000\020\000\000\000\000\000\
\000\000\004\000\000\000\000\000\014\000"

let yydgoto = "\002\000\
\009\000\010\000\011\000\012\000\050\000\029\000\041\000\013\000\
\033\000\014\000\015\000\016\000\034\000"

let yysindex = "\004\000\
\009\255\000\000\245\254\000\255\028\255\019\255\035\255\023\255\
\000\000\036\000\009\255\000\000\000\000\023\255\020\255\029\255\
\038\255\003\255\042\255\003\255\034\255\041\255\000\000\000\000\
\000\000\000\000\000\000\030\255\058\255\000\000\000\000\003\255\
\008\255\000\000\003\255\054\255\071\255\000\000\023\255\055\255\
\056\255\044\255\003\255\003\255\003\255\003\255\008\255\059\255\
\061\255\062\255\063\255\023\255\000\000\000\000\003\255\246\254\
\246\254\000\000\000\000\023\255\071\255\065\255\000\000\066\255\
\060\255\067\255\000\000\023\255\000\000\000\000\074\255\068\255\
\070\255\000\000\023\255\072\255\000\000"

let yyrindex = "\000\000\
\083\000\000\000\000\000\000\000\000\000\000\000\000\000\073\255\
\000\000\000\000\083\000\000\000\000\000\006\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\064\255\000\000\000\000\000\000\077\255\000\000\073\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\076\255\000\000\
\078\255\000\000\000\000\073\255\000\000\000\000\000\000\026\255\
\032\255\000\000\000\000\073\255\077\255\000\000\000\000\000\000\
\000\000\000\000\000\000\073\255\000\000\000\000\001\000\000\000\
\000\000\000\000\073\255\000\000\000\000"

let yygindex = "\000\000\
\000\000\073\000\000\000\250\255\027\000\000\000\000\000\000\000\
\236\255\000\000\000\000\000\000\000\000"

let yytablesize = 285
let yytable = "\036\000\
\013\000\022\000\045\000\046\000\001\000\018\000\030\000\025\000\
\031\000\003\000\017\000\042\000\004\000\005\000\047\000\006\000\
\018\000\032\000\043\000\044\000\045\000\046\000\056\000\057\000\
\058\000\059\000\004\000\005\000\007\000\006\000\008\000\019\000\
\051\000\020\000\065\000\023\000\027\000\027\000\021\000\028\000\
\026\000\027\000\028\000\028\000\027\000\064\000\027\000\028\000\
\037\000\027\000\028\000\039\000\028\000\066\000\043\000\044\000\
\045\000\046\000\035\000\054\000\040\000\072\000\055\000\038\000\
\043\000\044\000\045\000\046\000\076\000\048\000\043\000\044\000\
\045\000\046\000\049\000\070\000\052\000\062\000\053\000\061\000\
\060\000\073\000\006\000\024\000\030\000\063\000\068\000\067\000\
\069\000\071\000\074\000\075\000\010\000\011\000\077\000\018\000\
\029\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\013\000\000\000\000\000\013\000\013\000\018\000\013\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\013\000\000\000\013\000\013\000\
\000\000\018\000\000\000\018\000\018\000"

let yycheck = "\020\000\
\000\000\008\000\013\001\014\001\001\000\000\000\004\001\014\000\
\006\001\001\001\022\001\032\000\004\001\005\001\035\000\007\001\
\017\001\015\001\011\001\012\001\013\001\014\001\043\000\044\000\
\045\000\046\000\004\001\005\001\020\001\007\001\022\001\004\001\
\039\000\015\001\055\000\000\000\011\001\012\001\004\001\002\001\
\021\001\016\001\011\001\012\001\019\001\052\000\021\001\016\001\
\015\001\021\001\019\001\022\001\021\001\060\000\011\001\012\001\
\013\001\014\001\017\001\016\001\003\001\068\000\019\001\023\001\
\011\001\012\001\013\001\014\001\075\000\016\001\011\001\012\001\
\013\001\014\001\004\001\016\001\022\001\016\001\023\001\019\001\
\022\001\008\001\000\000\011\000\021\001\023\001\022\001\061\000\
\023\001\023\001\023\001\022\001\016\001\016\001\023\001\023\001\
\021\001\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\001\001\255\255\255\255\004\001\005\001\001\001\007\001\
\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\255\
\255\255\255\255\255\255\255\255\020\001\255\255\022\001\023\001\
\255\255\020\001\255\255\022\001\023\001"

let yynames_const = "\
  AGENT\000\
  INIT\000\
  STEP\000\
  IF\000\
  ELSE\000\
  DEFINT\000\
  DEFVEC2I\000\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  DIV\000\
  LPAREN\000\
  RPAREN\000\
  EQUAL\000\
  EOL\000\
  EOF\000\
  COMMA\000\
  FUNC\000\
  SEMICOLON\000\
  LBRACE\000\
  RBRACE\000\
  "

let yynames_block = "\
  IDENTIFIER\000\
  DEFTYPE\000\
  INT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'toplevel_list) in
    Obj.repr(
# 30 "parser.mly"
                                    ( _1 )
# 233 "parser.ml"
               : Ast.t))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 33 "parser.mly"
                ( Stmts _1 )
# 240 "parser.ml"
               : 'toplevel))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 34 "parser.mly"
                              ( Stmts _2 )
# 247 "parser.ml"
               : 'toplevel))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 6 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 4 : 'identifier_list) in
    let _7 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 37 "parser.mly"
      ( Function(_2, _4, _7) )
# 256 "parser.ml"
               : 'toplevel))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 2 : 'init) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'step) in
    Obj.repr(
# 38 "parser.mly"
                                    ( Agent(_3, _4) )
# 264 "parser.ml"
               : 'toplevel))
; (fun __caml_parser_env ->
    Obj.repr(
# 41 "parser.mly"
      ( [] )
# 270 "parser.ml"
               : 'toplevel_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'toplevel) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'toplevel_list) in
    Obj.repr(
# 42 "parser.mly"
                                  ( _1 :: _2 )
# 278 "parser.ml"
               : 'toplevel_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 45 "parser.mly"
                                      ( _3 )
# 285 "parser.ml"
               : 'init))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 48 "parser.mly"
                                     ( _3 )
# 292 "parser.ml"
               : 'step))
; (fun __caml_parser_env ->
    Obj.repr(
# 51 "parser.mly"
      ( [] )
# 298 "parser.ml"
               : 'identifier_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 53 "parser.mly"
      ( [_1] )
# 305 "parser.ml"
               : 'identifier_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'identifier_list) in
    Obj.repr(
# 55 "parser.mly"
      ( _1 :: _3 )
# 313 "parser.ml"
               : 'identifier_list))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 59 "parser.mly"
         ( If(_3, _6) )
# 321 "parser.ml"
               : 'if_stmt))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 8 : 'expr) in
    let _6 = (Parsing.peek_val __caml_parser_env 5 : 'stmt_list) in
    let _10 = (Parsing.peek_val __caml_parser_env 1 : 'stmt_list) in
    Obj.repr(
# 63 "parser.mly"
         ( IfElse(_3, _6, _10) )
# 330 "parser.ml"
               : 'if_stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'if_stmt) in
    Obj.repr(
# 66 "parser.mly"
                                           ( _1 )
# 337 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'declaration) in
    Obj.repr(
# 67 "parser.mly"
                                           ( _1 )
# 344 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'assignment) in
    Obj.repr(
# 68 "parser.mly"
                                           ( _1 )
# 351 "parser.ml"
               : 'stmt))
; (fun __caml_parser_env ->
    Obj.repr(
# 71 "parser.mly"
      ( [] )
# 357 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'stmt) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'stmt_list) in
    Obj.repr(
# 72 "parser.mly"
                                     ( _1 :: _2 )
# 365 "parser.ml"
               : 'stmt_list))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : 'expr) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 75 "parser.mly"
                                    ( Vec(_2, _4) )
# 373 "parser.ml"
               : 'vec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 78 "parser.mly"
                                      ( Int(_1) )
# 380 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'vec) in
    Obj.repr(
# 79 "parser.mly"
                                      ( _1 )
# 387 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 80 "parser.mly"
                                        ( Var(_1) )
# 394 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'expr) in
    Obj.repr(
# 81 "parser.mly"
                                      ( _2 )
# 401 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 82 "parser.mly"
                                      ( Binop(_1, Mul, _3) )
# 409 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 83 "parser.mly"
                                      ( Binop(_1, Div, _3) )
# 417 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 84 "parser.mly"
                                      ( Binop(_1, Add, _3) )
# 425 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'expr) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 85 "parser.mly"
                                      ( Binop(_1, Sub, _3) )
# 433 "parser.ml"
               : 'expr))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 88 "parser.mly"
                                        ( Declar(_1, _2, _4))
# 442 "parser.ml"
               : 'declaration))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'expr) in
    Obj.repr(
# 91 "parser.mly"
                                        ( Assign(_1, _3) )
# 450 "parser.ml"
               : 'assignment))
(* Entry main *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let main (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.t)
