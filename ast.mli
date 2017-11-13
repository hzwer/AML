type operator = Add | Sub | Mul | Div

and identifier = string

and identifiers = identifier list                                

and expr =
  | Int of int
  | Var of string
  | Vec of expr * expr
  | Binop of expr * operator * expr

and stmt =
  | Expr of expr
  | Assign of string * expr
  | Declar of string * string * expr (*int a=1+2; 3 params are 'int', 'a', '1+2'*)
            
and stmt_list = stmt list

and toplevel = 
  | Stmt of stmt
  | Agent of stmt_list * stmt_list
  | Function of (identifier * identifiers * stmt_list)

and t = toplevel list             
