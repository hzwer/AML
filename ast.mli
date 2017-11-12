type operator = Add | Sub | Mul | Div

type expr =
  | Int of int
  | Var of string
  | Vec of expr * expr
  | Binop of expr * operator * expr

type stmt = 
  | Expr of expr
  | Assign of string * expr
  | Declar of string * string * expr (*int a=1+2; 3 params are 'int', 'a', '1+2'*)

type stmt_list = 
  | Stmt of stmt
  | Multistmt of stmt * stmt_list

type agents = 
  | Agent of stmt_list * stmt_list
  | Multiagent of agents * agents

