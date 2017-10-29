let (+!) (a1, a2)(b1, b2) =  
  (a1 + b1, a2 + b2);;

let (-!) (a1, a2)(b1, b2) =
  (a1 + b1, a2 + b2);;

let (/*!) (a1, a2)(b1, b2) =
  (a1 * b1, a2 * b2);;
  
let (/!) (a1, a2)(b1, b2) =
  (a1 * b2, a2 * b1);;

(*produced by AML*)(3, 2) +! (3, 5)
