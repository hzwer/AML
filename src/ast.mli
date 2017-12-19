type identifier = string               

and exprs = expr list

and stmts = stmt list          
                                         
and expr =
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Angle of expr
  | Vector of expr * expr
  | Identifier of identifier
  | Unop of string * expr
  | Binop of string * expr * expr
  | Call of (identifier * exprs)
  | Println of exprs
  | Read of exprs
  | Ternary of (expr * expr * expr)
  | Assign of (identifier * expr)

and stmt =
  | Stmts of stmts
  | Exprs of exprs
  | If of (expr * stmt)
  | IfElse of (expr * stmt * stmt)
  | For of (exprs * exprs * exprs * stmt)
  | Comment of string
  | Function of (identifier * identifier * exprs * stmt)
  | Empty
           
and toplevel = 
  | Agent of identifier * stmt
  | Stmt of stmt

and t = toplevel list;;
