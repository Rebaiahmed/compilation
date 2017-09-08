%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "test.tab.h"
	#include <math.h>
unsigned int lineno=1;

#define YY_INPUT(buf,result,max_size)  {\
    result = GetNextChar(buf, max_size); \
    if (  result <= 0  ) \
      result = YY_NULL; \
    }


%}

blan [\n\t ]+
Chiffre [0-9]
CHE [1-2]{Chiffre}|(30)|[1-9]
CHA {Chiffre}+
LettreMin [a-z]
LettreMaj [A-Z]
IDvar {LettreMin}+
IDens {LettreMaj}+

%%

"comp"	{return COMP;}
"card"	{return CARD;}
"==" { return AFFICHE ;}
"|" { return UNIO ;}
"&" {return INTER ;}
"/" { return prive ;}
{IDvar} {yylval.integer = (yytext[0]-'a'); return IDV ; } 
{IDens} {yylval.integer = (yytext[0]-'A'); return IDE ; }
[-/()*+=,{}] {return yytext[0] ; }
";"	return END;
{CHE} {yylval.integer = pow(2,atoi(yytext)); return CHIF;}
{CHA} {yylval.integer = atoi(yytext); return CHIFA;}
{blan} 
.   

%%

int yywrap(){return 1;}


