%{
		// Declarations (C++ code)

    #include "pic.cc"
    extern "C" void yyerror(const char *s);
    extern int yylex(void);
		extern map<string, double> table;
%}

%union{
	string *name;	
	Expression *exp;
}

%token INT_CONST FLT_CONST NAME 					// Token declarations (lexer uses these declarations to return tokens)

%left '+' '-' 														// Left associative operators '+' and '-'
%left '*' '/' 														// Left associative operators '*' and '/'
%right Uminus 														// Right associative unary minus operator

%type <name> INT_CONST FLT_CONST NAME 		// Declare token types to be of type *string
%type <exp> expression 										// Declare the expression non-terminal to be of type *Expression

%start program 														// Starting rule for the grammar
%%

/* GRAMMAR */

func_call
    : 

func_def
    : func_name LPAREN param RPAREN compound_statement

param
    : NAME
    | param COMMA NAME

assignment_statement
    : variable_as_operand ASSIGN expression SEMICOLON
    | variable_as_operand ASSIGN func_call compound_statement
;

if_statement
    : IF if_condition compound_statement ELSE compound_statement
    | IF if_condition compound_statement

if_condition
    : LPAREN expression RPAREN 

compound_statement
    : LBRACE statement_list RBRACE

expression
    : expression ADD expression
    | expression MINUS expression
    | expression ASTERISK expression
    | expression SLASH expression
    | LPAREN expression RPAREN
    | MINUS expression
    | variable_as_operand
    | constant_as_operand
    | rel_expression
    | expression AND expression
    | expression OR expression
    | NOT expression
;

rel_expression
    : expression LT expression
    | expression LE expression
    | expression GT expression
    | expression GE expression
    | expression NE expression
    | expression EQ expression
;

variable_as_operand
    : variable_name
;

variable_name
    : NAME
;

dict
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

item:
    : constant_as_operand
    | array
    | dict
;

constant_as_operand
    : INT
    | BOOL
    | STRING
;

%%

/* ADDITIONAL C CODE */

int main() { // here's our main function, where it all starts
  yyparse();
  return 0;
}