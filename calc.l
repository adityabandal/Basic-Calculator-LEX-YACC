%{
#include "y.tab.h"
void yyerror (char *s);
int yylex();
%}
%%
"print"				   {return print;}
"exit"				   {return exit_command;}
"if"                   {printf("lex %s\n",yytext);return IF;}
"else"                 {printf("lex %s\n",yytext);return ELSE;}
[a-z][_a-z0-9]*		   {
                        char *c = (char*)malloc(sizeof(char)*(yyleng+1));
                        strcpy(c,yytext);
                        yylval.id = c; return identifier;
                        }
[0-9]*[.]?[0-9]*  {yylval.num = atof(yytext);printf("lex1 %f\n",yylval.num); return number;}
[ \t\n]                ;
[-+=*\/;()&|]           	   {printf("lex2 %s\n",yytext);return yytext[0];}
"{"                     {printf("lex3 %s\n",yytext);return yytext[0];}
"}"                     {printf("lex4 %s\n",yytext);return yytext[0];}

\/\*.*([\n])([^*]|\*+[^*/])*\*+\/          {printf("Commented");}


.                      {ECHO; yyerror ("unexpected character");}



%%
int yywrap (void) {return 1;}

