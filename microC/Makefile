%.cmo : %.ml
	ocamlc -w A -c $<

%.cmi : %.mli
	ocamlc -w A -c $<

scanner.ml : scanner.mll
	ocamllex $^

crustparser.ml crustparser.mli : crustparser.mly
	ocamlyacc $^

# Depedencies from ocamldep
# parser.cmo : ast.cmi parser.cmi
# parser.cmx : ast.cmi parser.cmi
# scanner.cmo : parser.cmi
# scanner.cmx : parser.cmx

##############################


.PHONY : clean
clean :
	rm -rf *.cmi *.cmo crustparser.ml crustparser.mli scanner.ml
