%option noyywrap
%{
/* need this for the call to atof() below */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include "test.tab.h"
#define YY_DECL int yylex()
unsigned int lineno=1;
bool error_lexical=false;
%}

DIGIT    [0-9]
IDENT  [A-Z]
CHA {DIGIT}+
SPACE [ \t]*
COMM "#"[^\n]*

%%

{IDENT}	  	{ yylval.integer = (yytext[0]-65);return IDENT ;}
                  
                   
[1-2]?[0-9] | 30 { yylval.integer = pow(2,atoi(yytext)); return T_INT;}
                           
{CHA}    { yylval.integer = atoi(yytext);  return  T_arith ; }
       
":="	{  return T_AFFECT ; }
"+"     {  return T_PLUS;  }
"-"    { return T_MOINS; }

"*"   { return T_MULTIPL;  }
"/"   { return T_DIV; }

"^"  {  return T_PUIS ; }
"exit"		{return T_QUIT;}
"quit" {return T_QUIT;}
{COMM}		;
{SPACE}		;

comp	       {  return T_COMPL ; }
CARD           {  return T_CARD ; }
DIFF           {  return T_DIFF ; }
UNION           {  return T_UNION ; }
INTER          {  return T_INTER ; }
[=(){},]	return yytext[0];
";"	return END;
. 		{
        fprintf(stderr,"\tERREUR : Lexeme inconnu a la ligne %d. Il s'agit de %s et comporte %d lettre(s)\n",lineno,yytext,yyleng);
        error_lexical=true;
        return yytext[0];
}

%%


