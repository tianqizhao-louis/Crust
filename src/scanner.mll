(* 

  Crust Scanner scanner.mll

  This is the Scanner file for Crust. 
  It translates a program into tokens.

*)

(* Open parser file *)
{ open Crustparse }

(* predefined variables *)
let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let whitespace = [' ' '\t' '\r' '\n']
let end_of_line = '\n'

(* rules we have *)
rule token = parse

(* separators *)
  (* Whitespace *)
  whitespace                              { token lexbuf } 
  (* Comments *)
| "/*"                                    { comment lexbuf }
| "//"                                    { single_line_comment lexbuf }
| '('                                     { LPAREN }
| ')'                                     { RPAREN }
| '{'                                     { LBRACE }
| '}'                                     { RBRACE }
| ';'                                     { SEMI }
| ','                                     { COMMA }

(* operators *)
| '+'                                     { PLUS }
| '-'                                     { MINUS }
| '='                                     { ASSIGN }
| "=="                                    { EQ }
| "!="                                    { NEQ }
| '<'                                     { LT }
| "&&"                                    { AND }
| "||"                                    { OR }

(* flow control *)
| "if"                                    { IF }
| "else"                                  { ELSE }
| "while"                                 { WHILE }
| "return"                                { RETURN }

(* types *)
| "int"                                   { INT }
| "bool"                                  { BOOL }
| "true"                                  { BLIT(true)  }
| "false"                                 { BLIT(false) }
| digit+ as lem                           { LITERAL(int_of_string lem) }
| letter (digit | letter | '_')* as lem   { ID(lem) }
| eof                                     { EOF }
| _ as char                               { raise (Failure("illegal character " ^ Char.escaped char)) }

and comment = parse
  "*/"                                    { token lexbuf }
| _                                       {  comment lexbuf }

and single_line_comment = parse
  end_of_line                             { token lexbuf }
| _                                       { single_line_comment lexbuf}
