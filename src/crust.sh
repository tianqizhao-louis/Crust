#!/bin/sh

make clean
ocamlbuild scanner_test.native
printf "\n\n\ntest scanner #1\n"
./scanner_test.native < ../test/example.crust > ../out/example.out
cat ../out/example.out

printf "\n\n\ntest scanner #2\n"
./scanner_test.native < ../test/array_test.crust > ../out/array_test.out
cat ../out/array_test.out

printf "\n\n\ntest scanner #3\n"
./scanner_test.native < ../test/awk_test/awk_col.crust > ../out/awk_col.out
cat ../out/awk_col.out

make clean
ocamlbuild semant_test.native
printf "\n\n\ntest semant AST #1\n"
./semant_test.native < ../test/array_test.crust > ../out/array_test.out
cat ../out/array_test.out

printf "\n\n\ntest semant #2\n"
./semant_test.native < ../test/awk_test/awk_line_range.crust > ../out/awk_line_range.out
cat ../out/awk_line_range.out

printf "\n\n\ntest semant #3\n"
./semant_test.native < ../test/awk_test/awk_line_range_end.crust > ../out/awk_line_range_end.out
cat ../out/awk_line_range_end.out

make clean
ocamlbuild -pkgs llvm crust.native

make all
chmod +x run.sh
printf "\n\n\ntest awk_line\n"
./crust.native -l ../test/awk_test/awk_line.crust > ../test/awk_test/awk_line.out
./run.sh ../test/awk_test/awk_line.crust

printf "\n\n\ntest awk_line_range\n"
./crust.native -l ../test/awk_test/awk_line_range.crust > ../test/awk_test/awk_line_range.out
./run.sh ../test/awk_test/awk_line_range.crust


printf "\n\n\ntest awk_line_range_start\n"
./crust.native -l ../test/awk_test/awk_line_range_start.crust > ../test/awk_test/awk_line_range_start.out
./run.sh ../test/awk_test/awk_line_range_start.crust

printf "\n\n\ntest awk_line_range_end\n"
./crust.native -l ../test/awk_test/awk_line_range_end.crust > ../test/awk_test/awk_line_range_end.out
./run.sh ../test/awk_test/awk_line_range_end.crust

printf "\n\n\ntest awk_col\n"
./crust.native -l ../test/awk_test/awk_col.crust > ../test/awk_test/awk_col.out
./run.sh ../test/awk_test/awk_col.crust

printf "\n\n\ntest awk_col_contain\n"
./crust.native -l ../test/awk_test/awk_col_contain.crust > ../test/awk_test/awk_col_contain.out
./run.sh ../test/awk_test/awk_col_contain.crust

printf "\n\n\ntest awk_max_length\n"
./crust.native -l ../test/awk_test/awk_max_length.crust > ../test/awk_test/awk_max_length.out
./run.sh ../test/awk_test/awk_max_length.crust

printf "\n\n\ntest array functionality\n"
./crust.native -l ../test/array_test.crust > ../test/array_test.out
./run.sh ../test/array_test.crust


printf "\n\n\ntest For Loop functionality test\n"
./crust.native -l ../test/forT.crust > ../test/forT.out
./run.sh ../test/forT.crust
