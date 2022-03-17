# Crust: Language Reference Manual

```
Team Manager:       Tianqi Zhao
Language Guru:      Annie Song
System Architect:   Shaun Luo, Ruiyang Hu
Tester:             Frank Zhang
```

## Introduction

Crust is a procedural computer language based on C. It seeks to improve the C language by implementing many new additions – pattern matching, garbage collection, string manipulation, and simpler syntax. In doing so, Crust is intended to be an intermediary programming language between Java and C. Beginner programmers will have a chance to become more familiar with the concept of memory address without being trapped in segmentation faults, undefined behaviors, or other bizarre errors. For those with more experience, Crust’s appeal will be its modernized functional interface. Borrowing from the likes of C++ and Rust, it will extend C’s support for function pointers by implementing pattern matching. Combined with other features of Crust, we expect pattern matching to allow for more liberal design while programming.

## Lexical Conventions

### Tokens

In general, white space characters such as space, tab, and newline in code will be ignored. Users can use `space`, `\t`, `\n` , and `\r` to use them within string type variables.

There are five types of tokens: identifiers, separators, operators, literals,and keywords

Comments will begin with `/-` and end with `-/`. Single line comments will begin with `//`.

### Identifiers

Identifiers are names assigned to functions, variables, and data structures. Identifiers can only start with an alphabet, which can be a lower case or upper case letter. After the first character, numbers and underscores are allowed. Identifiers are case sensitive.

In terms of regular expression, a valid identifier should be in the form of `([‘a’ - ‘z’] | [‘A’ - ‘Z’]) ([‘a’ - ‘z’] | [‘A’ - ‘Z’] | [‘0’-’9’] | ‘_’)*`.

### Keywords

Similar to other languages, our language has reserved words that cannot be used as identifiers.

```
boolean
char
if
true
false
for
match
NULL
string
int
double
return
void
while
struct
if
else
const
```

### Separators

In order to distinguish the boundaries between blocks or those between subroutines, our language reserves some lexical symbols as separators. They are: `( ) { } ; : ,` and white space.

### Operators

The language will reserve some lexical symbols as operators.

Arithmetic: `+`, `-`, `/`, `*`,`%`. They are plus, minus, divide, multiply and modulus operation.

Assignment: `=`

Comparison: `==`, `!=`, `<`, `<=`, `>`, `>=`

Logical: `||` as logical or, `&&` as logical and, `!` as not, `|` as bitwise or, and `&` as bitwise and.=

### Literals

Our built-in types include decimal integers, doubles, booleans, characters, and strings as literals.
Integers can be matched by the following regular expression: `[‘0’ - ‘9’]+`
Doubles are 64-bit numbers that need not be integers. Doubles can be matched by `[‘0’ - ‘9’]+ ‘.’ [‘0’ - ‘9’]*`. Note that when storing a double, the language uses IEEE-754 standard.
Boolean literals can either be `true` or `false`.
Crust supports all characters on the keyboard. For special characters such as quotation marks, it can be recognized by adding an escape character `\` in the beginning. For example, `\"` represents a single quotation mark.
Strings are just a sequence of characters wrapped around by double quotation marks. Again, any special characters can be recognized by adding the escape character backslash as the prefix.

## Types

### Type Table

Crust supports the following data types:

| Type | Size (Bytes) |
| --- | --- |
| int | 4 |
| char | 1 |
| boolean | 1 |
| double | 8 |
| void | N/A |
| pointer | 8 |
| string | N/A |
| array | N/A |
| struct | N/A |

### Primitive Data Types

| Type | Description |
| --- | --- |
| int | The int type stores integers, and can have both positive or negative values except decimal or floating-point values. E.g., 5, -7, 3. It is stored in 8 bytes. |
| char | The char type stores a single character and requires 1 byte of memory. |
| boolean | The boolean type stores true or false, requiring 1 byte of memory. |
| double | The double type stores decimal numbers, requiring 8 bytes of memory. |
| void | void means no type and no value, using as function return type or pointer type. |

### Non-Primitive Data Types

| Type | Description |
| --- | --- |
| pointer | It stores an address to another variable. |
| string | It stores a sequence of char values. |
| array | Data structure that can store a fixed-size sequence of same-type elements. Elements can be accessed using indices. |
| struct | It stores a collection of items of different data types, like a record. |

### Type Declaration

For primitive data types, the declaration is written as follows:

```
type variable = value;
```

```c
// integer
int x = 8;

// char
char x = 'a';

// boolean
boolean x = true;

// double
double x = 4.33;
```

For non-primitive data types, the declaration varies by type:

```c
// void and pointer
void *p;
int *m;
*m = &var;

// string
string m = "abc";

// array
double m[] = {1.11, 2.22, 3.33, 4.44};
m[2] = 6.66;
int arr[10];

// struct 
struct Books {
	char title[50];
	int price;
}
```

### Type Qualifier

The only type qualifier Crust supports is `const`: It means the value of the variable cannot be changed.

```c
const int x = 8;

x = 10; // throws an error
```

### Type Casting

The type casting syntax is written using cast operator as follows:

```
(cast_to_type_name) expression
```

E.g.,

```c
int a = 10;

int b = 3;

double c = (double) a / (double) b;
```

## Operators

### Arithmetic Operator

The binary arithmetic operator are `+`, `-`, `*`, `/`, `%`, `++`, `--`

Assume A is 10 and B is 2

- `+` : Adds two variable
    - Example: `A + B = 12`
- `-` : subtract the second variable from the first variable
    - Example: `A - B = 8`
- `*`: multiplies the two variables
    - Example: `A * B = 20`
- `/` : divides the second variable by the first variable
    - Example: `A / B = 5`
- `%` : gets the remainder after an integer division
    - Example: `A % B = 0`
- `++` : increments the variable by 1
    - Example: `A = 11; A++;`
- `--` : decrements the variable by 1
    - Example: `A = 9; A--;`

### Relational Operators

The relational arithmetic operators are `==`, `!=`, `>`,`<`, `>=`, `<=`

Assume A is 0 and B is 1

- `==` : Check if two variables are equal. If they are equal, return true
    - Example: `(A == B)` is false
- `!=` : Check if two variables are not equal. if they are not equal, return true
    - Example: `(A != B)` is true
- `>` : Check if the first variable is greater than the second variable. If yes, return true
    - Example: `(A > B)` is false
- `<` : Check if the first variable is greater than the second variable. If yes, return true
    - Example: `(A < B)` is true
- `>=` : Check if the first variable is greater or equal than the second variable. If yes, return true
    - Example: `(A >= B)` is false
- `<=` : Check if the first variable is smaller or equal than the second variable. If yes, return true
    - Example: `(A <= B)` is true

### Logical Operators

The logical operators are `&&`, `||`,  `!`

Assume A is 0 and B is 1

- `&&`, : And operator. If both variables are non-zero, return true.
    - Example: `(A && B)` is false
- `||` : Or operator. If there is any variable that is non-zero, return true.
    - Example: `(A || B)` is true
- `!` : Not operator. Return the reverse boolean value of the variable.
    - Example: `!(A && B)` is true

### Assignment Operators

The logical operators are `=`, `+=`, `-=`, `*=`, `/=`, `%=`

- `=` : Assign operator. Assign the value from the right variable to the left variable.
    - Example: `A = B * C` will assign the value of B * C to A
- `+=` : Add and assign operator. Assign the value to the left variable by adding the original left variable with the right variable.
    - Example: `A += C` is the same as A = A+C
- `-=` : Subtract and assign operator. Assign the value to the left variable by subtracting the original left variable with the right variable.
    - Example: `A -= C` is the same as A = A-C
- `=` : Multiply and assign operator. Assign the value to the left variable by multiplying the original left variable with the right variable.
    - Example: `A *= C` is the same as A = A*C
- `/=` : Divide and assign operator. Assign the value to the left variable by dividing the original left variable with the right variable.
    - Example: `A /= C` is the same as A = A/C
- `%=` : Modulus and assign operator. Assign the value to the left variable by assign the remainder after dividing the original left variable with the right variable.
    - Example: `A %= C` is the same as A = A%C

### Misc Operators

The logical operators are `sizeof()`, `&`, `*`,`?`:

- `sizeof()`: Returns the size of a variable
    - Example: `sizeof(a)` will return 4 if a is an integer
- `&`: returns the address of a variable
    - Example: `&a` will return the memory address of the variable
- `*`: dereference operator of a variable
    - Example: `*a` will return the pointer of the variable
- `?`: ternary operator. If condition is true, execute the first statement; else, second.
    - Example: `condition ? A : B;`

## Statements and Expressions

There are two types of statements in Crust:

- Simple statements
- Compound statements

And three types of expressions:

- Arithmetic expressions
- Literal expressions
- Compound expressions

### Statements

#### Simple Statements

Simple statements consists of a simple expression followed by a semicolon `;`:

```c
// variable declaration
int x = 2;

y = 3 + 2;

8 + 9;

a.print("lol");

"hello";

a[2] = 3;

int b[] = {'a', 'b', 'c', 'd'};

printf("%d", 3);
```

#### Compound Statements

Compound statements include conditional statements and looping statements. Pattern matching, allowed by the `match` keyword, will also be an example of a compound statement. More details on pattern matching will be given below.

E.g., conditional statements

```c
if (booleanVar) {
	good();
	haha();
} else if (anotherBoolVar) {
	jump();
} else {
	bobo();
}
```

E.g., looping statements

```c
while (a <= b) {
	doSomething();
}

for (int i = 0; i < 10; i++) {
	doAnotherThing();
}
```

### Expressions

#### Arithmetic Expressions

Arithmetic expressions are add, subtract, and multiply, etc. (Basic mathematical expressions.)

```c
A + B;

A - B;

A < B;
```

#### Literal Expressions

Literal expressions differentiate between `char` and `string`.

`char`: surrounded by single quotes

```c
char a = 'b';
```

`string`: surrounded by double quotes

```c
string k = "abc";
```

#### Compound Expressions

Compound expressions include `malloc`, pointer, `struct`, and function calls.

- `malloc` and pointer expression:

```c
// declare a pointer
char *str;
// allocate memory
str = (char *) malloc(15);
strcpy(str, "good");
printf("String = %s,  Address = %u\n", str, str);
// You don't need a free(str); statement because Crust will take care of that for you.

// for pointer
int foo = 23;
int *boo;
boo = &foo;
```

- `struct` expression:

`struct` is like `Class` in Java without methods. Within the struct statements we can define some fields for the struct.

```c
struct Person {
  char name[50];
  int age;
  float salary;
} person1;

// inside main function
strcpy(person1.name, "Good Morning");
person1.age = 18;

printf("Name: %s\n", person1.name);
printf("Age: %d\n", person1.age);
```

- function calls:

Crust’s function call is really like C. A `helloworld` program looks like:

```c
int main() {
   printf("Hello, World!");
   printf("%d", max(3, 5));
   return 0;
}

// a random function to calculate max
int max(int num1, int num2) {
   int result;
 
   if (num1 > num2)
      result = num1;
   else
      result = num2;
 
   return result; 
}
```

## Memory and Safety

The original C language is known for having the problem of memory leaking (caused by programmer errors). For example, if the user `malloc()` something  and forgets to free it, then in the long run, s/he might run out of memory. In Crust, when binding a resource in heap to a variable, the language will label which variable has access to such resource. We can always point a new pointer to such resources, and the language keeps track of all of them. Note that it is not allowed to point to the middle of such a resource.

When there is no pointer pointing to a resource, the language will automatically label memory segments occupied by such resources as freed.

Otherwise, since we have introduced a new string type, the language will also contain several functions for strings. More importantly, such functions will be memory safe. That is, users will no longer need to worry about whether they properly terminated a string with the null character. Furthermore, any invalid string operations which would cause a memory leak in C will cause an exception in Crust.

## Pattern Matching

We rely on the `match` keyword for pattern matching.

```c
int val = some_function_call();
match val {
    1 => handle_one();
    2 => handle_two();
    _ => handle_rest();
}
```

The main advantage this has over if and switch statements, besides its more readable syntax, is that the compiler will perform a compile-time exhaustiveness check:

```c
int val = some_function_call();
match val {
    1 => handle_one();
    2 => handle_two();
} // compiler error - non-exhaustive match statement
```

If a match case is unnecessary, you can silence the compiler as such:

```c
int val = some_function_call();
match val {
    1 => handle_one();
    2 => handle_two();
    _ => ;
}
```

But the programmer must make an intentional choice to forgo performing any actions in an unnecessary `match` case.

Besides from primitive types, `structs` can also be decomposed using this keyword:

```c
struct Point {
    int x;
    int y;
};

Point p = some_function_call();

match p {
    Point {x,y} => printf("x=%d, y=%d\n", x, y);
}
```

And array-types (C-style string and arrays):

```c
int arr[10];
some_function_call(arr);

// .. will match the rest of the array
match arr {
    (x,..) => printf("first number=%d\n", x);
    _ => printf("you got an empty array\n");
}
```

## Grammar

### `Scanner.mll`

```ocaml
let alpha = ['a'-'z' 'A'-'Z']
let escape = '\\' ['\\' ''' '"' 'n' 't'] 
let escape_char = ''' (escape) '''	
let ascii = ([' '-'!' '#'-'[' ']'-'~']) 
let digit = ['0'-'9']
let id = alpha (alpha | digit | '_')* 
let string = '"' ( (ascii | escape)* ) '"'
let char = ''' ( ascii | digit | escape ) '''  
let double = (digit+) ['.'] digit+
let int = digit+
let whitespace = [' ' '\t' '\r' '\n']
let newline = '\n'

rule token = parse

(* Separators *)
 whitespace { token lexbuf }
| newline { incr lineno; token lexbuf}
| "/*" { incr depth; multi_line_comment lexbuf }
| "//" { single_line_comment lexbuf }
| '(' { LPAREN }
| ')' { RPAREN }
| '{' { LBRACE }
| '}' { RBRACE }
| ';' { SEMI }
| ',' { COMMA }
| '[' { LBRACK }
| ']' { RBRACK }
| ‘_’ { UNDERSCORE }

(* Operators *)
| '+' { PLUS }
| '-' { MINUS }
| '*' { TIMES }
| '/' { DIVIDE }
| '%' { MODULO }
| '=' { ASSIGN }
| "==" { EQ }
| "!=" { NEQ }
| '<' { LT }
| "<=" { LEQ }
| ">" { GT }
| ">=" { GEQ }
| "&&" { AND }
| “++” { PLUSPLUS }
| “--” { MINUSMINUS }
| “+=” { PLUSEQUAL }
| “-=” { MINUSEQUAL }
| “*=” { MULTEQUAL }
| “/=” { DIVEQUAL }
| “%=” { MODEQUAL }
| "||" { OR }
| "!" { NOT }
| '.' { DOT }		
| "&" { REFERENCE }	

(* Ownership *)
 (* Branch Control *)
 | "if" { IF }
 | "else" { ELSE }
 | "for" { FOR }
 | "while" { WHILE }  
 (* Data Types *)
 | "int" { INT }
 | “int*” { INT_PTR }
 | "double" { DOUBLE }	
 | “double*” { DOUBLE_PTR} 
 | "char" { CHAR }
 | "char*" { CHAR_PTR }
 | "struct" { STRUCT }
 | "struct*" { STRUCT_PTR }
 | “string” { STRING }  
 | “string*” { STRING_PTR }
 | "void" { VOID }
 | "void*" { VOID_PTR }
 | “NULL” { NULL}
 
 (* Memory *) 
 | “malloc” {MALLOC}
 | “free” {FREE}
 
 (* function *)
 | "return" { RETURN }
 
 (* Other *)
 | int as lxm { INT_LITERAL(int_of_string lxm) }
 | double as lxm { DOUBLE_LITERAL(double_of_string lxm) }
 | char as lxm { CHAR_LITERAL( String.get lxm 1 ) }
 | escape_char as lxm{ CHAR_LITERAL( String.get (unescape lxm) 1) }
 | string as s { STRING_LITERAL(unescape s) }   
 | id as lxm { ID(lxm) }
 | eof { EOF }
 | '"' { raise (Exceptions.UnmatchedQuotation(!lineno)) }
 | _ as illegal { raise (Exceptions.IllegalCharacter(!filename, illegal,  !lineno)) }
 
 and multi_line_comment = parse   
    newline { incr lineno; comment lexbuf }
 | "*/" { decr depth; if !depth > 0 then comment lexbuf else token lexbuf }
 | "/*" { incr depth; comment lexbuf }
 | _ { comment lexbuf }
 
 and single_line_comment = parse
   newline {token lexbuf}
 | _ {comment lexbuf}
```

### `Parser.mly`

```ocaml
%right ASSIGN
 %left OR
 %left AND 
 %left EQ NEQ
 %left LT LEQ GT GEQ 
 %left PLUS MINUS TIMES DIVIDE MODULO 
 
 program_rule:
 		var_decl_list_rule func_decl_list_rule EOF { {globals=$1; functions=$2} }
 
 var_decl_list_rule:
		/* Nothing */ { [] }
		| var_decl_rule var_decl_list_rule {$1::$2}
 
 var_decl_rule: 
	typ_rule ID SEMI { ($1, $2, NULL) }
	typ_rule ID ASSIGN expr_rule SEMI { ($1, $2, $4) }
		typ_rule ID LBRACK Literal RBRACK SEMI { Array($1, $2, $4, Null) }
		typ_rule ID LBRACK Literal RBRACK EQUAL LBRACE expr_list RBRACE SEMI
							{ Array($1, $2, $4, $8) }
 
 
 
 func_decl_list_rule:
		/* Nothing */ { [] }
		| func_decl_rule func_decl_list_rule ($1::$2)
 
 func_decl_rule:  
 		typ_rule ID LPAREN arg_list_optional RPAREN LBRACE function_rule RPAREN {OutputType=$1, FunctionName=$2, Arguments=$4, Body=$8}
 
 arg_list_optional: 
		/* Nothing */ {[]}
		| arg_list 	{$1}
 
	arg_list:
		typ_rule ID {[$1, $2]}
		| typ_rule ID COMMA arg_list {[$1, $2]::$4} 
 
	expr_list: 
		/* Nothing */ 		{[]}
		| expr 			{[$1]}
		| expr COMMA expr_list {$1::$3}
 
 function_body_rule:    
		/* Nothing */ {[]}
		| var_decl_rule function_body_rule {$1::$2}
		| stmt_rule function_body_rule {$1::$2}
 
 typ_rule: 
		INT 			{Int}   
		| INT_PTR 		{Int_ptr}    
		| DOUBLE 		{Double}
		| DOUBLE_PTR 	{DoublePtr}
		| CHAR 		{Char}
		| CHAR_PTR 		{CharPtr}
		| STRUCT 		{Struct} 
		| STRUCT_PTR 	{StructPtr}
		| STRING 		{String}
		| STRING_PTR 	{StringPtr}
		| VOID 		{Void}
		| VOID_PTR 		{VoidPtr}
	
 stmt_rule:
		expr_rule SEMI								{ Expr $1}
		| LBRACE function_body_rule RBRACE					{ Block $2}
		| IF LPAREN expr_rule RPAREN stmt_rule				{ If($3, $5, Block([]))}
		| IF LPAREN expr_rule RPAREN stmt_rule ELSE stmt_rule 	{ If($3,$5,$7)}
		| WHILE LPAREN expr_rule RPAREN stmt_rule			{ While($3, $5)}
		| FOR LPAREN expr_rule SEMI expr_rule SMEI expr_rule RPAREN stmt_rule 
												{ For($3, $5, $7, $9)}
		| RETURN SEMI								{ Return Noexpr}
		| RETURN expr SEMI							{ Return $2}
 
	expr_rule: 
		| INT_LITERAL					{ IntLit($1) }
		| CHAR_LITERAL					{ CharLit($1) }
		| STRING_LITERAL 					{ StringLit($1)}
		| ID							{ Id $1}
		| expr_rule PLUS expr_rule      		{ Binop ($1, Add, $3)   }
		| expr_rule MINUS expr_rule      		{ Binop ($1, Sub, $3)   }
		| expr_rule TIMES expr_rule      		{ Binop ($1, Mult, $3)   }
		| expr_rule DIVIDE expr_rule      		{ Binop ($1, Div, $3)   }
		| expr_rule MODULO expr_rule      		{ Binop ($1, Mod, $3)   }
		| expr_rule PLUSEQUAL expr_rule      	{ Binop ($1, Addeq, $3)   }
		| expr_rule MINUSEQUAL expr_rule      	{ Binop ($1, Subeq, $3)   }
		| expr_rule MULTEQUAL expr_rule      	{ Binop ($1, Multeq, $3)   }
		| expr_rule DIVEQUAL expr_rule      	{ Binop ($1, Diveq, $3)   }
		| expr_rule MODEQUAL expr_rule      	{ Binop ($1, Modeq, $3)   }
		| expr_rule EQ expr_rule      		{ Binop ($1, Eq, $3)   }
		| expr_rule NEQ expr_rule      		{ Binop ($1, Neq, $3)   }
		| expr_rule LT expr_rule      		{ Binop ($1, Lt, $3)   }
		| expr_rule LEQ expr_rule      		{ Binop ($1, Leq, $3)   }
		| expr_rule GT expr_rule      		{ Binop ($1, Gt, $3)   }
		| expr_rule GEQ expr_rule      		{ Binop ($1, Geq, $3)   }
		| expr_rule AND expr_rule      		{ Binop ($1, And, $3)   }
		| expr_rule OR expr_rule      		{ Binop ($1, Or, $3)   }
		| ID ASSIGN expr_rule      			{ Assign ($1, $3)   }
		| LPAREN expr_rule RPAREN			{ $2 }
		| MINUS expr 					{ Unop(Neg, $2)}
		| NOT expr 						{ Unop(Not, $2)}
		| expr PLUSPLUS					{ Plus($1, 1)}
		| PLUSPLUS expr 					{ Plus($2, 1)}
		| expr MINUSMINUS					{ Minus{$1, 1)}
		| MINUSMINUS expr					{ Minus($2, 1)}
		| TIMES expr					{ Unop(Deref, $2)}
		| REFERENCE expr					{ Unop(Ref, $2)}
		| LBRAC expr_list RBRAC 			{ ArrayLit($2)} 
		| ID LBRAC actuals_optional RPAREN		{ Call($1, $3) }
		| expr_rule DOT ID				{ StructMember($1, $3)}
 	  | LPAREN typ_rule RPAREN MALLOC LPAREN expr_rule RPAREN { Malloc($2, $6) }
		| FREE LPAREN ID RPAREN 			{ Free($3)}
		| NULL						{ Null } 
 
actuals_opt: 
	/* nothing */ { [] } 
	| actuals_list { $1 }
 
actuals_list: 
	expr { [$1] } 
	| expr COMMA actuals_list{$1 :: $3}
```

## References

http://www.cs.columbia.edu/~sedwards/classes/2016/4115-fall/lrms/rusty.pdf

https://www.tutorialspoint.com/cprogramming/c_operators.htm

https://futhark.readthedocs.io/en/latest/language-reference.html#primitive-types-and-values