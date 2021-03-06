/*

  Crust Ocamlyacc parser
  crustparse.mly

*/


/* Use Ast */
%{
  open Ast
%}

/* Support token */
%token SEMI LPAREN RPAREN LBRACE RBRACE PLUS MINUS ASSIGN LBKT RBKT DOT
%token MULT DIV MOD
%token EQ NEQ LT AND OR
%token IF ELSE WHILE INT BOOL CHAR STRING FLOAT FOR
%token RETURN COMMA
%token ARRAY LENGTH
%token <int> LITERAL
%token <bool> BLIT
%token <string> ID
%token <char> CHAR_LITERAL
%token <string> STRING_LITERAL
%token <float> FLOAT_LITERAL
%token EOF

/* Start of the program */
%start program
%type <Ast.program> program

/* precedence */
%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left LT
%left PLUS MINUS
%left MOD MULT DIV

%%

/* program CFG */
program:
  decls EOF { $1}


/* declarations */
decls:
   /* nothing */ { ([], [])               }
 | vdecl SEMI decls { (($1 :: fst $3), snd $3) }
 | fdecl decls { (fst $2, ($1 :: snd $2)) }


fdecl:
  vdecl LPAREN formals_opt RPAREN LBRACE vdec_or_stmt_list RBRACE
  {
    {
      rtyp=fst $1;
      fname=snd $1;
      formals=$3;
      locals = [];
      body = [];
      body_locals=$6;
    }
  }


/*
  Variable declaration
  Example: int x;
*/
vdecl:
  typ ID { ($1, $2) }


/*
  types
*/
typ:
    INT     { Int   }
  | BOOL    { Bool  }
  | CHAR    { Char }
  | STRING  { String }
  | FLOAT   { Float }
  | ARRAY typ LBKT LITERAL RBKT {Array($2,$4)}

/*
  Variable or statement;
  We can mixed it up right now.
  for real this time
*/
vdec_or_stmt_list:
  /*nothing*/ { [] }
  | vdecl SEMI vdec_or_stmt_list  { LocalVDecl($1) :: $3 }
  | vdef SEMI vdec_or_stmt_list  { LocalVDecl(fst $1) :: Statement(snd $1) :: $3}
  | stmt vdec_or_stmt_list { Statement($1) :: $2 }


/*
  Variable definition
*/
vdef:
  /* int x = 10;*/
  typ ID ASSIGN expr { ( ($1,$2) , (Expr (Assign($2, $4)) )) }

/*
  formals_opt
  function arguments
*/
formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }

/*
  list of function arguments
*/
formals_list:
  vdecl { [$1] }
  | vdecl COMMA formals_list { $1::$3 }

/* a list of statements */
stmt_list:
  /* nothing */ { [] }
  | stmt stmt_list  { $1::$2 }


/*
  statement rule
*/
stmt:
    expr SEMI                               { Expr $1      }
  | LBRACE stmt_list RBRACE                 { Block $2 }
  /* if (condition) { block1} else {block2} */
  /* if (condition) stmt else stmt */
  | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
  | FOR LPAREN expr SEMI expr SEMI expr RPAREN  stmt
                                            { For($3, $5, $7, $9)  }
  | WHILE LPAREN expr RPAREN stmt           { While ($3, $5)  }
  /* return */
  | RETURN expr SEMI                        { Return $2      }


/*
  Expression rule
*/
expr:
    LITERAL          { Literal($1)            }
  | FLOAT_LITERAL    { FloatLit($1)           }
  | BLIT             { BoolLit($1)            }
  | CHAR_LITERAL		 { CharLit($1)            }
  | STRING_LITERAL   { StringLit($1)          }
  | ID               { Id($1)                 }
  | expr PLUS   expr { Binop($1, Add,   $3)   }
  | expr MINUS  expr { Binop($1, Sub,   $3)   }
  | expr MULT   expr { Binop($1, Mult,  $3)   }
  | expr DIV    expr { Binop($1, Div,   $3)   }
  | expr MOD    expr { Binop($1, Mod,   $3)   }
  | expr EQ     expr { Binop($1, Equal, $3)   }
  | expr NEQ    expr { Binop($1, Neq, $3)     }
  | expr LT     expr { Binop($1, Less,  $3)   }
  | expr AND    expr { Binop($1, And,   $3)   }
  | expr OR     expr { Binop($1, Or,    $3)   }
  | ID ASSIGN expr   { Assign($1, $3)         }
  | ID ASSIGN LBRACE vlist RBRACE {ArrayLit($4,$1)}
  | ID LBKT expr RBKT { Arrayget($1,$3) }
  | ID LBKT expr RBKT ASSIGN expr {Assigna($1,$3,$6)}
  | ID DOT LENGTH       {Arraysize($1)}
  | LPAREN expr RPAREN { $2                   }
  /* call */
  | ID LPAREN args_opt RPAREN { Call ($1, $3) }
  | MINUS LITERAL    { Literal( - $2)         }

  vlist:
          {[]}
|vlist COMMA expr {$1 @ [$3]}
|expr     { [$1] }


/*
  args_opt
*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }


/*
  args
*/
args:
  expr  { [$1] }
  | expr COMMA args { $1::$3 }



// /*

//   Crust Ocamlyacc parser
//   crustparse.mly

// */


// /* Use Ast */
// %{
//   open Ast
// %}

// /* Support token */
// %token SEMI LPAREN RPAREN LBRACE RBRACE PLUS MINUS ASSIGN LBKT RBKT
// %token MULT DIV MOD
// %token EQ NEQ LT AND OR
// %token IF ELSE WHILE INT BOOL CHAR STRING FLOAT STRUCTPOINT
// %token RETURN COMMA
// // %token STRUCT STRUCTASSIGN
// %token <int> LITERAL
// %token <bool> BLIT
// %token <string> ID
// %token <char> CHAR_LITERAL
// %token <string> STRING_LITERAL
// %token <float> FLOAT_LITERAL
// %token EOF

// /* Start of the program */
// %start program
// %type <Ast.program> program

// /* precedence */
// %right STRUCTASSIGN
// %right ASSIGN
// %left OR
// %left AND
// %left EQ NEQ
// %left LT
// %left PLUS MINUS
// %left MOD MULT DIV

// %%

// /* program CFG */
// program:
//   sdecls decls EOF { ($1, fst $2, snd $2) }


// /* declarations */
// decls:
//    /* nothing */      { ([], [])             }
//  | vdecl SEMI decls   { (($1 :: fst $3), snd $3) }
//  | fdecl decls        { (fst $2, ($1 :: snd $2)) }


// sdecls:
//   /* nothing */ { [] }
//   | sdecls struct_body { $2 :: $1 }


// struct_body:
//   STRUCT ID LBRACE vdec_list_only_for_struct RBRACE
//   { { sname = $2;
// 	 members = List.rev $4 } }


// fdecl:
//   vdecl LPAREN formals_opt RPAREN LBRACE vdec_or_stmt_list RBRACE
//   {
//     {
//       rtyp=fst $1;
//       fname=snd $1;
//       formals=$3;
//       locals = [];
//       body = [];
//       body_locals=$6;
//     }
//   }


// /*
//   Variable declaration
//   Example: int x = 10
// */
// vdecl:
//   typ ID { ($1, $2) }
//   | typ ID LBKT LITERAL RBKT {(Array($1, $4), $2)}


// vdecl_struct:
//    typ ID SEMI { ($1, $2) }
//   | typ ID LBKT LITERAL RBKT SEMI {(Array($1, $4), $2)}


// // assign_struct_expr:
// //   assign_struct_expr STRUCTPOINT ID { StructBody($1, $3) }


// /*
//   types
// */
// typ:
//     INT       { Int   }
//   | BOOL      { Bool  }
//   | CHAR      { Char }
//   | STRING    { String }
//   | FLOAT     { Float }
//   // | STRUCT ID { Struct($2) }

// /*
//   Variable or statement;
//   We can mixed it up right now.
//   for real this time
// */
// vdec_or_stmt_list:
//   /*nothing*/ { [] }
//   | vdecl SEMI vdec_or_stmt_list  { LocalVDecl($1) :: $3 }
//   | vdef SEMI vdec_or_stmt_list  { LocalVDecl(fst $1) :: Statement(snd $1) :: $3}
//   | stmt vdec_or_stmt_list { Statement($1) :: $2 }


// vdec_list_only_for_struct:
//     /* nothing */    { [] }
//   | vdec_list_only_for_struct vdecl_struct { $2 :: $1 }


// /*
//   Variable definition
// */
// vdef:
//   /* int x = 10;*/
//   typ ID ASSIGN expr { ( ($1,$2) , (Expr (Assign($2, $4)) )) }

// /*
//   formals_opt
//   function arguments
// */
// formals_opt:
//   /*nothing*/ { [] }
//   | formals_list { $1 }

// /*
//   list of function arguments
// */
// formals_list:
//   vdecl { [$1] }
//   | vdecl COMMA formals_list { $1::$3 }

// /* a list of statements */
// stmt_list:
//   /* nothing */ { [] }
//   | stmt stmt_list  { $1::$2 }


// /*
//   statement rule
// */
// stmt:
//     expr SEMI                               { Expr $1      }
//   | LBRACE stmt_list RBRACE                 { Block $2 }
//   /* if (condition) { block1} else {block2} */
//   /* if (condition) stmt else stmt */
//   | IF LPAREN expr RPAREN stmt ELSE stmt    { If($3, $5, $7) }
//   | WHILE LPAREN expr RPAREN stmt           { While ($3, $5)  }
//   /* return */
//   | RETURN expr SEMI                        { Return $2      }


// /*
//   Expression rule
// */
// expr:
//     LITERAL          { Literal($1)            }
//   | FLOAT_LITERAL    { FloatLit($1)           }
//   | BLIT             { BoolLit($1)            }
//   | CHAR_LITERAL		 { CharLit($1)            }
//   | STRING_LITERAL   { StringLit($1)          }
//   | ID               { Id($1)                 }
//   | expr PLUS   expr { Binop($1, Add,   $3)   }
//   | expr MINUS  expr { Binop($1, Sub,   $3)   }
//   | expr MULT   expr { Binop($1, Mult,  $3)   }
//   | expr DIV    expr { Binop($1, Div,   $3)   }
//   | expr MOD    expr { Binop($1, Mod,   $3)   }
//   | expr EQ     expr { Binop($1, Equal, $3)   }
//   | expr NEQ    expr { Binop($1, Neq, $3)     }
//   | expr LT     expr { Binop($1, Less,  $3)   }
//   | expr AND    expr { Binop($1, And,   $3)   }
//   | expr OR     expr { Binop($1, Or,    $3)   }
//   | ID ASSIGN expr   { Assign($1, $3)         }
//   // | assign_struct_expr StructAssign expr { STRUCTASSIGN($1, $3) }
//   | ID LBKT expr RBKT ASSIGN expr { Assigna($1,$3,$6) }
//   | LPAREN expr RPAREN { $2                   }
// /*  | id expr ASSIGN array_lit  {Assign($1 ,$3)}*/
//   /* call */
//   | ID LPAREN args_opt RPAREN { Call ($1, $3) }
//   | MINUS LITERAL    { Literal( - $2)         }




// /*
//   args_opt
// */
// args_opt:
//   /*nothing*/ { [] }
//   | args { $1 }


// /*
//   args
// */
// args:
//   expr  { [$1] }
//   | expr COMMA args { $1::$3 }
