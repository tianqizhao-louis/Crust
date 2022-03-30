all : 
	echo "implement this"

spcli :
	ocamlbuild -pkgs llvm spcli.native

%.cmo : %.ml
	ocamlc -w A -c $<

%.cmi : %.mli
	ocamlc -w A -c $<

scanner.ml : scanner.mll
	ocamllex $^

crustparser.ml crustparser.mli : crustparser.mly
	ocamlyacc $^

##############################
crustparser.cmo : ast.cmi crustparser.cmi
crustparser.cmx : ast.cmi crustparser.cmi
scanner.cmo : crustparser.cmi
scanner.cmx : crustparser.cmx


.PHONY : clean
clean :
	rm -rf *.cmi *.cmo crustparser.ml crustparser.mli scanner.ml *.native

.PHONY : realclean
realclean: clean
	rm -rf _build/
