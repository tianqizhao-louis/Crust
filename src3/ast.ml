(* Abstract Syntax Tree and functions for printing it *)

type op = Add | Sub | Equal | Neq | Less | And | Or
type typ = Int | Bool | String

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

type bind ={
    vtyp: typ;
    vname: string;
    vexpr: expr
}


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
