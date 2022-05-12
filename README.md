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
chmod +x crust.sh
./crust.sh
```

## Essential Project Structure

    .
    ├── README.md
    ├── proj                                    # Anything related to the project submission
    │   ├── Crust Final Presentation.pdf
    │   └── LRM.md
    ├── src
    │   ├── Makefile                            # makefile
    │   ├── ast.ml                              # AST
    │   ├── crust.ml                            # Used to generate OCaml executable
    │   ├── crust.sh                            # shell scripts to run test suite
    │   ├── crustparse.mly                      # Parser
    │   ├── helper_in_c.c                       # C library
    │   ├── irgen.ml                            # LLVM
    │   ├── run.sh
    │   ├── sast.ml                             # type check AST
    │   ├── scanner.mll                         # Scanner
    │   ├── scanner_test.ml                     # Used to test scanner
    │   ├── semant.ml                           # Type checking
    │   └── semant_test.ml                      # Used to check semant
    └── test                                    # Test Suite
        ├── array_test.crust
        ├── awk_test
        │   ├── awk_col.crust
        │   ├── awk_col_contain.crust
        │   ├── awk_line.crust
        │   ├── awk_line_range.crust
        │   ├── awk_line_range_end.crust
        │   ├── awk_line_range_start.crust
        │   ├── awk_max_length.crust
        │   └── range_ex.crust
        └── example.crust