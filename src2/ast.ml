(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Equal | Neq | Less | And | Or

type typ = Int | Bool

type expr =
    Literal of int
  | BoolLit of bool
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
(* type bind = typ * string * expr *)
type bind ={
  vtyp: typ;
  vname: string;
  vexpr: expr
}
(* forced assignment*)

type local_or_body=
    | Locals of bind
    | Bodies of stmt

(* func_def: ret_typ fname formals fbody *)
type func_def = {
  rtyp: typ;
  fname: string;
  formals: (typ * string) list;
  fbody: local_or_body list
}

type program = bind list * func_def list

(* Pretty-printing functions *)
let string_of_op = function
    Add -> "+"
  | Sub -> "-"
  | Equal -> "=="
  | Neq -> "!="
  | Less -> "<"
  | And -> "&&"
  | Or -> "||"

let rec string_of_expr = function
    Literal(l) -> string_of_int l
  | BoolLit(true) -> "true"
  | BoolLit(false) -> "false"
  | Id(s) -> s
  | Binop(e1, o, e2) ->
    string_of_expr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_expr e2
  | Assign(v, e) -> v ^ " = " ^ string_of_expr e
  | Call(f, el) ->
      f ^ "(" ^ String.concat ", " (List.map string_of_expr el) ^ ")"

let rec string_of_stmt = function
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

let string_of_vdecl (t, id) = string_of_typ t ^ " " ^ id ^ ";\n"

let string_of_local_or_body = function
  (* trying to use pattern matching to know if current line is a local variable or a statement *)
  | Locals(lvs) -> string_of_typ lvs.vtyp ^ " " ^ lvs.vname ^ "=" ^ (string_of_expr lvs.vexpr) ^ ";\n"
  | Bodies(stmts) -> string_of_stmt stmts


let string_of_fdecl fdecl =
  string_of_typ fdecl.rtyp ^ " " ^
  fdecl.fname ^ "(" ^ String.concat ", " (List.map snd fdecl.formals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_local_or_body (fdecl.fbody)  ) ^
"}\n"

(*  String.concat "" (List.map string_of_vdecl (fst ((fdecl.body).vtyp * (fdecl.body).vname ))) ^
  String.concat "" (List.map string_of_stmt (snd fdecl.body)) ^ *)




let string_of_program (vars, funcs) =
  "\n\nParsed program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_fdecl funcs)
