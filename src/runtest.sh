#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native

make all
chmod +x run.sh
printf "\n\n\ntest awk_line"
./crust.native -l ../test/awk_test/awk_line.mc > ../test/awk_test/awk_line.out
./run.sh ../test/awk_test/awk_line.mc

printf "\n\n\ntest awk_line_range"
./crust.native -l ../test/awk_test/awk_line_range.mc > ../test/awk_test/awk_line_range.out
./run.sh ../test/awk_test/awk_line_range.mc


printf "\n\n\ntest awk_line_range_start"
./crust.native -l ../test/awk_test/awk_line_range_start.mc > ../test/awk_test/awk_line_range_start.out
./run.sh ../test/awk_test/awk_line_range_start.mc

printf "\n\n\ntest awk_line_range_end"
./crust.native -l ../test/awk_test/awk_line_range_end.mc > ../test/awk_test/awk_line_range_end.out
./run.sh ../test/awk_test/awk_line_range_end.mc

printf "\n\n\ntest awk_col"
./crust.native -l ../test/awk_test/awk_col.mc > ../test/awk_test/awk_col.out
./run.sh ../test/awk_test/awk_col.mc