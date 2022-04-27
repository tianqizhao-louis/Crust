# "make all" builds the executable

.PHONY : all

all : crust.native helper_in_c.o

# "make microc.native" compiles the compiler
#
# The _tags file controls the operation of ocamlbuild, e.g., by including
# packages, enabling warnings
#
# See https://github.com/ocaml/ocamlbuild/blob/master/manual/manual.adoc

crust.native :
	opam config exec -- \
	rm -f *.o
	ocamlbuild -use-ocamlfind -pkgs llvm crust.native
	gcc -c helper_in_c.c
	cc -emit-llvm -o helper_in_c.bc -c helper_in_c.c -Wno-varargs
#used to be clang in the last line

# "make clean" removes all generated files

.PHONY : clean
clean :
	ocamlbuild -clean
	rm -rf testall.log ocamlllvm *.diff
	rm -f *.o *.output helper_in_c.bc

helper_in_c : helper_in_c.c
	cc -o helper_in_c -DBUILD_TEST helper_in_c.c

