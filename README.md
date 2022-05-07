# How to Install and Run

```
opam install llvm
ocamlbuild -pkgs llvm crust.native
./crust.native -l example.mc > example.out
make all
chmod +x run.sh
echo 'export PATH="/opt/homebrew/opt/llvm/bin:$PATH"' >> ~/.zshrc
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"
./run.sh example.mc
```

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
