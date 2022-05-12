# :pizza: Crust

Crust :pizza: is a procedural, C-like language that embeds [awk](https://www.baeldung.com/linux/awk-guide) functions. It is specifically designed for efficient string processing.

![](https://img.shields.io/badge/ocaml-v4.12.0-orange) 

![](https://img.shields.io/badge/llvm-v13.0.0-blue)

## Team Members

| | Role      | Name |
| :---: | :---: | :---: |
| 👨‍💼  | Manager      | Tianqi Zhao |
| 🧑‍🔬 | Language Guru   | Ruiyang Hu |
| 👨‍💻 | System Architect | Shaun Luo |
| 🕵️‍♂️ | Tester | Frank Zhang |

## Run the Project 

```bash
cd src
ocamlbuild -pkgs llvm crust.native
make all
./crust.sh
```

## Essential Project Structure

    .
    ├── LRM.md >>> Our LRM (first draft)
    ├── README.md
    ├── push.sh
    ├── src
    │   ├── Makefile
    │   ├── ast.ml                              # Abstract Syntax Tree
    │   ├── crust.ml                            # Crust's executable
    │   ├── crust.sh                            # shell file to run tests
    │   ├── crustparse.mly                      # Parser
    │   ├── helper_in_c.c                       # C library
    │   ├── irgen.ml                            # LLVM
    │   ├── make.sh 
    │   ├── sast.ml                             # Semantic checks AST
    │   ├── scanner.mll                         # Scanner
    │   ├── semant.ml                           # Semantic checker
    └── test                                    # test suites
        ├── array_test.crust
        └── awk_test
            ├── awk_col.crust
            ├── awk_col_contain.crust
            ├── awk_line.crust
            ├── awk_line_range.crust
            ├── awk_line_range_end.crust
            ├── awk_line_range_start.crust
            ├── awk_max_length.crust
            └── range_ex.crust