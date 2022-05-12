(*

  Crust Semantics Checking
  semant.ml

*)

open Ast
open Sast

module StringMap = Map.Make(String)

(* Semantic checking of the AST. Returns an SAST if successful,
   throws an exception if something is wrong.

   Check each global variable, then check each function *)

let check (globals, functions) =

  (* Verify a list of bindings has no duplicate names *)
  let check_binds (kind : string) (binds : (typ * string) list) =
    let rec dups = function
        [] -> ()
      |	((_,n1) :: (_,n2) :: _) when n1 = n2 ->
        raise (Failure ("duplicate " ^ kind ^ " " ^ n1))
      | _ :: t -> dups t
    in dups (List.sort (fun (_,a) (_,b) -> compare a b) binds)
  in

  (* Make sure no globals duplicate *)
  check_binds "global" globals;

  (* Collect function declarations for built-in functions: no bodies *)
  let built_in_decls_list = [
    ("print", {
      rtyp = Int;
      fname = "print";
      formals = [(String, "x")];
      locals = [];
      body = [];
      body_locals = [] });
    ("string_of_float", {
      rtyp = String;
      fname = "string_of_float";
      formals = [(Float, "x")];
      locals = [];
      body = [];
      body_locals = [] });
    ("string_of_bool", {
      rtyp = String;
      fname = "string_of_bool";
      formals = [(Bool, "x")];
      locals = [];
      body = [];
      body_locals = [] });
    ("awk", {
      rtyp = String;
      fname = "awk";
      formals = [(String, "x"); (String, "y")];
      locals = [];
      body = [];
      body_locals = [] });
    ("string_of_int", {
      rtyp = String;
      fname = "string_of_int";
      formals = [(Int, "x")];
      locals = [];
      body = [];
      body_locals = [] })]
    in
  let add_func_to_map the_map func_thingy =
    match func_thingy with
      (func_name, func_struct) -> StringMap.add func_name func_struct the_map
  in

  let elegant_build_in_decls = List.fold_left add_func_to_map StringMap.empty built_in_decls_list in

  (* Add function name to symbol table *)
  let add_func map fd =
    let built_in_err = "function " ^ fd.fname ^ " may not be defined"
    and dup_err = "duplicate function " ^ fd.fname
    and make_err er = raise (Failure er)
    and n = fd.fname (* Name of the function *)
    in match fd with (* No duplicate functions or redefinitions of built-ins *)
      _ when StringMap.mem n elegant_build_in_decls -> make_err built_in_err
    | _ when StringMap.mem n map -> make_err dup_err
    | _ ->  StringMap.add n fd map
  in

  (* Collect all function names into one symbol table *)
  let function_decls = List.fold_left add_func elegant_build_in_decls functions
  in

  (* Return a function from our symbol table *)
  let find_func s =
    try StringMap.find s function_decls
    with Not_found -> raise (Failure ("unrecognized function " ^ s))
  in

  let _ = find_func "main" in (* Ensure "main" is defined *)

  let locals_table = Hashtbl.create 420 in

  let check_func func =
    (* Make sure no formals or locals are void or duplicates *)
    check_binds "formal" func.formals;

    (* Raise an exception if the given rvalue type cannot be assigned to
       the given lvalue type *)
    let check_assign lvaluet rvaluet err =
      if lvaluet = rvaluet then lvaluet else raise (Failure err)
    in

    (* Build local symbol table of variables for this function *)
    let symbols = List.fold_left (fun m (ty, name) -> StringMap.add name ty m)
        StringMap.empty (globals @ func.formals @ func.locals )
    in

    (* Return a variable from our local symbol table *)
    (* 现在symbols里找(globals和formals)，然后再在local_tables里找*)
    let type_of_identifier s =
      (* raise (Failure ("checking identifier " ^ s)) *)
      try StringMap.find s symbols
      with
        | Not_found -> (
        try Hashtbl.find locals_table s
        with
          | Not_found -> raise(Failure("undeclared identifier " ^ s)))
    in

    (* Return a semantically-checked expression, i.e., with a type *)
    let rec check_expr = function
        Literal l -> (Int, SLiteral l)
      | BoolLit l -> (Bool, SBoolLit l)
      | CharLit c -> (Char, SCharLit c)
      | FloatLit f -> (Float, SFloatLit f)
      | StringLit s -> (String, SStringLit s)
      | Id var -> (type_of_identifier var, SId var)
      | Assign(var, e) as ex ->
        let lt = type_of_identifier var
        and (rt, e') = check_expr e in
        let err = "illegal assignment " ^ string_of_typ lt ^ " = " ^
                  string_of_typ rt ^ " in " ^ string_of_expr ex
        in
        (check_assign lt rt err, SAssign(var, (rt, e')))

      | Arrayget(v,p) -> (*check array get element*)
          let (typp,sexprp)=check_expr p in
            if typp != Int then raise(Failure("Non integer input for index."))
            else
              let typ_v = type_of_identifier v in
              let typ_e = match typ_v with
                | Array(t,l) -> (match p with
                              | Literal idx -> if (idx >= l || idx < 0) then raise(Failure("Array index out of bound."))
                                        else t
                              | _ -> t)
                | _ -> raise(Failure("Array matching error."))
                in
                (typ_e, SArrayget(v, (typp, sexprp)))

      | Assigna(v, p, e) -> (* check assignment for arrays *)
          let (typp, sexprp) = check_expr p in
            if typp != Int then raise(Failure("Non integer input for index."))
            else
              let typ_v = type_of_identifier v in
              let (typE,sexprE) = check_expr e in
              let typ_e = match typ_v with
                  | Array(t,l) -> (match p with
                                  | Literal idx -> if (idx >= l || idx < 0) then raise(Failure("Array index out of bound."))
                                            else
                                                    if (t != typE ) then raise(Failure("Wrong type of variable in array access"))
                                                    else t
                                  | _ -> if (t != typE ) then raise(Failure("Wrong type of variable in array access"))
                                        else t)
                  | _ -> raise(Failure("Array matching error."))
                  in
                  (typ_e, SAssigna(v, (typp, sexprp), (typE,sexprE)))


      | Binop(e1, op, e2) as e ->
        let (t1, e1') = check_expr e1
        and (t2, e2') = check_expr e2 in
        let err = "illegal binary operator " ^
                  string_of_typ t1 ^ " " ^ string_of_op op ^ " " ^
                  string_of_typ t2 ^ " in " ^ string_of_expr e
        in
        (* All binary operators require operands of the same type*)
        if t1 = t2 then
          (* Determine expression type based on operator and operand types *)
          let t = match op with
              Add | Sub | Mult | Div | Mod when t1 = Int -> Int
            | Add | Sub | Mult | Div when t1 = Float -> Float
            | Equal | Neq -> Bool
            | Less when t1 = Int -> Bool
            | And | Or when t1 = Bool -> Bool
            | _ -> raise (Failure err)
          in
          (t, SBinop((t1, e1'), op, (t2, e2')))
        else raise (Failure err)
      | Call(fname, args) as call ->
        let fd = find_func fname in
        let param_length = List.length fd.formals in
        if List.length args != param_length then
          raise (Failure ("expecting " ^ string_of_int param_length ^
                          " arguments in " ^ string_of_expr call))
        else let check_call (ft, _) e =
          (* if function name == printf, e -> string_of_e e *)
               let (et, e') = check_expr e in
               let err = "illegal argument found " ^ string_of_typ et ^
                         " expected " ^ string_of_typ ft ^ " in " ^ string_of_expr e
               in (check_assign ft et err, e')
          in
          let args' = List.map2 check_call fd.formals args
          in (fd.rtyp, SCall(fname, args'))
    in

    let check_bool_expr e =
      let (t, e') = check_expr e in
      match t with
      | Bool -> (t, e')
      |  _ -> raise (Failure ("expected Boolean expression in " ^ string_of_expr e))
    in

    let rec check_stmt_list =function
        [] -> []
      | Block sl :: sl'  -> check_stmt_list (sl @ sl') (* Flatten blocks *)
      | s :: sl -> check_stmt s :: check_stmt_list sl
    (* Return a semantically-checked statement i.e. containing sexprs *)

    and check_stmt =function
      (* A block is correct if each statement is correct and nothing
         follows any Return statement.  Nested blocks are flattened. *)
        Block sl -> SBlock (check_stmt_list sl)
      | Expr e -> SExpr (check_expr e)
      | If(e, st1, st2) ->
        SIf(check_bool_expr e, check_stmt st1, check_stmt st2)
      | While(e, st) ->
        SWhile(check_bool_expr e, check_stmt st)
      | Return e ->
        let (t, e') = check_expr e in
        if t = func.rtyp then SReturn (t, e')
        else raise (
            Failure ("return gives " ^ string_of_typ t ^ " expected " ^
                     string_of_typ func.rtyp ^ " in " ^ string_of_expr e))
    in (* body of check_func *)


    (* 如果是declaration，查hashtable，然后加入locals symbol table
      如果是statement，转换成sstmt for sast
    *)
    let rec check_hybrid_list content =
      match content with
      [] -> []
      | head :: tail -> (
        match head with
          LocalVDecl(t, id) -> (
            match Hashtbl.find_opt locals_table id with
              None -> (
                ignore(Hashtbl.add locals_table id t);
                check_hybrid_list tail
              )
              | _ -> raise (Failure ("duplicate local var " ^ id))
          )
        | Statement(s) -> (check_hybrid_list tail @ [check_stmt s])
      )
    in

    { srtyp = func.rtyp;
      sfname = func.fname;
      sformals = func.formals;
      slocals  = (Hashtbl.fold (fun k v acc -> (v, k) :: acc) locals_table []);
      sbody = List.rev (check_hybrid_list (func.body_locals));
      (* 感觉microC是从后往前check，没有rev因为它的不在乎顺序，locals先declare完了。
        现在混合模式顺序有关系了，所以把倒序改回正序 *)
    }
  in
  (globals, List.map check_func functions)
