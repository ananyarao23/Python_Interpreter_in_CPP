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
    expression* expr;
	const_as_op* cao;
    stat* stmt;
	vector<stat*> *stmt_list;
	vector<expression*> *exp_list;
	vector<name*> *arg_list;
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
%type <name> INT_CONST
%type <name> FLT_CONST
%type <name> NAME STRING
%type <expr> expression prefix rel_exp
%type <stmt> statement
%type <stmt_list> block_statement statement_list
%type <exp_list> exp_list
%type <arg_list> args
%type <cao> constant_as_operand

%start program // Starting rule for the grammar
%%

/* GRAMMAR */

program
	: statement_list						{ $1->code(); }
	;

statement_list
	: statement_list statement				{ $$ = append_stmt($1,$2); }
	| statement								{ $$ = append_stmt(nullptr,$1); }
	;	

block_statement
	: '{' statement_list '}'				{ $$ = $2; }
	;

function
	: FN '(' args ')' block_statement
	;

func_call
	: NAME '(' exp_list ')'
	;

exp_list
	: exp_list ',' expression				{ $$ = append_exp($1,$2); }
	| expression							{ $$ = append_exp(nullptr,$1); }
	;

args
    : args ',' NAME							{ $$ = append_args($1, $3); }
    | NAME									{ $$ = append_args(nullptr, $1); }
    ;

statement
	: let_statement							{ $$ = new stat($1); }
	| assignment_statement					{ $$ = new stat($1); }
	| return_statement						{ $$ = new stat($1); }
	| if_statement							{ $$ = new stat($1); }
	| exp_statement							{ $$ = new stat($1); }
	;


let_statement
	: LET NAME '=' expression ';'    {const_as_op* x = new const_as_op($4->evaluate()); symbol_table[*($2)] = x;}
	;

assignment_statement
	: NAME '=' expression ';'        {const_as_op* x = new const_as_op($4->evaluate()); symbol_table[*($2)] = x;}
	;

exp_statement
	: expression ';'				{const_as_op* x = new const_as_op($4->evaluate()); cout << x->val <<'\n';}
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
	| rel_exp						{$$ = new expression($1);}
	| '(' expression ')'			{$$ = $2;}
	| function						
	| func_call						{$$ = new expression($1);}
	| NAME							{$$ = new expression($1);}
	| constant_as_operand			{$$ = new expression($1);}
	;

prefix
	: '-' expression %prec Uminus
	| '!' expression
	;

rel_exp
	: expression '+' expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression '-' expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression '*' expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression '/' expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression '%' expression			{$$ = new rel_expression($1,*($2),$3);}			
	| expression EQ expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression NE expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression '<' expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression LE expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression '>' expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression GE expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression AND expression			{$$ = new rel_expression($1,*($2),$3);}
	| expression OR expression			{$$ = new rel_expression($1,*($2),$3);}
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
	: INT_CONST				{$$ = new const_as_op(atoi($1->c_str()));}
	| TRUE_CONST			{$$ = new const_as_op(true);}
	| FALSE_CONST			{$$ = new const_as_op(false);}
	| STRING				{$$ = new const_as_op(*($1));}
	| NULL_VAL				{$$ = new const_as_op(nullptr);}
	; 
// new object
%%

/* ADDITIONAL C CODE */

int main() { // here's our main function, where it all starts
	yyparse();
	return 0;
}