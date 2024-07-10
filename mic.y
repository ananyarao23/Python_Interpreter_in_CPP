%{
	// Declarations (C++ code)
	#include "mic.hh"
	extern "C" void yyerror(const char *s);
	extern int yylex(void);
	extern map<string, double> table;
%}

%union {
    int intVal;
    double floatVal;
    std::string* strVal;
    ExprPtr expr;
    FuncPtr func;
    FuncCallPtr funcCall;
    StmtPtr stmt;
}

%token INT_CONST
%token FLT_CONST
%token NAME STRING
%token TRUE_CONST FALSE_CONST LET RETURN IF ELSE FN AND OR NE EQ GE LE IFX NULL_VAL

%left '+' '-' // Left associative operators '+' and '-'
%left '*' '/' // Left associative operators '*' and '/'
%right Uminus // Right associative unary minus operator

/* %type <intVal> INT_CONST
%type <floatVal> FLT_CONST
%type <strVal> NAME STRING
%type <expr> expression prefix rel_exp
%type <func> function
%type <funcCall> func_call
%type <stmt> statement */

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
	/* | func_def */
	/* | func_call */
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
/* 
func_stmt
    : RETURN expression ';'
    | statement_list RETURN expression ';' */


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
	| INT_CONST
	| FLT_CONST
	| STRING
	| TRUE_CONST
	| FALSE_CONST
	| NULL_VAL
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

/* dict
	: LBRACE dict_list RBRACE
	; 

dict_list
	: dict_list COMMA dict_item
	| dict_item
	;

dict_item
	: STRING COLON constant_as_operand
	;

array
	: LBRACKET array_list RBRACKET
	;

array_list
	: array_list COMMA item
	| item
	;

item
	: constant_as_operand
	| array
	| dict
	; */

/* constant_as_operand
	: INT_CONST
	| BOOL
	| STRING
	; */
// new object
%%

/* ADDITIONAL C CODE */

int main() { // here's our main function, where it all starts
	yyparse();
	return 0;
}