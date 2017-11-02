type operator = Add | Sub | Mul | Div

type expr =
  | Int of int
  | Var of string
  | Vec of expr * expr
  | Binop of expr * operator * expr
  | Assign of string * expr

type expr_list = 
  | Expr of expr
  | Multiexpr of expr * expr_list
