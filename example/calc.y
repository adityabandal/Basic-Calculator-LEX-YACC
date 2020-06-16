/* Put new code here */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <ctype.h>
    int yyerror(char *s);
    extern int linenum;
%}

/* define all types of variables and terminals */

%union
{
  int int_val;
  char *str_val;
}

/* define the individual types of variables and terminals */

%token PRINT
%token NEWLINE
%token IF
%token THEN
%token ELSE
%token ENDIF
%token <str_val> STRING
%token <int_val> INT
%type <int_val> expr

/* assign priorities to operators in order to avoid shift/reduce conflicts (grammar ambiguities) */

%left '+' '-'
%left '*' '/'
%left '<' '>'
%left UMINUS

/* the start variable of your program */

%start program

%%

program : stmt_list 
        | error       {printf("YACC: syntax error near line %d \n", linenum);
                       abort();}
        ;

stmt_list : stmt_list stmt
          | stmt
          ; 

stmt    :   print_stmt
        |   if_stmt

print_stmt  : expr ';'              {printf("expression found\n");} 
            | PRINT expr ';'        {if (top() == 1) then {printf("%d", $2);}}
            | PRINT STRING ';'      {printf("%s", $2);} 
            | PRINT NEWLINE ';'     {printf("\n");}

if_stmt : IF expr THEN {top()==1 ? push($2!=0) : push(0);} stmt_list {pop();}
        | ELSE {top()==1 ? push($2==0) : push(0);} stmt_list {pop();} ENDIF

expr : '(' expr ')'     {$$ = $2;}
     | expr '+' expr    {$$ = $1 + $3;}
     | expr '-' expr    {$$ = $1 - $3;}
     | expr '*' expr    {$$ = $1 * $3;}
     | expr '/' expr    {$$ = $1 / $3;}
     | expr '<' expr    {$$ = $1 < $3;}
     | expr '>' expr    {$$ = $1 > $3;}
     | expr '<=' expr    {$$ = $1 >= $3;}
     | expr '>=' expr    {$$ = $1 <= $3;}
     | expr '==' expr    {$$ = $1 == $3;}
     | expr '!=' expr    {$$ = $1 != $3;}
     | '-' expr         %prec UMINUS {$$ = -$2;}
     | INT              {$$ = $1;}
     ;

%%

/* link lex code */
/* #include "lex.yy.c" */
/* insert additional code here */

int main(void)
{
    return yyparse();
}

int yyerror(char *s)
{
    fprintf(stderr, "%s \n",s);
}