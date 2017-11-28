type identifier = string
                
and ttype = string
                 
and leftvalue =
  | Identifier of identifier
  | Parameter of builtintype * identifier

and parameters = leftvalue list 
               
and builtintype =
  | Builtintype of ttype
                
and expr =
  | Bool of bool
  | Int of int
  | Float of float
  | String of string
  | Degree of expr * expr
  | Vector of expr * expr
  | Leftvalue of leftvalue
  | Unop of string * expr
  | Binop of string * expr * expr

and exprs = expr list           

and stmt =  
  | Assign of (leftvalue * expr)
            
and block =
  | Stmt of stmt
  | Expr of expr
  | Call of (identifier * parameters)
  | Println of exprs
  | If of (expr * block_list)
  | IfElse of (expr * block_list * block_list)
  | For of (stmt * expr * stmt * block_list)
  | Comment of string
  | Empty
            
and block_list = block list

and toplevel = 
  | Agent of block_list * block_list
  | Function of (identifier * parameters * block_list)

and t = toplevel list;;
