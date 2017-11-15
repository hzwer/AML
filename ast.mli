type identifier = string

and identifiers = identifier list
                 
and leftvalue =
  | Identifier of identifier                
                
and expr =
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Leftvalue of leftvalue
  | Vec of expr * expr
  | Binop of string * expr * expr
          
and stmt =
  | Expr of expr
  | Assign of (leftvalue * expr)
  | If of (expr * stmt_list)
  | IfElse of (expr * stmt_list * stmt_list)
  | For of (stmt * expr * stmt * stmt_list) 
            
and stmt_list = stmt list

and toplevel = 
  | Stmts of stmt_list
  | Agent of stmt_list * stmt_list
  | Function of (identifier * identifiers * stmt_list)

and t = toplevel list             
