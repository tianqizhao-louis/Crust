#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native
./crust.native -l ../test/awk_test/awk_line.mc > ../test/awk_test/awk_line.out
make all
chmod +x run.sh
./run.sh ../test/awk_test/awk_line.mc
