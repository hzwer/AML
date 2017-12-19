type identifier = string
                
and ttype = string

and exprs = expr list

and stmts = stmt list          
          
and leftvalue =
  | Identifier of identifier
  | TypeIdentifier of builtintype * identifier
               
and builtintype =
  | Builtintype of ttype
                
and expr =
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Angle of expr
  | Vector of expr * expr
  | Leftvalue of leftvalue
  | Unop of string * expr
  | Binop of string * expr * expr
  | Call of (identifier * exprs)
  | Println of exprs
  | Read of exprs
  | Assign of (leftvalue * expr)

and stmt =
  | Stmts of stmts
  | Expr of expr
  | If of (expr * stmt)
  | IfElse of (expr * stmt * stmt)
  | For of (expr * expr * expr * stmt)
  | Comment of string
  | Function of (builtintype * identifier * exprs * stmt)
  | Empty
           
and toplevel = 
  | Agent of identifier * stmt
  | Stmt of stmt

and t = toplevel list;;
