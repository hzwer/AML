build:
	ocamllex lexer.mll       # generates lexer.ml
	ocamlyacc parser.mly     # generates parser.ml and parser.mli
	ocamlc -c ast.mli
	ocamlc -c parser.mli
	ocamlc -c lexer.ml
	ocamlc -c parser.ml
	ocamlc -c calc.ml
	ocamlc -o calc lexer.cmo parser.cmo calc.cmo
