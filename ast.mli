type operator = Add | Sub | Mul | Div

type expr =
  | Binop of expr * operator * expr
  | Int of int
  | Vec of int * int
