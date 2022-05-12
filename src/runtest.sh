#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native

printf "test awk_line\n"
./crust.native -l ../test/awk_test/awk_line.mc > ../test/awk_test/awk_line.out
make all
chmod +x run.sh
./run.sh ../test/awk_test/awk_line.mc

printf "test awk_line_range\n"
./crust.native -l ../test/awk_test/awk_line_range.mc > ../test/awk_test/awk_line_range.out
make all
chmod +x run.sh
./run.sh ../test/awk_test/awk_line_range.mc
