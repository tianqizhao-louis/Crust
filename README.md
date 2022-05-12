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
    ├── LRM.md
    ├── README.md
    ├── push.sh
    ├── src
    │   ├── Makefile
    │   ├── ast.ml
    │   ├── crust.ml
    │   ├── crust.sh
    │   ├── crustparse.mly
    │   ├── helper_in_c.c
    │   ├── irgen.ml
    │   ├── make.sh
    │   ├── sast.ml
    │   ├── scanner.mll
    │   ├── semant.ml
    └── test
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