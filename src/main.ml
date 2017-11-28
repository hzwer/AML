open Ast
open Printf
exception Invalid_input;;

let rec print_ind ind str= 
  if (ind > 0) then (printf("    "); print_ind (ind - 1) str)
  else printf "%s" str;;  
  
let rec print_leftvalue = function
  | Identifier(x) -> x;
  | TypeIdentifier(Builtintype(t), x) -> t ^ " " ^ x;;
  
let rec expr = function
  | Int(a) -> string_of_int(a);
  | Bool(a) -> string_of_bool(a);
  | Float(a) -> string_of_float(a);
  | String(s) -> s;
  | Angle(a, b) -> "ang(" ^ (expr a) ^ ", " ^ (expr b) ^ ")"
  | Vector(a, b) -> "vec(" ^ (expr a) ^ ", " ^ (expr b) ^ ")"
  | Leftvalue(a) -> print_leftvalue a;
  | Binop(op, e1, e2) ->
     "(" ^ (expr e1) ^ " " ^ op ^ " " ^ (expr e2) ^ ")";
  | Unop(op, e) ->
     op ^ (expr e);;
  
let rec exprs = function
  | [] -> ""
  | [x] -> expr x;
  | h :: t -> (expr h) ^ (exprs t);;

let print_type = function 
  | Builtintype(a) -> a;;
  
let print_stmt = function
  | Assign(a, e) -> printf "%s" ((print_leftvalue a) ^ " = " ^ (expr e));;

let rec print_cout = function
  | [] -> "\"\""
  | [e] -> expr e;
  | h :: t -> (expr h) ^ " <<' '<< " ^ (print_cout t);;
              
let rec print_block_list ind = function
  | [] -> printf("");
  | [Expr(e)] -> print_ind ind (expr e);
  | [Stmt(Assign(a, e))] ->
     print_ind ind ((print_leftvalue a) ^ " = " ^ (expr e));
     printf ";\n";     
  | [If(a, b)] ->
     print_ind ind "if";
     printf "(%s) " (expr a);
     printf "{\n";
     print_block_list (ind + 1) b;
     print_ind ind "}\n";
  | [IfElse(a, b, c)] ->
     print_block_list ind [If(a, b)];
     print_ind ind "else {\n";
     print_block_list (ind + 1) c;
     print_ind ind "}\n";
  | [For(a, b, c, d)] ->
     print_ind ind "for(";
     print_stmt a;
     printf "; ";
     printf "%s" (expr b);
     printf "; ";
     print_stmt c;
     printf ") {\n";
     print_block_list (ind + 1) d;
     print_ind ind "}\n";
  | [Call(identifier, identifiers)] ->
     print_ind ind identifier;
     if (identifier = "return") then (printf " %s" (exprs identifiers))
     else (printf "(%s)" (exprs identifiers));
     printf ";\n";
  | [Println(expr)] ->     
     print_ind ind ("cout << " ^ print_cout expr ^ " << endl");
     printf ";\n";
  | [Comment(s)] ->     
     print_ind ind ("/*" ^ s ^ "*/");
     printf "\n";
  | h :: t -> print_block_list ind [h];
              print_block_list ind t;;
 
let rec print_toplevel = function
  | Agent(init_list, step_list) ->
     printf("Agent{\nInit{\n");
     print_block_list 0 init_list;
     printf("}\nvoid Step() {\n");
     print_block_list 0 step_list;
     printf("}\n};\n");
  | Function(Builtintype(t), identifier, identifiers, block_list) ->
     print_ind 0 t;
     printf " %s" identifier;
     printf "(%s) " (exprs identifiers);
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
       addlib "lib/header.ml";
       
       let tokens = Lexing.from_channel (open_in file) in
       let t = Parser.main Lexer.token tokens in 
       print_t(t);
       
       (*addlib "lib/tail.ml";*)
