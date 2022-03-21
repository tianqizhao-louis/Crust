(* Ocamllex scanner for NanoC *)

{ open Nanocparse 
  open Lexing
  exception SyntaxError of string 
}

let digit = ['0'-'9']
let letter = ['a'-'z' 'A'-'Z']
let whitespace = [' ' '\t' '\r' '\n']
let ascii = [' '-'~'] 
let end_of_line = '\n'

rule token = parse

(* Separators *)
  whitespace { token lexbuf } (* Whitespace *)
| "/*"     { comment lexbuf }           (* Comments *)
| "//"     { single_line_comment lexbuf }
| '('      { LPAREN }
| ')'      { RPAREN }
| '{'      { LBRACE }
| '}'      { RBRACE }
| '['      { LBRACK }
| ']'      { RBRACK }
| ';'      { SEMI }
| ','      { COMMA }

(* Operators *)
| '+'      { PLUS }
| '-'      { MINUS }
| '='      { ASSIGN }
| '*'      { MULTIPLY }
| '/'      { DIVIDE }
| '%'      { MODULO }
| '!'      { NOT }
| '.'      { DOT }
| "=="     { EQ }
| "!="     { NEQ }
| '<'      { LT }
| "&&"     { AND }
| "||"     { OR }
| "++" { PLUSPLUS }
| "--" { MINUSMINUS }
| "+=" { PLUSEQUAL }
| "-=" { MINUSEQUAL }
| "*=" { MULTEQUAL }
| "/=" { DIVEQUAL }
| "%=" { MODEQUAL }

(* Flow Control *)
| "if"     { IF }
| "else"   { ELSE }
| "while"  { WHILE }
| "for"    { FOR }
| "return" { RETURN }

(* types *)
| "int"    { INT }
| "float"  { FLOAT }
| "char"   { CHAR }
| "string" { STRING }
| "bool"   { BOOL }
| "true"   { BLIT(true)  }
| "false"  { BLIT(false) }
| "struct" { STRUCT } 
| digit+ as lem  { LITERAL(int_of_string lem) }
| letter (digit | letter | '_')* as lem { ID(lem) }
| ''' { read_char (Buffer.create 1) lexbuf} 
| '"'      { read_string (Buffer.create 256) lexbuf } 
| (digit+) (['.'] digit+)? as lem {FLOATING_POINT(float_of_string lem)}
| eof { EOF }
| _ as char { raise (Failure("illegal character " ^ Char.escaped char)) }


and read_char buf =
  parse
  | '\\' '/'  { Buffer.add_char buf '/'; end_char buf lexbuf }
  | '\\' '\\' { Buffer.add_char buf '\\'; end_char buf lexbuf }
  | '\\' 'n'  { Buffer.add_char buf '\n'; end_char buf lexbuf }
  | '\\' 'r'  { Buffer.add_char buf '\r'; end_char buf lexbuf }
  | '\\' 't'  { Buffer.add_char buf '\t'; end_char buf lexbuf }
  | [^ ''' '\\']+
    { Buffer.add_string buf (Lexing.lexeme lexbuf);
      end_char buf lexbuf
    }
  | _ { raise (SyntaxError ("Illegal char character: " ^ Lexing.lexeme lexbuf)) }
  | eof { raise (SyntaxError ("Char is not terminated")) }

and end_char buf = parse 
  ''' { CHAR_LITERAL (Buffer.contents buf) }
| _ { raise (SyntaxError ("char with more than one character " ^ Lexing.lexeme lexbuf)) }
| eof { raise (SyntaxError ("Char is not terminated")) }

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

and comment = parse
  "*/" { token lexbuf }
| _    { comment lexbuf }

and single_line_comment = parse
  end_of_line { token lexbuf }
| _           { single_line_comment lexbuf}