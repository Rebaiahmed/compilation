%{
	
	#include "projet.tab.h"
	#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
	int yylex();
	int aminz[26] = { 0 };
	int AmajZ[26] = { 0 };
extern unsigned int lineno;

int max = 2147483647;

#define YYERROR_VERBOSE 1
/*
#define YYDEBUG 1
*/
static Variable *var;

%}

%union {int integer;char *str;}

%token COMP
%token CARD
%token IDV
%token IDE
%token CHIFA
%token CHIF
%token END
%token UNIO
%token INTER 
%token prive 
%token AFFICHE 


%type <integer> CHIF CHIFA nbr ensemble expr_arth expr_set val IDV IDE ENDL

%left T_UNION T_DIFF
%left T_INTER
%left T_COMPL

%error-verbose

%start exprs

%%

exprs:  exprs expr 
		| expr 
                | expr error        '\n' { eat_to_newline(); }
        ;

nbr : CHIF { $$ = $1 ; }
	| CHIF ',' nbr { $$= ($1 | $3); }
; 

ensemble : IDE {  $$ = AmajZ[$1]; }
	| '{' nbr '}' {  $$ = $2; }
	;

expr_set : ensemble { $$ = $1; }
	| ensemble UNIO expr_set  { $$ = $1 | $3; }
	| ensemble INTER expr_set { $$ = $1 & $3; }
	| ensemble prive expr_set { $$ = $1 & (~$3); }
        | CARD '(' expr_set ')'	{ $$ = nbrCard($3); 
                     printf("card"); }

         | COMP '(' expr_set ')'	{ $$ = max -$3 ; 
                     printf("comp"); }
	| '(' expr_set ')'  { $$ = $2; }
	| '(' expr_set ')' UNIO expr_set { $$ = $2 | $5; }
	| '(' expr_set ')' INTER expr_set { $$ = $2 & $5; }
	| '(' expr_set ')' prive expr_set { $$ = $2 & (~$5); }
        ,

; 

val : CHIFA { $$ = $1; }
	| CHIF { $$ = (int) (log ($1) / log(2)) ; }
	| IDV {  $$ = aminz[$1];}
	
	;
 
expr_arth: val { $$ = $1; }
	| val '+' expr_arth	 { $$ = $1 + $3; }
	| val '-' expr_arth { $$ = $1 - $3; }
	| val '*' expr_arth { $$ = $1 * $3; }
	| val '/' expr_arth { $$ = $1 / $3; }
	
	| '(' expr_arth ')' { $$ = $2; }
	| '(' expr_arth ')' '+' expr_arth { $$ = $2 + $5; }
	| '(' expr_arth ')' '-' expr_arth { $$ = $2 - $5; }
	| '(' expr_arth ')' '*' expr_arth { $$ = $2 * $5; }
	| '(' expr_arth ')' '/' expr_arth { $$ = $2 / $5; }
	;

expr:   IDV '=' expr_arth			{ aminz[$1] = $3; }
		| IDE '=' expr_set			{  printf("$1 est %d \n",AmajZ[$1]);
                                                 AmajZ[$1] = $3; }
		| IDE AFFICHE			{ printf("%c = , %d \n",($1+65),AmajZ[$1]); showNbr(AmajZ[$1]); }
		| IDV AFFICHE			{ printf("%c = %d\n",($1+97),aminz[$1]); }
		;

%%

void showNbr(int x){
	printf("{");
	long i=0;
	while(x!=0){
		if((x%2)!=0){
			printf(" %d ",i);
		}
		x=x/2;
		i++;	
	}
	printf("}\n");
}



//***********************************//


int nbrCard(int x){
	int i=0;
	while(x!=0){
		if((x%2)!=0){
			i++;
		}
		x=x/2;	
	}
	printf("\n");
	return i;
}


//*************************************//
void eat_to_newline(void)
{
    int c;
    while ((c = getchar()) != EOF && c != '\n')
        ;
}

//******************************//


int complementaire(int c)
{
//initializer l'entier globale **************//
int max = 2147483647;
//printf("complementaire");
return max - c;
}

int main(void) {
    //yyparse();
    return yyparse();
}


void yyerror(char *s) {
        fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}
