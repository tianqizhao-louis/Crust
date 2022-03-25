/* Ocamlyacc parser for NanoC */

%{
open Ast
%}

%token SEMI LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK PLUS MINUS MULTIPLY DIVIDE MODULO
%token PLUSPLUS MINUSMINUS
%token ASSIGN PLUSEQUAL MINUSEQUAL MULTEQUAL DIVEQUAL MODEQUAL
%token EQ NEQ LT GT LEQ GEQ AND OR NOT
%token IF ELSE WHILE FOR
%token INT BOOL FLOAT CHAR STRING STRUCT VOID
%token DOT
%token RETURN COMMA
%token <int> LITERAL
%token <bool> BLIT
%token <float> FLOATING_POINT
%token <string> ID
%token <string> CHAR_LITERAL
%token <string> STRING_LITERAL
%token EOF

%start program
%type <Ast.program> program

%right ASSIGN PLUSEQUAL MINUSEQUAL MULTEQUAL DIVEQUAL MODEQUAL
%left OR
%left AND
%left EQ NEQ
%left LT LEQ GT GEQ
%left PLUS MINUS
%left MULTIPLY DIVIDE MODULO
%left NOT
%right DOT



%%

program:
  decls EOF { $1 }

decls:
   /* nothing */ { ([], [])               }
 | var_decl_rule SEMI decls { (($1 :: fst $3), snd $3) }
 | fdecl decls { (fst $2, ($1 :: snd $2)) }

/* formals_opt */
formals_opt:
  /*nothing*/ { [] }
  | formals_list { $1 }

vdecl:
  typ_rule ID { ($1, $2) }

formals_list:
  vdecl { [$1] }
  | vdecl COMMA formals_list { $1::$3 }

stmt_list:
  /* nothing */ { [] }
  | stmt_rule stmt_list  { $1::$2 }


/* args_opt*/
args_opt:
  /*nothing*/ { [] }
  | args { $1 }

args:
  expr_rule  { [$1] }
  | expr_rule COMMA args { $1::$3 }

fdecl:
  var_decl_rule LPAREN formals_opt RPAREN LBRACE func_body_rule RBRACE
  {
    {
      rtyp=fst $1;
      fname=snd $1;
      formals=$3;
      body=$6
    }
  }

 var_decl_rule:
	typ_rule ID { ($1, $2, Noexpr) } /* int i; */
	| typ_rule ID ASSIGN expr_rule  { ($1, $2, $4) }  /* int i = 1 + 2; */
	| typ_rule ID LBRACK LITERAL RBRACK  { array($1, $2, $4, Noexpr) }  /* int arr[3]; */
	| typ_rule ID LBRACK LITERAL RBRACK ASSIGN LBRACE expr_list RBRACE  { array($1, $2, $4, $8) } /* int arr[3] = {1,2,3}; */


func_body_rule:
  /* nothing */ { ([], [])               }
  | var_decl_rule SEMI func_body_rule { (($1 :: fst $3), snd $3) }
  | stmt_rule func_body_rule { (fst $2, ($1 :: snd $2)) }

 arg_list_optional:
		/* Nothing */ { [] }
		| arg_list 	{ $1 }

arg_list:
		typ_rule ID { [($1, $2)] }
		| typ_rule ID COMMA arg_list { ($1, $2)::$4 }

expr_list:
    expr_rule 			{[$1]}
  | expr_rule COMMA expr_list {$1::$3}

typ_rule:
  INT       { Int  }
  | BOOL    { Bool }
  | FLOAT   { Float }
  | VOID    { Void }
  | CHAR    { Char }
  | STRING  { String }
  | STRUCT  { Struct }



stmt_rule:
  SEMI { [] } // ;;
  | expr_rule SEMI                                                              { Expr $1         } /* print("hellow"); */
  | LBRACE func_body_rule RBRACE                                          { Block $2        }
  | IF LPAREN expr_rule RPAREN func_body_rule                             { If ($3, $5, Noexpr) }  //
  | IF LPAREN expr_rule RPAREN func_body_rule ELSE func_body_rule     { If ($3, $5, $7) }
  | WHILE LPAREN expr_rule RPAREN func_body_rule                          { While ($3,$5)   }
  | FOR LPAREN expr_rule SEMI expr_rule SEMI expr_rule RPAREN func_body_rule { For($3, $5, $7, $9) }
  | RETURN SEMI                                                               { Return Noexpr } // void function
  | RETURN expr_rule SEMI							                                            { Return $2 }

expr_rule:
  | BLIT                          { BoolLit $1            }
  | LITERAL                       { Literal $1            }
  | CHAR_LITERAL					        { CharLit($1)           }
  | STRING_LITERAL 					      { StringLit($1)         }
  | VOID                          { Void                  }
  | ID                            { Id $1                 }
  | expr_rule PLUS expr_rule      { Binop ($1, Add, $3)   }
  | expr_rule MINUS expr_rule     { Binop ($1, Sub, $3)   }
  | expr_rule MULTIPLY expr_rule      		{ Binop ($1, Mult, $3)   }
  | expr_rule DIVIDE expr_rule      		{ Binop ($1, Div, $3)   }
  | expr_rule MODULO expr_rule      		{ Binop ($1, Mod, $3)   }

  | expr_rule EQ expr_rule        { Binop ($1, Equal, $3) }
  | expr_rule NEQ expr_rule       { Binop ($1, Neq, $3)   }
  | expr_rule LT expr_rule        { Binop ($1, Less, $3)  }
  | expr_rule LEQ expr_rule      		{ Binop ($1, Leq, $3)   }
  | expr_rule GT expr_rule      		{ Binop ($1, Gt, $3)   }
  | expr_rule GEQ expr_rule      		{ Binop ($1, Geq, $3)   }
  | expr_rule AND expr_rule       { Binop ($1, And, $3)   }
  | expr_rule OR expr_rule        { Binop ($1, Or, $3)    }
  | NOT expr_rule                 { Uniop (Not $2)        }
  | MINUS expr_rule 				          	{ Uniop(Neg, $2)}

  | ID ASSIGN expr_rule           { Assign ($1, $3)       }
  | ID PLUSEQUAL expr_rule      	{ Binop ($1, Addeq, $3)   }
  | ID MINUSEQUAL expr_rule       { Binop ($1, Subeq, $3)   }
  | ID MULTEQUAL expr_rule      	{ Binop ($1, Multeq, $3)   }
  | ID DIVEQUAL expr_rule      	  { Binop ($1, Diveq, $3)   }
  | ID MODEQUAL expr_rule       	{ Binop ($1, Modeq, $3)   }

  | expr_rule PLUSPLUS					        { Binop ($1, Add, 1)    }
  | PLUSPLUS expr_rule 					      { Binop ($2, Add, 1)    }
  | expr_rule MINUSMINUS					      { Binop ($1, Sub, 1)    }
  | MINUSMINUS expr_rule					      { Binop ($2, Sub, 1)    }

  | LPAREN expr_rule RPAREN       { $2                    }
  | ID LPAREN expr_list RPAREN		{ FunctionCall($1, $3) }
  | ID DOT ID			              	{ StructMember($1, $3)  }
