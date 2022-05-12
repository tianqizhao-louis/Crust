(*

  Crust
  Semantically-checked Abstract Syntax Tree and Functions
  sast.ml

*)

open Ast

type sexpr = typ * sx
and sx =
    SLiteral of int
  | SBoolLit of bool
  | SFloatLit of float
  | SCharLit of char
  | SStringLit of string
  | SId of string
  | SBinop of sexpr * op * sexpr
  | SArrayLit of typ * sx list
  | SAssign of string * sexpr
  | SArrayget of string * sexpr
  | SAssigna of string * sexpr * sexpr
  | SArraysize of string
  (* call *)
  | SCall of string * sexpr list

type sstmt =
    SBlock of sstmt list
  | SExpr of sexpr
  | SIf of sexpr * sstmt * sstmt
  | SWhile of sexpr * sstmt
  (* return *)
  | SReturn of sexpr

(* func_def: ret_typ fname formals locals body *)
type sfunc_def = {
  srtyp: typ;
  sfname: string;
  sformals: bind list;
  slocals: bind list;
  sbody: sstmt list;
}

type sprogram = bind list * sfunc_def list



(* Pretty-printing functions *)
let rec string_of_sexpr (t, e) =
  "(" ^ string_of_typ t ^ " : " ^ (match e with
        SLiteral(l) -> string_of_int l
      | SFloatLit(f) -> string_of_float f
      | SBoolLit(true) -> "true"
      | SBoolLit(false) -> "false"
      | SCharLit(c) -> String.make 1 c
      | SStringLit(s) -> s
      | SId(s) -> s
      | SBinop(e1, o, e2) ->
        string_of_sexpr e1 ^ " " ^ string_of_op o ^ " " ^ string_of_sexpr e2
      | SArrayLit(t,vs) -> "{" ^ (List.fold_left (^) "" (List.map (fun x -> x ^ ", ") (List.map string_of_sexpr (List.map (fun x -> (t,x)) vs) ) ) )  ^ "}"
      | SAssign(v, e) -> v ^ " = " ^ string_of_sexpr e
      | SArrayget(v,p) -> v ^ "[" ^ string_of_sexpr p ^ "]"
      | SArraysize(v) -> v ^ ".length"
      | SAssigna(v,p,e) -> v ^ "[" ^ string_of_sexpr p ^ "]" ^ " = " ^ string_of_sexpr e
      | SCall(f, el) ->
          f ^ "(" ^ String.concat ", " (List.map string_of_sexpr el) ^ ")"
    ) ^ ")"

let rec string_of_sstmt (x: sstmt) =
  match x with
    SBlock(stmts) ->
    "{\n" ^ String.concat "" (List.map string_of_sstmt stmts) ^ "}\n"
  | SExpr(expr) -> string_of_sexpr expr ^ ";\n"
  | SReturn(expr) -> "return " ^ string_of_sexpr expr ^ ";\n"
  | SIf(e, s1, s2) ->  "if (" ^ string_of_sexpr e ^ ")\n" ^
                       string_of_sstmt s1 ^ "else\n" ^ string_of_sstmt s2
  | SWhile(e, s) -> "while (" ^ string_of_sexpr e ^ ") " ^ string_of_sstmt s

let string_of_sfdecl fdecl =
  string_of_typ fdecl.srtyp ^ " " ^
  fdecl.sfname ^ "(" ^ String.concat ", " (List.map snd fdecl.sformals) ^
  ")\n{\n" ^
  String.concat "" (List.map string_of_vdecl fdecl.slocals) ^
  String.concat "" (List.map string_of_sstmt fdecl.sbody) ^
  "}\n"

let string_of_sprogram (vars, funcs) =
  "\n\nSementically checked program: \n\n" ^
  String.concat "" (List.map string_of_vdecl vars) ^ "\n" ^
  String.concat "\n" (List.map string_of_sfdecl funcs)
