type identifier = string
                
and ttype = string

and exprs = expr list
          
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
  | Angle of expr * expr
  | Vector of expr * expr
  | Leftvalue of leftvalue
  | Unop of string * expr
  | Binop of string * expr * expr
  | Call of (identifier * exprs)
  | Println of exprs

and stmt =  
  | Assign of (leftvalue * expr)
            
and block =
  | Stmt of stmt
  | Expr of expr
  | If of (expr * block_list)
  | IfElse of (expr * block_list * block_list)
  | For of (stmt * expr * stmt * block_list)
  | Comment of string
  | Empty
            
and block_list = block list

and toplevel = 
  | Agent of block_list * block_list
  | Function of (builtintype * identifier * exprs * block_list)

and t = toplevel list;;
