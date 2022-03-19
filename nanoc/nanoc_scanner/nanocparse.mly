/* Ocamlyacc parser for NanoC */

%{
open Ast
%}

%token SEMI LPAREN RPAREN LBRACE RBRACE PLUS MINUS ASSIGN
%token EQ NEQ LT AND OR
%token IF ELSE WHILE INT BOOL FLOAT CHAR STRING
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
  | COMMA { "COMMA" }
  | PLUS { "PLUS" }
  | MINUS { "MINUS" }
  | ASSIGN { "ASSIGN" }
  | EQ { "EQ" }
  | NEQ { "NEQ" }
  | LT { "LT" }
  | AND { "AND" }
  | OR { "OR" }
  | IF { "IF" }
  | ELSE { "ELSE" }
  | WHILE { "WHILE" }
  | FLOAT { "FLOAT" }
  | CHAR { "CHAR" }
  | RETURN { "RETURN" }
  | INT { "INT" }
  | BOOL { "BOOL" }
  | STRING { "STRING" }
  | BLIT { "BOOL: " ^ string_of_bool $1 }
  | LITERAL { "LITERAL: " ^ string_of_int $1 }
  | FLOATING_POINT { "FLOATING_POINT: " ^ string_of_float $1}
  | ID { "ID: " ^ $1 }
  | CHAR_LITERAL { "CHAR_LITERAL: " ^ $1 }
  | STRING_LITERAL { "STRING LITERAL: " ^ $1 }
