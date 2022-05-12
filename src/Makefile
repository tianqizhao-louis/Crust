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
	opam exec -- \
	rm -f *.o
	ocamlbuild -use-ocamlfind -pkgs llvm crust.native
	gcc -c helper_in_c.c
	cc -emit-llvm -o helper_in_c.bc -c helper_in_c.c -Wno-varargs

# "make clean" removes all generated files

.PHONY : clean
clean :
	ocamlbuild -clean
	rm -rf testall.log ocamlllvm *.diff
	rm -f *.o *.output helper_in_c.bc
	rm -rf *.out *.ll
	rm -rf ../test/*.out ../test/*.ll
	rm -rf ../test/awk_test/*.out ../test/awk_test/*.ll
	rm -rf ../test/awk_test/awk_col ../test/awk_test/awk_col_contain ../test/awk_test/awk_line ../test/awk_test/awk_line_range
	rm -rf ../test/awk_test/awk_line_range_end ../test/awk_test/awk_line_range_start ../test/awk_test/awk_max_length ../test/array_test

helper_in_c : helper_in_c.c
	cc -o helper_in_c -DBUILD_TEST helper_in_c.c

