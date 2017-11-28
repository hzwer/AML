open Ast

let init_val = function
  | Builtintype("int") -> Int(0)
  | Builtintype("string") -> String("\"\"")
  | Builtintype("double") -> Float(0.0)
  | Builtintype("bool") -> Bool(false)
  | Builtintype("Ang") -> Angle(Float(1.), Float(0.))
  | Builtintype("Vec") -> Vector(Float(0.), Float(0.))
  | other -> String("fault")
