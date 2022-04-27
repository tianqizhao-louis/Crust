ocamlbuild -pkgs llvm crust.native
./crust.native -l example.mc > example.out
cat example.out
echo " ------------------- " 
lli example.out