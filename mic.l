%{
#include "mic.hh"
#include "parse.tab.h"
using namespace std;
%}

/* Definitions */

/* yywrap handles the end-of-input logic, if noyywrap is used, program exits on end-of-file (EOF) */
%option noyywrap 

digit       [0-9]
fraction    (-?[0-9]*\.[0-9]+|[0-9]+\.[0-9]*)
letter      [a-zA-Z_]
ws          [ \t\n]*

/* Rules */

%%
fn        { return FN; }
let       { return LET; }
true      { return TRUE_CONST; }
false     { return FALSE_CONST; }
if        { return IF; }
else     { return ELSE; }
return    { return RETURN; }
null        { return NULL_VAL; }

"=="        { return EQ; }
"!="        { return NE; }
"<="        { return LE; }
">="        { return GE; }
"&"           { return AND; }
"|"          { return OR; }


-?{digit}+    { yylval.strVal = new string(yytext); return INT_CONST; }
{fraction}    { yylval.strVal = new string(yytext); return FLT_CONST; }
{letter}({letter}|{digit})*  { yylval.strVal = new string(yytext); return STR_CONST; }
\"([^\"]*)\" { yylval.strVal = new string(yytext); return STRING; }

{ws}        ;  /* Ignore whitespace */
.           { fprintf(stderr, "unknown_token: %d\n", yytext[0]); exit(1); }
