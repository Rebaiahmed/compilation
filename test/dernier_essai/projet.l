%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "projet.tab.h"
	#include <math.h>
unsigned int lineno=1;



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
"u" { return UNIO ;}
"n" {return INTER ;}
"APP" {return APPART ;}
"\\" { return prive ;}
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


