%{
void yyerror (char *s);
int yylex();
#include <stdio.h>     /* C declarations used in actions */
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#define SIZE 10
typedef struct symbols_tag{
	char *name;
	float val;
}symbol;
int size = 0;
symbol symbols[SIZE];
float symbolVal(char* symbol);
void updateSymbolVal(char* symbol, float val);
int top_if = 1,top_else = 0;

%}

%union {float num; char *id;}         /* Yacc definitions */
%start line
%token print 
%nonassoc IF  
%nonassoc ELSE 
%token exit_command
%token <num> number
%token <id> identifier
%type <num> line exp term bool
%type <id> assignment
%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

%%

/* descriptions of expected inputs     corresponding actions (in C) */

line    : assignment ';'		{;}
		| '{' line '}' 		{printf("curly");}
		| line '{' line '}' 		{printf("curly -");}
		| exit_command ';'		{exit(EXIT_SUCCESS);}
		| print exp ';'			{printf("Printing %f\n", $2);}
		| line assignment ';'	{printf("checked\n");}
		| line print exp ';'	{printf("Printing %f\n", $3);}
		| line exit_command ';'	{exit(EXIT_SUCCESS);}
		| IF exp line ';' {printf("if +++++++ ");if($2){$$=$3;printf("if passed");}else{printf("if failed");} }
		| line IF exp line ';' {printf("if ++++++- "); if($3){$$=$4;printf("if passed");}else{printf("if failed");}}
		| IF exp line ';' ELSE line ';' {printf("if_e_i ++++++- "); if($2){$$=$3;printf("if_e_i passed");}else{$$=$6;printf("if_e_e passed");}}
		| line IF exp line ';' ELSE line ';' {printf("if_e_i ++++++- "); if($3){$$=$4;printf("if_e_i passed");}else{$$=$7;printf("if_e_e passed");}}
		| exp ';'				{printf("Arithmetic ++++++++++++++++++%f\n",$1);}
		| line exp ';'			{printf("Arithmetic +++++++++++++++++-%f\n",$2);}
		| number ';'			{printf("))%f\n",$1);}
        | ';'					{return 0;}
		;

// line_i    : assignment ';'		{;}
// 		| '{' line_i '}' 		{printf("curly");}
// 		| line_i '{' line_i '}' 		{printf("curly -");}
// 		| exit_command ';'		{exit(EXIT_SUCCESS);}
// 		| print exp ';'			{printf("Printing %f\n", $2);}
// 		| line_i assignment ';'	{printf("checked\n");}
// 		| line_i print exp ';'	{printf("Printing %f\n", $3);}
// 		| line_i exit_command ';'	{exit(EXIT_SUCCESS);}
// 		| IF exp line_i ';' {printf("if ++++++- ");if($2){$$=$3;printf("if passed");}else{printf("if failed");} }
// 		| line_i IF exp line_i ';' {printf("if ++++++- "); if($3){$$=$4;printf("if passed");}else{printf("if failed");}}
// 		| IF exp line_i ELSE exp line_i ';' {printf("if ++++++- "); }
// 		| line_i IF exp line_i ELSE exp line_i ';' {printf("if ++++++- "); }
// 		| exp ';'				{printf("Arithmetic ++++++++++++++++++%f\n",$1);}
// 		| line_i exp ';'			{printf("Arithmetic +++++++++++++++++-%f\n",$2);}
// 		| number ';'			{printf("))%f\n",$1);}
//         | ';'					{return 0;}
// 		;

// line_e    : assignment ';'		{;}
// 		| '{' line_e '}' 		{printf("curly");}
// 		| line_e '{' line_e '}' 		{printf("curly -");}
// 		| exit_command ';'		{exit(EXIT_SUCCESS);}
// 		| print exp ';'			{printf("Printing %f\n", $2);}
// 		| line_e assignment ';'	{printf("checked\n");}
// 		| line_e print exp ';'	{printf("Printing %f\n", $3);}
// 		| line_e exit_command ';'	{exit(EXIT_SUCCESS);}
// 		| IF exp line_e ';' {printf("if ++++++- ");if($2){$$=$3;printf("if passed");}else{printf("if failed");} }
// 		| line_e IF exp line_e ';' {printf("if ++++++- "); if($3){$$=$4;printf("if passed");}else{printf("if failed");}}
// 		| IF exp line_e ELSE exp line_e ';' {printf("if ++++++- "); }
// 		| line_e IF exp line_e ELSE exp line_e ';' {printf("if ++++++- "); }
// 		| exp ';'				{printf("Arithmetic ++++++++++++++++++%f\n",$1);}
// 		| line_e exp ';'			{printf("Arithmetic +++++++++++++++++-%f\n",$2);}
// 		| number ';'			{printf("))%f\n",$1);}
//         | ';'					{return 0;}
// 		;

assignment : identifier '=' exp  {if((top_if == 1 && top_else == 0) || (top_if == 0 &&top_else == 1)){updateSymbolVal($1,$3);}}
			;
exp    	: term                 {$$ = $1;}
       	| exp '-' exp          {$$ = $1 - $3;printf("yacc2 %f\n",$$);top_if = $$;top_else = !top_if;}
       	| exp '*' exp          {$$ = $1 * $3;printf("yacc3 %f\n",$$);top_if = $$;top_else = !top_if;}
       	| exp '/' exp          {$$ = $1 / $3;printf("yacc4 %f\n",$$);top_if = $$;top_else = !top_if;}
		| exp '+' exp          {$$ = $1 + $3;printf("yacc1 %f\n",$$);top_if = $$;top_else = !top_if;}
		// | '(' exp ')'         {$$ = $2;printf("yacc44 %f\n",$$);top_if = $$;top_else = !top_if;}
		| exp '&''&' exp       {$$ = $1 && $4;printf("Bool %d\n",$$);top_if = $$;top_else = !top_if;}
		| exp '|''|' exp      {$$ = $1 || $4;printf("Bool %d\n",$$);top_if = $$;top_else = !top_if;}
		| '!' exp          	   {$$ = !$2;printf("yacc7 %f\n",$$);top_if = $$;top_else = !top_if;}
		// | '(' bool ')'         {$$ = $2;printf("yacc55 %f\n",$$);top_if = $$;top_else = !top_if;}
       	;

// bool 	: term					{$$ = $1;}
// 		| bool '&''&' bool       {$$ = $1 && $4;printf("yacc5 %f\n",$$);}
// 		| bool '|''|' bool      {$$ = $1 || $4;printf("yacc6 %f\n",$$);}
// 		| '!' bool          	   {$$ = !$2;printf("yacc7 %f\n",$$);}
// 		| '(' bool ')'         {$$ = $2;printf("yacc55 %f\n",$$);}
//        	;

term   	: number                {$$ = $1;}
		| identifier			{printf("---%s---\n",$1); $$ = symbolVal($1);} 
        ;

%%                     /* C code */

/*
int computeSymbolIndex(char token)
{
	int idx = -1;
	if(islower(token)) {
		idx = token - 'a' + 26;
	} else if(isupper(token)) {
		idx = token - 'A';
	}
	return idx;
} 
*/

/* returns the value of a given symbol */
float symbolVal(char* symbol)
{
	// int bucket = computeSymbolIndex(symbol);
	for(int i = 0; i < size; i++){
		if(strcmp(symbols[i].name,symbol) == 0){
			return symbols[i].val;
		}
	}
	printf("error-symbolval\n");
	exit(EXIT_SUCCESS);
}

/* updates the value of a given symbol */
void updateSymbolVal(char* symbol, float val)
{
	printf("==%f==\n",val);
	int f = 0;
	// int bucket = computeSymbolIndex(symbol);
	for(int i = 0; i < size && f == 0; i++){
		if(strcmp(symbols[i].name,symbol) == 0){
			symbols[i].val = val;
			f = 1;
			printf("[+] Field Updated-----\n");
		}
	}
	if(!f){
		printf("[+] New Field added-----\n");
		symbols[size].name = symbol;
		symbols[size].val = val;
		size++;
	}
}

int main (void) {
	/* init symbol table */
	int i;
	for(i=0; i<SIZE; i++) {
		symbols[i].name = NULL;
		symbols[i].val = 0;
	}

	return yyparse ( );
}

void yyerror (char *s) {fprintf (stderr, "???? %s ????\n", s);} 

