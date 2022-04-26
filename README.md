# HELPER IN C 
make all来compile crust.native和helper.c 
用 sh run.sh example.mc 来link helper的object file 跟crust.native一起

# IR GEN

需要opam install llvm 

现在compile用 `ocamlbuild -pkgs llvm crust.native`

运行用 `./microc.native -l example.mc > example.out`

-l出LLVM 

-a出AST

-s出SAST


# Crust

Crust is a procedural computer language based on C that is specifically designed for string processing.

## Installation 

You need to have ocaml installed.

## Run the Test Helloworld program

```bash
mkdir out
cd src
ocamlbuild crust.native
./crust.native < ../test/helloworld.crust > ../out/helloworld.out
cat ../out/helloworld.out
```
