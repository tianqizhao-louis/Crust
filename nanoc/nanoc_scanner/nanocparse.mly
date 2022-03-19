/* Ocamlyacc parser for NanoC */

%{
open Ast
%}

%token SEMI LPAREN RPAREN LBRACE RBRACE LBRACK RBRACK PLUS MINUS MULTIPLY DIVIDE MODULO 
%token PLUSPLUS MINUSMINUS
%token ASSIGN PLUSEQUAL MINUSEQUAL MULTEQUAL DIVEQUAL MODEQUAL
%token EQ NEQ LT AND OR NOT 
%token IF ELSE WHILE FOR 
%token INT BOOL FLOAT CHAR STRING STRUCT
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
%type <Ast.tokenseq> program

%%

program:
  tokens EOF { $1}

tokens:
   /* nothing */ { [] }
 | one_token tokens { $1 :: $2 }

one_token:
  | SEMI  {  "SEMI" }
  | LPAREN { "LPAREN" }
  | RPAREN { "RPAREN" }
  | LBRACE { "LBRACE" }
  | RBRACE { "RBRACE" }
  | LBRACK { "LBRACK" }
  | RBRACK { "RBRACK" }
  | COMMA { "COMMA" }
  | PLUS { "PLUS" }
  | MINUS { "MINUS" }
  | MULTIPLY { "MULTIPLY" }
  | DIVIDE { "DIVIDE" }
  | MODULO { "MODULO" }
  | ASSIGN { "ASSIGN" }
  | PLUSPLUS { "PLUSPLUS" }
  | MINUSMINUS { "MINUSMINUS" }
  | PLUSEQUAL { "PLUSEQUAL" }
  | MINUSEQUAL { "MINUSEQUAL" }
  | MULTEQUAL { "MULTEQUAL" }
  | DIVEQUAL { "DIVEQUAL" }
  | MODEQUAL { "MODEQUAL" }
  | EQ { "EQ" }
  | NEQ { "NEQ" }
  | LT { "LT" }
  | AND { "AND" }
  | OR { "OR" }
  | NOT { "NOT" }
  | DOT { "DOT" }
  | IF { "IF" }
  | ELSE { "ELSE" }
  | WHILE { "WHILE" }
  | FOR { "FOR" }
  | FLOAT { "FLOAT" }
  | CHAR { "CHAR" }
  | RETURN { "RETURN" }
  | INT { "INT" }
  | BOOL { "BOOL" }
  | STRING { "STRING" }
  | STRUCT { "STRUCT" }
  | BLIT { "BOOL: " ^ string_of_bool $1 }
  | LITERAL { "LITERAL: " ^ string_of_int $1 }
  | FLOATING_POINT { "FLOATING_POINT: " ^ string_of_float $1}
  | ID { "ID: " ^ $1 }
  | CHAR_LITERAL { "CHAR_LITERAL: " ^ $1 }
  | STRING_LITERAL { "STRING LITERAL: " ^ $1 }
