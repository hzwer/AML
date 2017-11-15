type identifier = string

and identifiers = identifier list                                

and expr =
  | Int of int
  | Var of string
  | Vec of expr * expr
  | Binop of string * expr * expr

and stmt =
  | Expr of expr
  | Assign of string * expr
  | Declar of string * string * expr (*int a=1+2; 3 params are 'int', 'a', '1+2'*)
  | If of (expr * stmt_list)
  | IfElse of (expr * stmt_list * stmt_list)
            
and stmt_list = stmt list

and toplevel = 
  | Stmts of stmt_list
  | Agent of stmt_list * stmt_list
  | Function of (identifier * identifiers * stmt_list)

and t = toplevel list             
