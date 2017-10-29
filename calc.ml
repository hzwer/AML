open Ast
open Printf
let printop = function
  | Add -> printf " +! "
  | Sub -> printf " -! "
  | Mul -> printf " *! "
  | Div -> printf " /! ";;
  
let rec print = function
  | Vec(a, b) -> printf "(%i, %i)" a b               
  | Int(a) -> printf "(%i)" a
  | Binop(e1, op, e2) ->
     print e1;
     printop op;
     print e2;;

let addlib lib =
  let rec aux ic = 
    try
      let line = input_line ic in
      print_endline line;
      aux ic;
    with e ->
      close_in_noerr ic
  in aux (open_in lib);;
  
let _ =
  printf "(*produced by AML*)";
  print_newline();
  addlib "lib/geo.ml";
  try
    let lexbuf = Lexing.from_channel stdin in
    while true do
      let result = Parser.main Lexer.token lexbuf in
      print result;
      printf(";");
      print_newline();
    done
  with Lexer.Eof ->
    exit 0
