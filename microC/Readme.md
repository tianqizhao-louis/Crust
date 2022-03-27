### Build the MicroC compiler

### Run the MicroC compiler and generate llvm code

### Compiler files
-  `ast.ml`: abstract syntax tree (AST) definition
-  `scanner.mll`: scanner
-  `crustparser.mly`: parser
-  `sast.ml`: definition of the semantically-checked AST
-  `semant.ml`: semantic checking

### Run providede Command line interface tests
- `make sptest` to compile `spcli.ml` and `./spcli` to run
- `make clean` to clean and `make realclean` to clean and remove build directory


### Other files
- `test1.ml`: the file to test the scanner and parser
- `test2.ml`: the file to test the semantic checker
- `example.mc`: a sample microc source code
- `example.out`: a sample checked code of example.mc
