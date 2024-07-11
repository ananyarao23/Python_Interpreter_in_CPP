%{
	// Declarations (C++ code)
	#include "mic.hh"
	extern "C" void yyerror(const char *s);
	extern int yylex(void);
	extern map<string, double> table;
%}

%union {
	string* name;
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
%token STR_CONST
%token NAME STRING
%token TRUE_CONST FALSE_CONST LET RETURN IF ELSE FN AND OR NE EQ GE LE IFX NULL_VAL

%left '+' '-' '>' '<' '%' OR AND GE LE NE EQ '!'// Left associative operators '+' and '-'
%left '*' '/' // Left associative operators '*' and '/'
%right Uminus // Right associative unary minus operator
%right ';'
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

/* func_stmt
    : RETURN expression ';'
    | statement_list RETURN expression ';'
	; */

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
/* 
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
	;  */

constant_as_operand
	: INT_CONST
	| TRUE_CONST
	| FALSE_CONST
	| STRING
	| NULL_VAL
	; 
// new object
%%

/* ADDITIONAL C CODE */

int main() { // here's our main function, where it all starts
	yyparse();
	return 0;
}