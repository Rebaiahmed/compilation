%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <math.h>
#include "test.tab.h"
int yylex(void);
void yyerror(char*);
extern FILE* yyin;

bool error_syntaxical=false;
extern unsigned int lineno;

//***déclaration tableau de symboles***************//
 char letters[26] =  {'A','B','C','D','E','F','G','H','I','J','K','L',
        'M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'};

//***déclaration tableauw de valeurs correspondant***********//
int values[26] ={-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1};
int somme = 0;

           int yylex();
	int aminz[26] = { 0 };
	int AmajZ[26] = { 0 };


%}

%union {int integer;char *str;}



%token IDENT T_PLUS T_MOINS T_MULTIPL T_DIV T_PUIS T_QUIT T_NEWLINE T_ERROR T_INTER T_UNION T_DIFF T_CARD T_COMPL T_AFFECT T_INT T_arith 
%token '(' ')' '{' '}' ',' '\n' '='
%token END 

%type <integer> T_INT  nbr ensemble expr_arth expr_ens val  T_arith IDENT

   /* prioritÃ© et ordre d'evaluation */
%left T_UNION T_DIFF
%left T_INTER
%left T_COMPL





%start exprs ;
%%

exprs:  /* EMPTY */
                          | exprs expr END
                          ;
		




nbr : T_INT { 
         
              $$ = $1 ; }
	| T_INT ',' nbr { $$= ($1 | $3); }
; 





 ensemble : IDENT {  

$$ = AmajZ[$1]; }
	| '{' nbr '}' {  $$ = $2; }
	;



expr_ens : ensemble { 
printf("ensemble \n");
$$ = $1; }
	| ensemble T_UNION expr_ens  { $$ = $1 | $3; }
	| ensemble T_INTER expr_ens { $$ = $1 & $3; }
	| T_COMPL expr_ens	{ $$ = (~$2);}
	| ensemble T_DIFF expr_ens { $$ = $1 & (~$3); }
        | '(' expr_ens ')'  { $$ = $2; }
	| '(' expr_ens ')' T_UNION expr_ens { $$ = $2 | $5; }
	| '(' expr_ens ')' T_INTER expr_ens { $$ = $2 & $5; }
	| '(' expr_ens ')' T_DIFF expr_ens { $$ = $2 & (~$5); }

;


val     : T_arith { $$ = $1; }
	| T_INT { $$ = $1; /* problem si val < 30  */  }
	| IDENT {  $$ = AmajZ[$1];}
	| T_CARD expr_ens	{ $$ = Caclul_Cardinal($2);}
	;






expr_arth: T_arith { 

$$ = $1; }
	| T_arith '+' expr_arth	 { $$ = $1 + $3; }
	| T_arith '-' expr_arth { $$ = $1 - $3; }
	| T_arith '*' expr_arth { $$ = $1 * $3; }
	| T_arith '/' expr_arth { $$ = $1 / $3; }
        | T_CARD expr_ens	{ $$ = Caclul_Cardinal($2); printf("card"); }
	| '(' expr_arth ')' { $$ = $2; }
	| '(' expr_arth ')' '+' expr_arth { $$ = $2; }
	| '(' expr_arth ')' '-' expr_arth { $$ = $2; }
	| '(' expr_arth ')' '*' expr_arth { $$ = $2; }
	| '(' expr_arth ')' '/' expr_arth { $$ = $2; }
	;



expr:   IDENT '=' expr_arth			{ 
printf("affecttation arithmétique \n");
//AmajZ[$1] = $3; 
}
		| IDENT '=' expr_ens			{ printf("affecttation arithmétique \n"); AmajZ[$1] = $3; }
		| IDENT "=="			{ printf("%c = ",($1+65)); 
                                                 affiche(AmajZ[$1]); }
		;


;


%%


//********fonction pour récuperer la valeur associée a un symbole*************//

int getValue(char c)
{

int i=0;
int value=0 ;
for(i=0;i<26;i++)
{
if(letters[i]=c)
{
value =values[i] ;
}
}
return value ;
}

//***********fonction pour afficher les eléments d'une liste*****************
void affiche(int s)
{
 int compteur =0;
  int virgule = 0;
  printf("{");
   while ( s !=0 )
  {
    if (s % 2 ==1)
    {
       printf(",");
       printf("%d", compteur);
       
    }
//incrémenter le compteur
compteur++;
//diviser le nombre par 2
 s = s /2 ;
  }
  printf("}\n");


}



//****************fonction pour calculer la cardinalité d"un ensemble*****************//

int Caclul_Cardinal(int s)
{

int card = 0 ;

while (s !=0) 
{

if (s %2 ==1)
{
card ++;
}
s = s / 2 ;
}

return card ;
}


//***********fonction pour affciher le complementaire d'un ensemble*******************//

int complementaire(int c)
{
//initializer l'entier globale **************//
int max = 2147483647;
//printf("complementaire");
return max - c;
}




//****************fonction pour mettre la valeur de l'indetnifcateur dans le tableau******

void SetValue(int indice,int valeur)
{

//printf("indice est %d ",indice);
  if(indice <0 || indice >25)
  {
   printf("impossible ");
   }

values[indice] = valeur ;
}









int main(void) { 
 printf("Debut de l'analyse syntaxique :\n");
        yyparse();
        /*printf("Fin de l'analyse !\n");
        printf("Resultat :\n");
        /*if(error_lexical){
                printf("\t-- Echec : Certains lexemes ne font pas partie du lexique du langage ! --\n");
                printf("\t-- Echec a l'analyse lexicale --\n");
        }
        else{
                printf("\t-- Succes a l'analyse lexicale ! --\n");
        }*/
        /*if(error_syntaxical){
                printf("\t-- Echec : Certaines phrases sont syntaxiquement incorrectes ! --\n");
                printf("\t-- Echec a l'analyse syntaxique --\n");
        }
        else{
                printf("\t-- Succes a l'analyse syntaxique ! --\n");
        }
        return EXIT_SUCCESS;*/



return yyparse(); }


void yyerror(char *s) {
        fprintf(stderr, "Erreur de syntaxe a la ligne %d: %s\n", lineno, s);
}

