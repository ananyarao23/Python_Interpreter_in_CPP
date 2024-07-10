%{
	// Declarations (C++ code)
	#include "mic.cc"
	extern "C" void yyerror(const char *s);
	extern int yylex(void);
	extern map<string, double> table;
%}

%union{
	string *name;	
	Expression *exp;
}

%token INT_CONST FLT_CONST NAME NULL// Token declarations (lexer uses these declarations to return tokens)
%token STRING TRUE_CONST FALSE_CONST LET RETURN IF ELSE FN AND OR NE EQ GE LE IFX// Declare additional tokens

%left '+' '-' // Left associative operators '+' and '-'
%left '*' '/' // Left associative operators '' and '/'
%right Uminus // Right associative unary minus operator

%type <name> INT_CONST FLT_CONST NAME STRING TRUE_CONST FALSE_CONST NULL // Declare token types to be of type *string
%type <exp> expression // Declare the expression non-terminal to be of type *Expression
%type <prg> program
%type <stat> statement
%type <statl> statement_list
%type <lstat> let_statement
%type <astat> assignment_statement
%type <bstat> block_statement
%type <func> function
%type <funcc> func_call
%type <funcd> func_def
%type <rstat> return_statement
%type <istat> if_statement
%type <estat> exp_statement

%type <expl> exp_list
%type <a> args


%start program // Starting rule for the grammar
%%

/* GRAMMAR */

program
	: statement_list
	;

statement_list
	: statement_list statement
	| statement
	;

block_statement
	: '{' statement_list '}'
	;

function
	: FN '(' args ')' block_statement
	;

func_call
	: NAME '(' exp_list ')'
	;

exp_list
	: exp_list ',' expression
	| expression
	;

args
    : args ',' NAME
    | NAME
    ;

statement
	: let_statement
	| assignment_statement
	| return_statement
	| if_statement
	| exp_statement
	| func_def 
	| func_call 
	;

func_def
	: NAME '(' args ')' block_statement 
	;

let_statement
	: LET NAME '=' expression ';'
	;

assignment_statement
	: NAME '=' expression ';'
	;

exp_statement
	: expression ';'
	;

return_statement
	: RETURN expression ';'
	;

func_stmt
    : RETURN expression ';'
    | statement_list RETURN expression ';' 


if_statement
	: IF '(' expression ')'  block_statement ELSE block_statement
	| IF '(' expression ')'  block_statement %prec IFX
	;

expression
	: prefix
	| rel_exp
	| '(' expression ')'
	| function
	| func_call
	| NAME
	| constant_as_operand
	;

prefix
	: '-' expression %prec Uminus
	| '!' expression
	;

rel_exp
	: expression '+' expression
	| expression '-' expression
	| expression '*' expression
	| expression '/' expression
	| expression '%' expression
	| expression EQ expression
	| expression NE expression
	| expression '<' expression
	| expression LE expression
	| expression '>' expression
	| expression GE expression
	| expression AND expression
	| expression OR expression
	;

dict
	: '{' dict_list '}'
	; 

dict_list
	: dict_list ',' dict_item
	| dict_item
	;

dict_item
	: STRING ':' constant_as_operand
	;

array
	: '[' array_list ']'
	;

array_list
	: array_list ',' item
	| item
	;

item
	: constant_as_operand
	| array
	| dict
	; 

constant_as_operand
	: INT_CONST
	| FLT_CONST
	| TRUE_CONST
	| FALSE_CONST
	| STRING
	; 
// new object
%%

/* ADDITIONAL C CODE */

int main() { // here's our main function, where it all starts
	yyparse();
	return 0;
}
