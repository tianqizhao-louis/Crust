#!/bin/sh
git pull
make clean
ocamlbuild -pkgs llvm crust.native
./crust.native -l example.mc > example.out
make all
chmod +x run.sh
./run.sh example.mc
