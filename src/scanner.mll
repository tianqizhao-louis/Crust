(* 

  Crust Scanner scanner.mll

  This is the Scanner file for Crust. 
  It translates a program into tokens.

*)

(* Open parser file *)
{ 
  open Crustparse 
  open Lexing
  exception SyntaxError of string 
} 

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
| "+."                                    { FPLUS }
| '-'                                     { MINUS }
| '*'                                     { MULT }
| '/'                                     { DIV }
| '%'                                     { MOD }
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
| "float"                                 { FLOAT }
| "bool"                                  { BOOL }
| "true"                                  { BLIT(true)  }
| "false"                                 { BLIT(false) }
| "char"                                  { CHAR }
| "string"                                { STRING }
| '''                                     { read_char (Buffer.create 1) lexbuf} 
| '"'                                     { read_string (Buffer.create 256) lexbuf } 
| digit+ as lem                           { LITERAL(int_of_string lem) }
| (digit+) (['.'] digit+)? as lem         { FLOAT_LITERAL(float_of_string lem) }
| letter (digit | letter | '_')* as lem   { ID(lem) }
| eof                                     { EOF }
| _ as char                               { raise (Failure("illegal character " ^ Char.escaped char)) }

(* read characters *)
and read_char buf =
  parse
  | '\\' '/'  { Buffer.add_char buf '/'; end_char buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; end_char buf lexbuf }
  | '\\' 'n'  { Buffer.add_char buf '\n'; end_char buf lexbuf }
  | '\\' 'r'  { Buffer.add_char buf '\r'; end_char buf lexbuf }
  | '\\' 't'  { Buffer.add_char buf '\t'; end_char buf lexbuf }
  | [^ ''' '\\']
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      end_char buf lexbuf
    }
  | _ { raise (SyntaxError ("Illegal char character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError ("Char is not terminated")) }

(* if more than one character *)
and end_char buf = parse 
  ''' { CHAR_LITERAL (String.get (Buffer.contents buf) 0) }
| _ { raise (SyntaxError ("char with more than one character " ^ Lexing.lexeme lexbuf)) }
| eof { raise (SyntaxError ("Char is not terminated")) }

(* read string *)
and read_string buf =
  parse
  | '"'       { STRING_LITERAL (Buffer.contents buf) }
  | '\\' '/'  { Buffer.add_char buf '/'; read_string buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; read_string buf lexbuf }
  | '\\' 'n'  { Buffer.add_char buf '\n'; read_string buf lexbuf }
  | '\\' 'r'  { Buffer.add_char buf '\r'; read_string buf lexbuf }
  | '\\' 't'  { Buffer.add_char buf '\t'; read_string buf lexbuf }
  | [^ '"' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      read_string buf lexbuf
    }
  | _ { raise (SyntaxError ("Illegal string character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError ("String is not terminated")) }

(* multi-line comment *)
and comment = parse
  "*/"                                    { token lexbuf }
| _                                       {  comment lexbuf }

(* single line comment *)
and single_line_comment = parse
  end_of_line                             { token lexbuf }
| _                                       { single_line_comment lexbuf}
