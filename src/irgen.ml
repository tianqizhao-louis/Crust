module L = Llvm
module A = Ast
open Sast

module StringMap = Map.Make(String)

(* translate : Sast.program -> Llvm.module *)
let translate (globals, functions) =
  let context    = L.global_context () in

  (* Create the LLVM compilation module into which
     we will generate code *)
  let the_module = L.create_module context "Crust" in

  (* Get types from the context *)
  let i32_t      = L.i32_type    context
  and i8_t       = L.i8_type     context
  and i1_t       = L.i1_type     context
  and float_t    = L.double_type  context
  and string_t   = L.pointer_type (L.i8_type context)
  (* and arr_t = L.array_type (L.i8_type context) *)
in

  (* Return the LLVM type for a Crust type *)
  let rec ltype_of_typ = function
      A.Int   -> i32_t
    | A.Bool  -> i1_t
    | A.Float -> float_t
    | A.Char  -> i8_t
    | A.String -> string_t
    | A.Array(t,s) -> L.array_type (ltype_of_typ t) s
  in

  (* Create a map of global variables after creating each *)
  let global_vars : L.llvalue StringMap.t =
    let global_var m (t, n) =
      let init = L.const_int (ltype_of_typ t) 0
      in StringMap.add n (L.define_global n init the_module) m in
    List.fold_left global_var StringMap.empty globals in

  let global_arrays: A.typ  StringMap.t =
          let global_array a (t',n') = StringMap.add n' t' a in
          List.fold_left global_array StringMap.empty globals in
  let one_string_in_one_int_out_t : L.lltype =
    L.var_arg_function_type i32_t [| string_t |] in
  let printf_func : L.llvalue =
    L.declare_function "printf" one_string_in_one_int_out_t the_module in
  let strlen_func : L.llvalue =
    L.declare_function "strlen" one_string_in_one_int_out_t the_module in

  let strcmp_t : L.lltype =
    L.var_arg_function_type i32_t [| string_t; string_t |] in
  let strcmp_func : L.llvalue =
    L.declare_function "strcmp" strcmp_t the_module in

  let two_strings_in_one_string_out_t : L.lltype =
    L.var_arg_function_type string_t [| string_t; string_t |] in

  let str_concat_f : L.llvalue =
    L.declare_function "str_concat_f" two_strings_in_one_string_out_t the_module in

  let two_strings_in_one_bool_out_t : L.lltype =
    L.function_type i1_t [| string_t; string_t |] in
  let str_eq_f : L.llvalue =
    L.declare_function "str_eq_f" two_strings_in_one_bool_out_t the_module in
  let str_neq_f : L.llvalue =
    L.declare_function "str_neq_f" two_strings_in_one_bool_out_t the_module in

    (* conversions *)
  let string_of_int_t : L.lltype =
    L.var_arg_function_type string_t [| i32_t |] in
  let string_of_int_func : L.llvalue =
    L.declare_function "string_of_int_f" string_of_int_t the_module in

  let string_of_float_t : L.lltype =
    L.var_arg_function_type string_t [| float_t |] in
  let string_of_float_func : L.llvalue =
    L.declare_function "string_of_float_f" string_of_float_t the_module in

  let string_of_bool_t : L.lltype =
    L.var_arg_function_type string_t [| i1_t |] in
  let string_of_bool_func : L.llvalue =
    L.declare_function "string_of_bool_f" string_of_bool_t the_module in
  let awk_t : L.lltype =
    L.var_arg_function_type string_t [| string_t;string_t|] in
  let awk_func : L.llvalue =
    L.declare_function "awk_f" awk_t the_module in
  let awk_line_t : L.lltype =
    L.var_arg_function_type string_t [| string_t; string_t; string_t;|] in
  let awk_line_func : L.llvalue =
    L.declare_function "awk_line_f" awk_line_t the_module in
  let awk_line_range_t : L.lltype =
    L.var_arg_function_type string_t [| string_t; string_t; i32_t;i32_t;|] in
  let awk_line_range_func : L.llvalue =
    L.declare_function "awk_line_range_f" awk_line_range_t the_module in
  let awk_line_range_start_t : L.lltype =
    L.var_arg_function_type string_t [| string_t; string_t; i32_t|] in
  let awk_line_range_start_func : L.llvalue =
    L.declare_function "awk_line_range_start_f" awk_line_range_start_t the_module in
  let awk_line_range_end_t : L.lltype =
    L.var_arg_function_type string_t [| string_t; string_t; i32_t|] in
  let awk_line_range_end_func : L.llvalue =
    L.declare_function "awk_line_range_end_f" awk_line_range_end_t the_module in
  let awk_col_t : L.lltype =
    L.var_arg_function_type string_t [| string_t; i32_t|] in
  let awk_col_func : L.llvalue =
    L.declare_function "awk_col_f" awk_col_t the_module in
  let awk_col_contain_t : L.lltype =
    L.var_arg_function_type i32_t [| string_t; string_t; i32_t|] in
  let awk_col_contain_func : L.llvalue =
    L.declare_function "awk_col_contain_f" awk_col_contain_t the_module in
  let awk_max_length_t : L.lltype =
    L.var_arg_function_type i32_t [| string_t|] in
  let awk_max_length_func : L.llvalue =
    L.declare_function "awk_max_length_f" awk_max_length_t the_module in

  (* Define each function (arguments and return type) so we can
     call it even before we've created its body *)
  let function_decls : (L.llvalue * sfunc_def) StringMap.t =
    let function_decl m fdecl =
      let name = fdecl.sfname
      and formal_types =
        Array.of_list (List.map (fun (t,_) -> ltype_of_typ t) fdecl.sformals)
      in let ftype = L.function_type (ltype_of_typ fdecl.srtyp) formal_types in
      StringMap.add name (L.define_function name ftype the_module, fdecl) m in
    List.fold_left function_decl StringMap.empty functions in

  (* Fill in the body of the given function *)
  let build_function_body fdecl =
    let (the_function, _) = try StringMap.find fdecl.sfname function_decls with Not_found -> (raise(Failure("error here"))) in
    let builder = L.builder_at_end context (L.entry_block the_function) in

    let str_format_str = L.build_global_stringptr "%s" "str" builder in


    (* Construct the function's "locals": formal arguments and locally
       declared variables.  Allocate each on the stack, initialize their
       value, if appropriate, and remember their values in the "locals" map *)
    let local_vars =
      let add_formal m (t, n) p =
        L.set_value_name n p;
        let local = L.build_alloca (ltype_of_typ t) n builder in
        ignore (L.build_store p local builder);
        StringMap.add n local m

      (* Allocate space for any locally declared variables and add the
       * resulting registers to our map *)
      and add_local m (t, n) =
        let local_var = L.build_alloca (ltype_of_typ t) n builder
        in StringMap.add n local_var m
      in


      let formals = List.fold_left2 add_formal StringMap.empty fdecl.sformals
          (Array.to_list (L.params the_function)) in
      List.fold_left add_local formals fdecl.slocals
    in

    let local_arrays=
            let add_formal m (t,n) p=
                   StringMap.add n t m
           and add_local m (t,n) =
                   StringMap.add n t m
            in
            let arrays = List.fold_left2 add_formal StringMap.empty fdecl.sformals
                (Array.to_list (L.params the_function)) in
            List.fold_left add_local arrays fdecl.slocals
    in

    (* Return the value for a variable or formal argument.
       Check local names first, then global names *)
    let lookup n = try StringMap.find n local_vars
      with Not_found -> try StringMap.find n global_vars with Not_found -> raise(Failure("here"))
    in

    let lookupA n = try StringMap.find n local_arrays
      with Not_found -> try StringMap.find n global_arrays with Not_found -> raise(Failure("Not found here."))
    in


    (* Construct code for an expression; return its value *)
    let rec build_expr builder ((_, e) : sexpr) = match e with
        SLiteral i  -> L.const_int i32_t i
      | SBoolLit b  -> L.const_int i1_t (if b then 1 else 0)
      | SFloatLit f -> L.const_float float_t f
      | SCharLit c ->  L.const_int i8_t (int_of_char c)
      | SStringLit s -> L.build_global_stringptr s "" builder
      | SId s       -> L.build_load (lookup s) s builder
      | SAssign (s, e) -> let e' = build_expr builder e in
        ignore(L.build_store e' (lookup s) builder); e'
      | SBinop (e1, op, e2) ->
        let e1' = build_expr builder e1
        and e2' = build_expr builder e2 in
        if (fst e1) = A.Int then (match op with
           A.Add     -> L.build_add
         | A.Sub     -> L.build_sub
         | A.Mult    -> L.build_mul
         | A.Div     -> L.build_sdiv
         | A.Mod     -> L.build_srem
         | A.And     -> L.build_and
         | A.Or      -> L.build_or
         | A.Equal   -> L.build_icmp L.Icmp.Eq
         | A.Neq     -> L.build_icmp L.Icmp.Ne
         | A.Less    -> L.build_icmp L.Icmp.Slt
        ) e1' e2' "tmp" builder

        else if (fst e1) = A.Float then (match op with
            A.Add     -> L.build_fadd
          | A.Sub     -> L.build_fsub
          | A.Mult    -> L.build_fmul
          | A.Div     -> L.build_fdiv
          | A.Equal   -> L.build_fcmp L.Fcmp.Oeq
          | A.Neq     -> L.build_fcmp L.Fcmp.One
          | A.Less    -> L.build_fcmp L.Fcmp.Olt
          | _         -> (raise (Failure("https://comicsandmemes.com/wp-content/uploads/blank-meme-template-094-we-dont-do-that-here-black-panther.jpg")))
        ) e1' e2' "tmp" builder

      else if (fst e1) = A.String then (match op with
          A.Add     -> L.build_call str_concat_f [| e1' ; e2' |] "str_concat_f" builder
        | A.Equal   -> L.build_call str_eq_f [| e1' ; e2' |] "str_eq_f" builder
        | A.Neq     -> L.build_call str_neq_f [| e1' ; e2' |] "str_neq_f" builder
        | _         -> raise (Failure("https://comicsandmemes.com/wp-content/uploads/blank-meme-template-094-we-dont-do-that-here-black-panther.jpg"))
      )

        else (raise (Failure("type does not support op")))
      | SCall ("print", [e]) ->
        L.build_call printf_func [| str_format_str ; (build_expr builder e) |]
          "printf" builder
      | SCall ("strlen", [e]) ->
        L.build_call strlen_func [| (build_expr builder e) |]
          "strlen" builder
      | SCall ("strcmp", [e1;e2]) ->
        L.build_call strcmp_func [| (build_expr builder e1) ; (build_expr builder e2) |]
          "strcmp" builder
      | SCall ("string_of_int", [e]) ->
        L.build_call string_of_int_func [| (build_expr builder e) |]
          "string_of_int_f" builder
      | SCall ("string_of_float", [e]) ->
        L.build_call string_of_float_func [| (build_expr builder e) |]
          "string_of_float_f" builder
      | SCall ("string_of_bool", [e]) ->
        L.build_call string_of_bool_func [| (build_expr builder e) |]
          "string_of_bool_f" builder
      | SCall ("awk", [e1;e2]) ->
        L.build_call awk_func [| (build_expr builder e1) ; (build_expr builder e2)|]
          "awk_f" builder
      | SCall ("awk_line", [e1;e2;e3]) ->
        L.build_call awk_line_func [| (build_expr builder e1) ; (build_expr builder e2); (build_expr builder e3)|]
          "awk_line_f" builder
      | SCall ("awk_line_range", [e1;e2;e3;e4]) ->
        L.build_call awk_line_range_func [| (build_expr builder e1) ; (build_expr builder e2); (build_expr builder e3); (build_expr builder e4)|]
          "awk_line_range_f" builder
      | SCall ("awk_line_range_start", [e1;e2;e3]) ->
        L.build_call awk_line_range_start_func [| (build_expr builder e1) ; (build_expr builder e2); (build_expr builder e3)|]
          "awk_line_range_start_f" builder
      | SCall ("awk_line_range_end", [e1;e2;e3]) ->
        L.build_call awk_line_range_end_func [| (build_expr builder e1) ; (build_expr builder e2); (build_expr builder e3)|]
          "awk_line_range_end_f" builder
      | SCall ("awk_col", [e1;e2]) ->
        L.build_call awk_col_func [| (build_expr builder e1) ; (build_expr builder e2)|]
          "awk_col_f" builder
      | SCall ("awk_col_contain", [e1;e2;e3]) ->
        L.build_call awk_col_contain_func [| (build_expr builder e1) ; (build_expr builder e2); (build_expr builder e3)|]
          "awk_col_contain_f" builder
      | SCall ("awk_max_length", [e1]) ->
        L.build_call awk_max_length_func [| (build_expr builder e1)|]
          "awk_max_length_f" builder
      | SCall (f, args) ->
        let (fdef, fdecl) = try StringMap.find f function_decls with Not_found -> raise(Failure("shit " ^ f)) in
        let llargs = List.rev (List.map (build_expr builder) (List.rev args)) in
        let result = f ^ "_result" in
        L.build_call fdef (Array.of_list llargs) result builder

      | SArrayget(v,idx) ->
        let tp = build_expr builder idx in
        let idx' =  [|L.const_int i32_t 0; tp|] in
        let ref = L.build_gep (lookup v) idx' "" builder in
        (L.build_load ref "" builder)

      | SArraysize(v) ->
        let  ll = (lookupA v) in
               ( match ll with
        | Array(t,l) -> (L.const_int i32_t l)
        | _ -> raise(Failure("Not an array.")))    



      | SAssigna(v, idx, e) ->
        let tp = build_expr builder idx in
        let exp = build_expr builder e in
        let idx'' = [|L.const_int i32_t 0; tp|] in
        let ref = L.build_gep (lookup v) idx'' "" builder in
        ignore(L.build_store exp ref builder); exp


      | SArrayLit(t,vs,n) ->
        let tp =0 in
        let vs_sexpr = List.map (fun a-> (t, a)) vs in
        let store_iter (arr,idx) li=
                let tmp_idx =[|L.const_int i32_t 0; L.const_int i32_t idx|] in
                        let ref = L.build_gep (lookup arr) tmp_idx "" builder in
                        let (_,act)=li in
                        ignore(L.build_store (build_expr builder act) ref builder);
                        (arr, idx+1)
                        in ignore(List.fold_left store_iter (n, tp) (List.map (fun a ->(t,a)) vs_sexpr)); (L.const_int i32_t 1) 
    in



    (* LLVM insists each basic block end with exactly one "terminator"
       instruction that transfers control.  This function runs "instr builder"
       if the current block does not already have a terminator.  Used,
       e.g., to handle the "fall off the end of the function" case. *)
    let add_terminal builder instr =
      match L.block_terminator (L.insertion_block builder) with
        Some _ -> ()
      | None -> ignore (instr builder) in

    (* Build the code for the given statement; return the builder for
       the statement's successor (i.e., the next instruction will be built
       after the one generated by this call) *)
    let rec build_stmt builder = function
        SBlock sl -> List.fold_left build_stmt builder sl
      | SExpr e -> ignore(build_expr builder e); builder
      | SReturn e -> ignore(L.build_ret (build_expr builder e) builder); builder
      | SIf (predicate, then_stmt, else_stmt) ->
        let bool_val = build_expr builder predicate in

        let then_bb = L.append_block context "then" the_function in
        ignore (build_stmt (L.builder_at_end context then_bb) then_stmt);
        let else_bb = L.append_block context "else" the_function in
        ignore (build_stmt (L.builder_at_end context else_bb) else_stmt);

        let end_bb = L.append_block context "if_end" the_function in
        let build_br_end = L.build_br end_bb in (* partial function *)
        add_terminal (L.builder_at_end context then_bb) build_br_end;
        add_terminal (L.builder_at_end context else_bb) build_br_end;

        ignore(L.build_cond_br bool_val then_bb else_bb builder);
        L.builder_at_end context end_bb

      | SWhile (predicate, body) ->
        let while_bb = L.append_block context "while" the_function in
        let build_br_while = L.build_br while_bb in (* partial function *)
        ignore (build_br_while builder);
        let while_builder = L.builder_at_end context while_bb in
        let bool_val = build_expr while_builder predicate in

        let body_bb = L.append_block context "while_body" the_function in
        add_terminal (build_stmt (L.builder_at_end context body_bb) body) build_br_while;

        let end_bb = L.append_block context "while_end" the_function in

        ignore(L.build_cond_br bool_val body_bb end_bb while_builder);
        L.builder_at_end context end_bb

     | SFor(initial_val, pred, delta,body) -> 
        build_stmt builder (SBlock [SExpr initial_val; SWhile(pred , SBlock[body; SExpr delta])])

    in
    (* Build the code for each statement in the function *)
    let func_builder = build_stmt builder (SBlock fdecl.sbody) in

    (* Add a return if the last block falls off the end *)
    add_terminal func_builder (L.build_ret (L.const_int i32_t 0))

  in

  List.iter build_function_body functions;
  the_module
