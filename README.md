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
