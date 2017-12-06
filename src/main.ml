open Ast
open Printf
exception Invalid_input;;

let rec print_ind ind str= 
  if (ind > 0) then (printf("    "); print_ind (ind - 1) str)
  else printf "%s" str;;  
  
let rec print_leftvalue = function
  | Identifier(x) -> x;
  | TypeIdentifier(Builtintype(t), x) -> t ^ " " ^ x;;

let rec print_cout e =
  match e with
   | [] -> "\"\""
   | [x] -> exprs [x]
   | h :: t -> (exprs [h]) ^ " <<' '<< " ^ (print_cout t)
             
and exprs e =
  match e with
  | [] -> ""
  | [Int(a)] -> string_of_int(a)
  | [Bool(a)] -> string_of_bool(a)
  | [Float(a)] -> string_of_float(a)
  | [String(s)] -> s
  | [Angle(a, b)] -> "ang(" ^ (exprs [a]) ^ ", " ^ (exprs [b]) ^ ")"
  | [Vector(a, b)] -> "vec2f(" ^ (exprs [a]) ^ ", " ^ (exprs [b]) ^ ")"
  | [Leftvalue(a)] -> print_leftvalue a
  | [Binop(op, e1, e2)] ->
     "(" ^ (exprs [e1]) ^ " " ^ op ^ " " ^ (exprs [e2]) ^ ")"
  | [Unop(op, e)] ->
     op ^ (exprs [e])
  | [Call(identifier, identifiers)] ->
     identifier ^
       (
         if (identifier = "return") then (" " ^ (exprs identifiers))
         else ("(" ^ (exprs identifiers) ^ ")")
       )
  | [Println(exprs)] ->
     "cout << " ^ print_cout exprs ^ " << endl";
  | h :: t -> (exprs [h]) ^ ", " ^ (exprs t);;
  
let print_type = function 
  | Builtintype(a) -> a;;
  
let print_assign = function
  | Assign(a, e) -> printf "%s" ((print_leftvalue a) ^ " = " ^ (exprs [e]));
  | other -> printf "%s" "fault";;
              
let rec print_stmt ind = function
  | [] -> printf ""
  | [Empty] -> printf ";\n"
  | [Expr(e)] ->
     print_ind ind (exprs [e]);
     printf ";\n";
  | [Assign(a, e)] ->
     print_ind ind ((print_leftvalue a) ^ " = " ^ (exprs [e]));
     printf ";\n";     
  | [If(a, b)] ->
     print_ind ind "if";
     printf "(%s) " (exprs [a]);
     printf "{\n";
     print_stmt (ind + 1) [b];
     print_ind ind "}\n";
  | [IfElse(a, b, c)] ->
     print_stmt ind [If(a, b)];
     print_ind ind "else {\n";
     print_stmt (ind + 1) [c];
     print_ind ind "}\n";
  | [For(a, b, c, d)] ->
     print_ind ind "for(";
     print_assign a;
     printf "; ";
     printf "%s" (exprs [b]);
     printf "; ";
     print_assign c;
     printf ") {\n";
     print_stmt (ind + 1) [d];
     print_ind ind "}\n";
  | [Function(Builtintype(t), identifier, identifiers, stmt)] ->
     print_ind ind (t ^ " ");
     printf "%s" identifier;
     printf "(%s) " (exprs identifiers);
     printf("{\n");
     print_stmt (ind+1) [stmt];
     print_ind ind "}\n";
  | [Comment(s)] ->     
     print_ind ind ("/*" ^ s ^ "*/");
     printf "\n";     
  | [Stmts(x)] -> print_stmt ind x;
  | h :: t -> print_stmt ind [h];
              print_stmt ind t;;
 
let rec print_toplevel = function
  | Agent(identifier, stmt) ->
     printf "class _%s: public _Agent{\n" identifier;
     printf "public:\n";
     print_stmt 1 [stmt];
     printf("};\n");
  | Stmt(x) -> print_stmt 0 [x];;

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
       addlib "lib/header.ml";       
       if Array.length Sys.argv > 2 then addlib "lib/header-agent.ml";       
       let tokens = Lexing.from_channel (open_in file) in
       let t = Parser.main Lexer.token tokens in 
       print_t(t);
       
       (*addlib "lib/tail.ml";*)
