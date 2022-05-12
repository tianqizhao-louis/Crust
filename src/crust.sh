#!/bin/sh

git pull
make clean
ocamlbuild -pkgs llvm crust.native

make all
chmod +x run.sh
printf "\n\n\ntest awk_line\n"
./crust.native -l ../test/awk_test/awk_line.mc > ../test/awk_test/awk_line.out
./run.sh ../test/awk_test/awk_line.mc

printf "\n\n\ntest awk_line_range\n"
./crust.native -l ../test/awk_test/awk_line_range.mc > ../test/awk_test/awk_line_range.out
./run.sh ../test/awk_test/awk_line_range.mc


printf "\n\n\ntest awk_line_range_start\n"
./crust.native -l ../test/awk_test/awk_line_range_start.mc > ../test/awk_test/awk_line_range_start.out
./run.sh ../test/awk_test/awk_line_range_start.mc

printf "\n\n\ntest awk_line_range_end\n"
./crust.native -l ../test/awk_test/awk_line_range_end.mc > ../test/awk_test/awk_line_range_end.out
./run.sh ../test/awk_test/awk_line_range_end.mc

printf "\n\n\ntest awk_col\n"
./crust.native -l ../test/awk_test/awk_col.mc > ../test/awk_test/awk_col.out
./run.sh ../test/awk_test/awk_col.mc

printf "\n\n\ntest awk_col_contain\n"
./crust.native -l ../test/awk_test/awk_col_contain.mc > ../test/awk_test/awk_col_contain.out
./run.sh ../test/awk_test/awk_col_contain.mc

printf "\n\n\ntest awk_max_length\n"
./crust.native -l ../test/awk_test/awk_max_length.mc > ../test/awk_test/awk_max_length.out
./run.sh ../test/awk_test/awk_max_length.mc

printf "\n\n\ntest array functionality\n"
./crust.native -l ../test/arrayTest.mc > ../test/arrayTest.out
./run.sh ../test/arrayTest.mc