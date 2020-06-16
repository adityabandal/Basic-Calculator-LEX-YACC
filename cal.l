%{
#include <stdlib.h>
#include "cal.h"
#include "y.tab.h"
void yyerror(char *);
%}

%%
\/\*.*([\n])([^*]|\*+[^*/])*\*+\/          {printf("Commented Detected\n");}
[a-z]       { 
                yylval.sIndex = *yytext - 'a';
                return VARIABLE;
            }

0[.]?[0-9]*           {
                yylval.iValue = atof(yytext);
                return INTEGER;
            }

[1-9][0-9]*[.]?[0-9]* {
                yylval.iValue = atof(yytext);
                return INTEGER;
            }

[-()<>=+*/;{}.] {
                return *yytext;
             }
"&&"			return AND;
"||"			return OR;
"!"				return NOT;
"++"			return INC;
"--"			return DEC;
">="            return GE;
"<="            return LE;
"=="            return EQ;
"!="            return NE;
"while"         return WHILE;
"for"			return FOR;
"if"            return IF;
"else"          return ELSE;
"print"         return PRINT;
"scan"			return SCAN;

[ \t\n]+        ;       /* ignore whitespace */

.               yyerror("Unknown character");
%%
int yywrap(void) {
    return 1;
}
