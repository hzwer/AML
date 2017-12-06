open Ast
open Printf
open Pre
   
exception Invalid_input;;

let rec print_ind ind str= 
  if (ind > 0) then (("    ") ^ (print_ind (ind - 1) str))
  else str;;  
  
let rec print_leftvalue = function
  | Identifier(x) -> x;
  | TypeIdentifier(Builtintype(t), x) -> t ^ " " ^ x;;

let rec print_stmt ind e =
  match e with
  | [] -> ""
  | [Empty] -> ";\n"
             
  | [Expr(Call("register", identifiers))] ->
     (print_stmt ind [register identifiers])

  | [Expr(Call("plotvec2f", identifiers))] ->
     (print_stmt ind [Expr(Call("_AML_Vertex2f", identifiers))])
    
  | [Function(t, "project", identifiers, stmt)] ->
     print_stmt ind [pre_main(Function(t, "main", identifiers, stmt))]

  | [Expr(String(s))] ->
     (print_ind ind (exprs [String(s)]))
     ^ "\n"    
  | [Expr(e)] ->
     (print_ind ind (exprs [e]))
     ^ ";\n"
  | [Assign(a, e)] ->
     (print_ind ind ((print_leftvalue a) ^ " = " ^ (exprs [e])))
     ^ ";\n"
  | [If(a, b)] ->
     (print_ind ind "if") 
     ^ "(" ^ (exprs [a]) ^ ")"
     ^ " {\n"
     ^ (print_stmt (ind + 1) [b])
     ^ (print_ind ind "}\n")
  | [IfElse(a, b, c)] ->
     (print_stmt ind [If(a, b)])
     ^ (print_ind ind "else {\n")
     ^ (print_stmt (ind + 1) [c])
     ^ (print_ind ind "}\n")
  | [For(a, b, c, d)] ->
     (print_ind ind "for(")
     ^ (print_assign a)
     ^ "; "
     ^ (exprs [b])
     ^ "; "
     ^ (print_assign c)
     ^ ") {\n"
     ^ (print_stmt (ind + 1) [d])
     ^ (print_ind ind "}\n")
  | [Function(Builtintype(t), identifier, identifiers, stmt)] ->
     if identifier = "__main__" then ((print_ind ind (t ^ " "))
                                           ^ "main"
                                           ^ "(" ^ (exprs identifiers) ^ ")"
                                           ^ " {\n"
                                           ^ (print_stmt (ind+1) [stmt])
                                           ^ (print_ind ind "}\n")
                                          )
     else (
       (* if identifier = "__main__" then identifier = "main"; *)
       ((print_ind ind (t ^ " "))
        ^ identifier
        ^ "(" ^ (exprs identifiers) ^ ")"
        ^ " {\n"
        ^ (print_stmt (ind+1) [stmt])
        ^ (print_ind ind "}\n")
       )
     )
  | [Comment(s)] ->     
     (print_ind ind ("/*" ^ s ^ "*/"))
     ^ "\n"
  | [Stmts(x)] -> print_stmt ind x;
  | h :: t -> (print_stmt ind [h])
              ^ (print_stmt ind t)            
  
and print_cout e =
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
     "(" ^ op ^ (exprs [e]) ^ ")"
  | [Call(identifier, identifiers)] ->
     (identifier ^
        (
          if (identifier = "return") then (" " ^ (exprs identifiers))
          else ("(" ^ (exprs identifiers) ^ ")")
     ))          
  | [Println(exprs)] ->
     "cout << " ^ print_cout exprs ^ " << endl"
  | h :: t -> (exprs [h]) ^ ", " ^ (exprs t)
  
and print_type e = 
  match e with
  | Builtintype(a) -> a
  
and print_assign e =
  match e with
  | Assign(a, e) -> (print_leftvalue a) ^ " = " ^ (exprs [e])
  | other -> "fault";;             
 
let rec print_toplevel = function
  | Agent(identifier, stmt) ->
     printf "class _%s: public _Agent{\n" identifier;
     printf "public:\n";
     printf "%s" (print_stmt 1 [stmt]);
     printf("};\n");
  | Stmt(x) -> printf "%s" (print_stmt 0 [x]);;

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
