open Ast
open Printf
exception Invalid_input;;

(*let printval = function
  | Int(a) -> printf "%i" a
  | Vec(a,b) -> printf "(%i,%i)" a b
  | Binop(e1,op,e2) -> raise Invalid_input;;


let vec_vec_calc x1 y1 op x2 y2 =
  match op with
  | Add -> Vec(x1+x2,y1+y2)
  | Sub -> Vec(x1-x2,y1-y2)
  | Mul -> Int(x1*x2+y1*y2)
  | Div -> raise Invalid_input;;

let vec_int_calc x1 y1 op a = 
  match op with
  | Mul -> Vec(x1*a, y1*a)
  | Div -> Vec(x1/a, y1/a)
  | Add -> raise Invalid_input
  | Sub -> raise Invalid_input;;

let int_int_calc a op b = 
  match op with
  | Add -> Int(a+b)
  | Sub -> Int(a-b)
  | Mul -> Int(a*b)
  | Div -> Int(a/b);;

*)
(*let rec print = function
  | Vec(a, b) -> printf "(%i,%i)" a b 
  (*| Vec(a,b) -> (a*b)*)
  | Int(a) -> printf "(%i)" a 
  | Binop(e1, op, e2) ->
     print e1;
     printop op;
     print e2;;
 *)

let rec print_idens = function
  | [] -> printf ",";
  | [x] -> printf "%s" x;
  | h :: t -> printf "%s, " h;
              print_idens t;;

let rec print_leftvalue = function
  | Identifier(a) -> print_idens [a];;
  
let rec print_expr = function
  | Vec(a,b) -> 
      printf "vec2i(";
      print_expr a;
      printf ",";
      print_expr b;
      printf ")";
  | Int(a) -> printf "%i" a;
  | Bool(a) -> printf "%b" a;
  | Float(a) -> printf "%f" a;
  | String(a) -> printf "%s" a;
  | Leftvalue(a) -> print_leftvalue a;
  | Binop(op, e1, e2) ->
     printf ("(");
     print_expr e1;
     printf " %s " op;
     print_expr e2;
     printf (")");;

let rec print_stmt_list = function
  | [] -> printf("")
  | [Expr(e)] -> print_expr e;
                 printf("\n");
  | [Assign(a, e1)] ->
      print_leftvalue a;
      printf " = ";
      print_expr e1;
      printf ";";
      printf("\n");
  | [If(a, b)] ->
      printf "if";
      print_expr a;
      printf "{\n";
      print_stmt_list b;
      printf "}\n";
  | [IfElse(a, b, c)] ->
     print_stmt_list [If(a, b)];
     printf "else{\n";
     print_stmt_list c;
     printf "}\n";
  | h :: t -> print_stmt_list [h];
              print_stmt_list t;;
            
            
 
(*
let rec geo_calc expr =
  match expr with
  | Vec(a, b) -> Vec(a, b)
  | Int(a) -> Int(a)
  | Binop(e1, op, e2) -> 
      match e1 with
      | Vec(a,b) ->  
          (
          match e2 with
          | Vec(c,d) -> vec_vec_calc a b op c d
          | Int(c) -> vec_int_calc a b op c
          | Binop(c, q, d) -> geo_calc(Binop(e1, op, geo_calc(e2)))
          )
      | Int(a) ->
          (
          match e2 with
          | Vec(c,d) -> vec_int_calc c d op a
          | Int(c) -> int_int_calc a op c
          | Binop(c,q,d) -> geo_calc(Binop(e1, op, geo_calc(e2)))
          )
      | Binop(a,q,b) ->
          let r1 = geo_calc(e1) in
          geo_calc(Binop(r1,op,e2));;
*)

let rec print_toplevel = function
  | Stmts(e) ->
     printf("{\n");
     print_stmt_list e;
     printf("}\n");
  | Agent(init_list, step_list) ->
      printf("Agent{\nInit{\n");
      print_stmt_list init_list;
      printf("}\nvoid Step(){\n");
      print_stmt_list step_list;
      printf("}\n};\n");
  | Function(identifier, identifiers, stmt_list) ->
     printf("void ");
     printf "%s" identifier;
     printf("(");
     print_idens identifiers;
     printf("){\n");
     print_stmt_list stmt_list;
     printf("}\n");;

let rec print_t = function
  | [] -> printf("")
  | [x] -> print_toplevel(x);
  | h :: t -> print_toplevel(h);
              print_t(t);;

let addlib lib =
  let rec aux ic = 
    try
      let line = input_line ic in
      print_endline line;
      aux ic;
    with e ->
      close_in_noerr ic
  in aux (open_in lib);;

let read_all file = 
  let rec aux ic = 
    try
      let line = input_line ic in
      (line^(aux ic));
    with e -> 
      close_in_noerr ic;
      "";
  in aux (open_in file);;

let _ =
  printf "/*produced by AML*/";
  print_newline();
  (*addlib "lib/header.ml";*)
  let lexbuf = read_all "./example/test.aml" in 
  let tokens = Lexing.from_string lexbuf in
  let t = Parser.main Lexer.token tokens in 
  print_t(t);
  (*addlib "lib/tail.ml";*)
