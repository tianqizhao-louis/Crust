#!/bin/sh

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