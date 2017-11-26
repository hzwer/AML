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
let rec print_ind ind str= 
  if (ind > 0) then (printf("    "); print_ind (ind - 1) str)
  else printf "%s" str;;
     
let rec print_idens = function
  | [] -> "";
  | [x] -> x;
  | h :: t -> h ^ ", " ^ (print_idens t);;

let rec print_leftvalue = function
  | Identifier(a) -> print_idens [a];;
  
let rec expr = function
  | Vec(a,b) -> 
      "vec2i(" ^ (expr a) ^ "," ^ (expr b) ^ ")";
  | Int(a) -> string_of_int(a);
  | Bool(a) -> string_of_bool(a);
  | Float(a) -> string_of_float(a);
  | String(a) -> "\"" ^ a ^ "\"";
  | Degree(a, b) -> "Deg(" ^ string_of_float(a) ^ ", " ^ string_of_float(b) ^ ")"
  | Vector(a, b) -> "Vec(" ^ string_of_float(a) ^ ", " ^ string_of_float(b) ^ ")"
  | Leftvalue(a) -> print_leftvalue a;
  | Binop(op, e1, e2) ->
     "(" ^ (expr e1) ^ " " ^ op ^ " " ^ (expr e2) ^ ")";;

let print_type = function 
  | Builtintype(a) -> a;;
  
let print_stmt = function
  | Assign(a, e) -> printf "%s" ((print_leftvalue a) ^ " = " ^ (expr e));
  | Declaration(t, a, e) -> printf "%s" ((print_type t) ^ " " ^ (print_leftvalue a) ^ " = " ^ (expr e));;
  
let rec print_block_list ind = function
  | [] -> printf("");
  | [Expr(e)] -> print_ind ind (expr e);
  | [Stmt(Assign(a, e))] ->
     print_ind ind ((print_leftvalue a) ^ " = " ^ (expr e));
     printf ";\n";     
  | [Stmt(Declaration(t, a, e))] ->
     print_ind ind ((print_type t) ^ " " ^ (print_leftvalue a) ^ " = " ^ (expr e));
     printf ";\n";
  | [If(a, b)] ->
     print_ind ind "if";
     printf "%s" (expr a);
     printf "{\n";
     print_block_list (ind + 1) b;
     print_ind ind "}";
  | [IfElse(a, b, c)] ->
     print_block_list ind [If(a, b)];
     printf "\n";
     print_ind ind "else{\n";
     print_block_list (ind + 1) c;
     print_ind ind "}\n";
  | [For(a, b, c, d)] ->
     print_ind ind "for(";
     print_stmt a;
     printf "; ";
     printf "%s" (expr b);
     printf "; ";
     print_stmt c;
     printf "){\n";
     print_block_list (ind + 1) d;
     print_ind ind "}\n";
  | [Call(identifier, identifiers)] ->
     print_ind ind identifier;
     printf "(%s)" (print_idens identifiers);
     printf ";\n";     
  | h :: t -> print_block_list ind [h];
              print_block_list ind t;;
 
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
  | Agent(init_list, step_list) ->
     printf("Agent{\nInit{\n");
     print_block_list 0 init_list;
     printf("}\nvoid Step(){\n");
     print_block_list 0 step_list;
     printf("}\n};\n");
  | Function(identifier, identifiers, block_list) ->
     print_ind 0 "void ";
     printf "%s" identifier;
     printf "(%s)" (print_idens identifiers);
     printf("{\n");
     print_block_list 1 block_list;
     printf("}\n");;

let rec print_t = function
  | [] -> printf("")
  | [x] -> print_toplevel x;
  | h :: t -> print_toplevel h;
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
  if Array.length Sys.argv = 1 then printf "Expect ./main.native [file]\n"
  else let file = Sys.argv.(1) in
  
       printf "/*produced by AML*/\n";
       (*addlib "lib/header.ml";*)
       
       let lexbuf = read_all file in 
       let tokens = Lexing.from_string lexbuf in
       let t = Parser.main Lexer.token tokens in 
       print_t(t);
       
       (*addlib "lib/tail.ml";*)
