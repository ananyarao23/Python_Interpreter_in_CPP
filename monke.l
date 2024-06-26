%{
#include "monke.hh"
#include "parse.tab.h"
using namespace std;

extern YYSTYPE yylval;  // Assuming YYSTYPE is defined in parse.tab.h for semantic values
%}

/* DEFINITIONS */

/* yywrap handles the end-of-input logic, if noyywrap is used, program exits on end-of-file (EOF) */
%option noyywrap 

digit       [0-9]
fraction    (-?[0-9]*\.[0-9]+|[0-9]+\.[0-9]*)
letter      [a-zA-Z_]
ws          [ \t\n]*

/* RULES */

%%
"fn"        { yylval.name = strdup(yytext); return FUNCTION; }
"let"       { yylval.name = strdup(yytext); return LET; }
"true"      { yylval.name = strdup(yytext); return TRUE_CONST; }
"false"     { yylval.name = strdup(yytext); return FALSE_CONST; }
"if"        { yylval.name = strdup(yytext); return IF; }
"else"      { yylval.name = strdup(yytext); return ELSE; }
"return"    { yylval.name = strdup(yytext); return RETURN; }

"="         { return ASSIGN; }
"+"         { return PLUS; }
"-"         { return MINUS; }
"!"         { return BANG; }
"*"         { return ASTERISK; }
"/"         { return SLASH; }
"<"         { return LT; }
">"         { return GT; }
"=="        { return EQ; }
"!="        { return NOT_EQ; }
","         { return COMMA; }
";"         { return SEMICOLON; }
":"         { return COLON; }
"("         { return LPAREN; }
")"         { return RPAREN; }
"{"         { return LBRACE; }
"}"         { return RBRACE; }
"["         { return LBRACKET; }
"]"         { return RBRACKET; }

-?{digit}+    { yylval.name = strdup(yytext); return INT_CONST; }
{fraction}    { yylval.name = strdup(yytext); return FLT_CONST; }
{letter}({letter}|{digit})*				{ yylval.name = new string(yytext); return STR_CONST; }
\"([^\"]*)\" { yylval.name = strdup(yytext); return STR_CONST; }

\n          { return NEWLINE; }
{ws}        ;  /* Ignore whitespace */
.           { fprintf(stderr, "unknown_token: %s\n", yytext); exit(1); }
%%

int yywrap() {
    return 1;  // Indicates we have no more input
}
