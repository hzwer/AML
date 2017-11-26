open Ast

let init_val = function
  | Builtintype("int") -> Int(0)
  | Builtintype("string") -> String("")
  | Builtintype("double") -> Float(0.0)
  | Builtintype("bool") -> Bool(false)
  | Builtintype("Deg") -> Degree((1., 0.))
  | Builtintype("Vec") -> Vector((0., 0.))
  | other -> String("fault")
