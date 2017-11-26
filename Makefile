#
# Pure OCaml, package from Opam, two directories
#

# - The -I flag introduces sub-directories
# - -use-ocamlfind is required to find packages (from Opam)
# - _tags file introduces packages, bin_annot flag for tool chain
# - using *.mll and *.mly are handled automatically

OCB_FLAGS = -use-ocamlfind -I src -I lib # uses ocamlyacc
.PHONY: all clean byte native profile debug sanity test

OCB = ocamlbuild $(OCB_FLAGS)

all: native byte # profile debug

native: sanity
	$(OCB)main.native

clean:
	$(OCB)-clean

test: native
	python tests/test.py
