(* 

  Crust Abstract Syntax Tree
  ast.ml

*)

type op = Add | Fadd | Sub | Equal | Neq | Less | And | Or | Mult | Div | Mod

type typ = Int | Bool | Char | String | Float

type expr =
    Literal of int
  | BoolLit of bool
  | CharLit of char
  | FloatLit of float
  | StringLit of string
  | Id of string
  | Binop of expr * op * expr
  | Assign of string * expr
  (* function call *)
  | Call of string * expr list

type stmt =
    Block of stmt list
  | Expr of expr
  | If of expr * stmt * stmt
  | While of expr * stmt
  (* return *)
  | Return of expr

(* int x: name binding *)
type bind = typ * string

(* 混合双打 *)
type hybrid_content = 
    LocalVDecl of bind
  | Statement of stmt

(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp: typ;
  (* function name *)
  fname: string;
  (* parameters 
  a list of bind *)
  formals: bind list;
  locals: bind list; 
  body: stmt list; 
  body_locals: hybrid_content list;
}

type program = bind list * func_def list

(* Pretty-printing functions *)
let string_of_op = function
    Add -> "+"
  | Fadd -> "+."
  | Sub -> "-"
  | Mult -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | And -> "&&"
  | Or -> "||"

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | FloatLit(f) -> string_of_float f
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | CharLit(c) -> String.make 1 c
  | StringLit(s) -> s
  | Id(s) -> s
  | Binop(e1, o, e2) ->
    string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"

let rec string_of_stmt (x: stmt)  = 
  match x with 
    Block(stmts) ->
    "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr(expr) -> string_of_expr expr ^ ";\n"
  | Return(expr) -> "return " ^ string_of_expr expr ^ ";\n"
  | If(e, s1, s2) ->  "if (" ^ string_of_expr e ^ ")\n" ^
                      string_of_stmt s1 ^ "else\n" ^ string_of_stmt s2
  | While(e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_typ = function
    Int -> "int"
  | Bool -> "bool"
  | Char -> "char"
  | String -> "string"
  | Float -> "float"

let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

(* 混合双打 *)
let rec string_of_hybrid (x:hybrid_content) = 
  match x with 
    LocalVDecl(t, id) -> string_of_vdecl (t, id)
    | Statement(s) -> string_of_stmt s

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_hybrid fdecl.body_locals) ^
  "}\n"

let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
