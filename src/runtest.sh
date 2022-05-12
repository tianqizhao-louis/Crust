#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native
./crust.native -l ../test/awk_test/range_ex.mc > ../test/awk_test/range_ex.out
make all
chmod +x run.sh
./run.sh ../test/awk_test/range_ex.mc
