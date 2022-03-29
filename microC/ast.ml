open Char

(* op represents binary operators, unop represents unary operator *)
type op =
  | Add
  | Sub
  | Times
  | Div
  | Mod
  | Eq
  | Neq
  | Lt
  | Gt
  | Le
  | Ge
  | And
  | Or

type unop = Inc | Dec | Not | Addr | Deref
type typ = Int | Bool | Char | Double

(* int x: name binding *)
type bind = typ * string

type expr =
  | IntLit of int
  | BoolLit of bool
  | CharLit of char
  (* confusingly, float in OCaml is 64-bit double *)
  | DoubleLit of float
  | Id of string
  | Binop of expr * op * expr
  | Unop of unop * expr
  | Assign of string * expr
  (* function call *)
  | Call of string * expr list

type stmt =
  | Block of stmt list
  | Expr of expr
  | If of expr * stmt * stmt
  | While of expr * stmt
  (* return *)
  | Return of expr

(* func_def: ret_typ fname formals locals body *)
type func_def = {
  rtyp : typ;
  fname : string;
  formals : bind list;
  locals : bind list;
  body : stmt list;
}

type program = bind list * func_def list

(* Pretty-printing functions *)
let string_of_op = function
  | Add -> "+"
  | Sub -> "-"
  | Times -> "*"
  | Div -> "/"
  | Mod -> "%"
  | Eq -> "=="
  | Neq -> "!="
  | Lt -> "<"
  | Gt -> ">"
  | Le -> "<="
  | Ge -> ">="
  | And -> "&&"
  | Or -> "||"

let string_of_unop = function
  | Inc -> "++"
  | Dec -> "--"
  | Not -> "!"
  | Addr -> "&"
  | Deref -> "*"

let rec string_of_expr = function
  | IntLit l -> string_of_int l
  | BoolLit true -> "true"
  | BoolLit false -> "false"
  | CharLit c -> Char.escaped c
  | DoubleLit f -> string_of_float f
  | Id s -> s
  | Binop (e1, o, e2) ->
      string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Unop (u, e) -> string_of_unop u ^ " " ^ string_of_expr e
  | Assign (v, e) -> v ^ " = " ^ string_of_expr e
  | Call (f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"

let rec string_of_stmt = function
  | Block stmts ->
      "{\n" ^ String.concat "" (List.map string_of_stmt stmts) ^ "}\n"
  | Expr expr -> string_of_expr expr ^ ";\n"
  | Return expr -> "return " ^ string_of_expr expr ^ ";\n"
  | If (e, s1, s2) ->
      "if (" ^ string_of_expr e ^ ")\n" ^ string_of_stmt s1 ^ "else\n"
      ^ string_of_stmt s2
  | While (e, s) -> "while (" ^ string_of_expr e ^ ") " ^ string_of_stmt s

let string_of_typ = function
  Int -> "int"
  | Bool -> "bool"
  | Char -> "char"
  | Double -> "double"
  
let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^ fdecl.fname ^ "("
  ^ String.concat ", " (List.map snd fdecl.formals)
  ^ ")\n{\n"
  ^ String.concat "" (List.map string_of_vdecl fdecl.locals)
  ^ String.concat "" (List.map string_of_stmt fdecl.body)
  ^ "}\n"

let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n"
  ^ String.concat "" (List.map string_of_vdecl vars)
  ^ "\n"
  ^ String.concat "\n" (List.map string_of_fdecl funcs)
