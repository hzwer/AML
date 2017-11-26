#
# Pure OCaml, package from Opam, two directories
#

# - The -I flag introduces sub-directories
# - -use-ocamlfind is required to find packages (from Opam)
# - _tags file introduces packages, bin_annot flag for tool chain
# - using *.mll and *.mly are handled automatically

OCB_FLAGS = -use-ocamlfind             -I src -I lib # uses ocamlyacc
.PHONY: 	all clean byte native profile debug sanity test

OCB = ocamlbuild $(OCB_FLAGS)

all: native byte # profile debug

native: sanity
	$(OCB) main.native

clean:
	$(OCB) -clean

test: native
	./main.native ./example/loop.aml > ./example/loop.cpp
	diff ./example/std_loop.cpp ./example/loop.cpp

	./main.native ./example/agent.aml > ./example/agent.cpp
	diff ./example/std_agent.cpp ./example/agent.cpp

	./main.native ./example/variable.aml > ./example/variable.cpp
	diff ./example/std_variable.cpp ./example/variable.cpp

	./main.native ./example/calc.aml > ./example/calc.cpp
	diff ./example/std_calc.cpp ./example/calc.cpp
