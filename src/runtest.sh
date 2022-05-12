#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native

make all
chmod +x run.sh
printf "test awk_line\n\n\n"
./crust.native -l ../test/awk_test/awk_line.mc > ../test/awk_test/awk_line.out
./run.sh ../test/awk_test/awk_line.mc

printf "test awk_line_range\n\n\n"
./crust.native -l ../test/awk_test/awk_line_range.mc > ../test/awk_test/awk_line_range.out
./run.sh ../test/awk_test/awk_line_range.mc


printf "test awk_line_range_start\n\n\n"
./crust.native -l ../test/awk_test/awk_line_range_start.mc > ../test/awk_test/awk_line_range_start.out
./run.sh ../test/awk_test/awk_line_range_start.mc

printf "test awk_line_range_end\n\n\n"
./crust.native -l ../test/awk_test/awk_line_range_end.mc > ../test/awk_test/awk_line_range_end.out
./run.sh ../test/awk_test/awk_line_range_end.mc