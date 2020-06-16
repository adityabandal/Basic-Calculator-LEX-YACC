#include <stdio.h>
#include "cal.h"
#include "y.tab.h"

static int lbl;
static int t;
int ex(nodeType *p) {
    int lbl1, lbl2;
	int op1,op2;
    if (!p) return 0;
    switch(p->type) {
    case typeCon:       
        printf("\t_%d = %f\n",t++, p->con.value);
        return t-1; 
        break;
    case typeId:        
        printf("\t_%d = %c\n",t++, p->id.i + 'a');
        return t-1; 
        break;
    case typeOpr:
        switch(p->opr.oper) {	
        case FOR: 
        	ex(p->opr.op[0]);
        	printf("L%03d:\n", lbl1 = lbl++);
        	op1=ex(p->opr.op[1]);
        	printf("\tif(_%d==0) goto:\tL%03d\n",op1, lbl2 = lbl++);
        	ex(p->opr.op[3]);
        	ex(p->opr.op[2]);
        	printf("\tgoto:L%03d\n", lbl1);
        	printf("L%03d:\n", lbl2);
        	break;
        case WHILE:
            printf("L%03d:\n", lbl1 = lbl++);
            op1=ex(p->opr.op[0]);
            printf("\tif(_%d==0) goto:\tL%03d\n",op1, lbl2 = lbl++);
            ex(p->opr.op[1]);
            printf("\tgoto:L%03d\n", lbl1);
            printf("L%03d:\n", lbl2);
            break;
        case INC: printf("\t_%d = %c\n",t++,p->opr.op[0]->id.i+'a');
        	printf("\t%c = %c + 1\n",p->opr.op[0]->id.i+'a',p->opr.op[0]->id.i+'a');
        	return t-1;
        	break;
        case DEC: printf("\t_%d = %c\n",t++,p->opr.op[0]->id.i+'a');
        	printf("\t%c = %c - 1\n",p->opr.op[0]->id.i+'a',p->opr.op[0]->id.i+'a');
        	return t-1;
        	break;
        case NOT: 
        	if(p->opr.op[0]->type == typeOpr){
        		op1 = ex(p->opr.op[0]);
        	}
        	printf("\t_%d = ",t++);
        	if(p->opr.op[0]->type == typeOpr) printf("!_%d",op1);
        	else if(p->opr.op[0]->type == typeCon) printf("!%f",p->opr.op[0]->con.value);
        	else if(p->opr.op[0]->type == typeId) printf("!%c",p->opr.op[0]->id.i+'a');
        	printf("\n");
			return t-1;
            break;
        case IF:
            op1=ex(p->opr.op[0]);
            if (p->opr.nops > 2) {
                /* if else */
                printf("\tif(_%d==0)\tgoto:L%03d\n",op1, lbl1 = lbl++);
                op2=ex(p->opr.op[1]);
                printf("\tgoto:L%03d\n", lbl2 = lbl++);
                printf("L%03d:\n", lbl1);
                ex(p->opr.op[2]);
                printf("L%03d:\n", lbl2);
            } else {
                /* if */
                printf("\tif(_%d==0)\tgoto:L%03d\n",op1, lbl1 = lbl++);
                ex(p->opr.op[1]);
                printf("L%03d:\n", lbl1);
            }
            break;
        case PRINT:     
            op1=ex(p->opr.op[0]);
            printf("\tprintf(\"%%f\",_%d);\n",op1);
            break;
        case SCAN:     
            printf("\tscanf(\"%%f\",&%c);\n",p->opr.op[0]->id.i+'a');
            break;
        case '=':       
            
            printf("\t%c = _%d", p->opr.op[0]->id.i + 'a',ex(p->opr.op[1]));
            
            printf("\n");
            break;
        case UMINUS:    
            if(p->opr.op[0]->type == typeOpr){
        		op1 = ex(p->opr.op[0]);
        	}
        	printf("\t_%d = ",t++);
        	if(p->opr.op[0]->type == typeOpr) printf("-_%d",op1);
        	else if(p->opr.op[0]->type == typeCon) printf("-%f",p->opr.op[0]->con.value);
        	else if(p->opr.op[0]->type == typeId) printf("-%c",p->opr.op[0]->id.i+'a');
        	printf("\n");
			return t-1;
            break;
        default:
            if(p->opr.op[0]->type == typeOpr){
            		op1 = ex(p->opr.op[0]);
            	}
            	if(p->opr.op[1]->type == typeOpr){
            		op2 = ex(p->opr.op[1]);
            	}
            	printf("\t_%d = ",t++);
            	if(p->opr.op[0]->type == typeOpr) printf("_%d",op1);
            	else if(p->opr.op[0]->type == typeCon) printf("%f",p->opr.op[0]->con.value);
            	else if(p->opr.op[0]->type == typeId) printf("%c",p->opr.op[0]->id.i+'a');
            switch(p->opr.oper) {
            case '+':   printf("+");break;
            case '-':   printf("-"); break; 
            case '*':   printf("*"); break;
            case '/':   printf("/"); break;
            case '<':   printf("<"); break;
            case '>':   printf(">"); break;
            case GE:    printf(">="); break;
            case LE:    printf("<="); break;
            case NE:    printf("!="); break;
            case EQ:    printf("=="); break;
            case AND:    printf("&&"); break;
            case OR:    printf("||"); break;
            }
            if(p->opr.op[1]->type == typeOpr) printf("_%d",op2);
        	else if(p->opr.op[1]->type == typeCon) printf("%f",p->opr.op[1]->con.value);
        	else if(p->opr.op[1]->type == typeId) printf("%c",p->opr.op[1]->id.i+'a');
        	//printf("    ====> %d\n",t);
        	printf("\n");
        	return t-1;
        }
    }
    return 0;
}
