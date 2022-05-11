#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native
./crust.native -l range_ex.mc > range_ex.out
make all
chmod +x run.sh
./run.sh range_ex.mc
