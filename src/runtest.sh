#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native
./crust.native -l row_print.mc > row_print.out
make all
chmod +x run.sh
./run.sh row_print.mc
