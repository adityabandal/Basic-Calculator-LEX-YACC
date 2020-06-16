#include <stdio.h>
#include "cal.h"
#include "y.tab.h"

float ex(nodeType *p) {
	float temp;
    if (!p) return 0;
    switch(p->type) {
    case typeCon:       return p->con.value;
    case typeId:        return sym[p->id.i];
    case typeOpr:
        switch(p->opr.oper) {
        case FOR:		for(ex(p->opr.op[0]);ex(p->opr.op[1]);ex(p->opr.op[2])) ex(p->opr.op[3]); return 0;
        case WHILE:     while(ex(p->opr.op[0])) ex(p->opr.op[1]); return 0;
        case IF:        if (ex(p->opr.op[0]))
                            ex(p->opr.op[1]);
                        else if (p->opr.nops > 2)
                            ex(p->opr.op[2]);
                        return 0;
        case PRINT:     printf("%f\n", ex(p->opr.op[0])); return 0;
        case SCAN:     scanf("%f\n", &temp); sym[p->opr.op[0]->id.i]=temp; return 0;
        case ';':       ex(p->opr.op[0]); return ex(p->opr.op[1]);
        case '=':       return sym[p->opr.op[0]->id.i] = ex(p->opr.op[1]);
        case UMINUS:    return ex(p->opr.op[0]);
        case NOT:    return !ex(p->opr.op[0]);
        case OR:    return ex(p->opr.op[0])||ex(p->opr.op[1]);
        case AND:    return ex(p->opr.op[0])&&ex(p->opr.op[1]);
        case INC:       if(p->opr.op[0]->type == typeId){sym[p->opr.op[0]->id.i]+=1; return sym[p->opr.op[0]->id.i]-1; } else{ return ex(p->opr.op[0]);}
        case DEC:       if(p->opr.op[0]->type == typeId){sym[p->opr.op[0]->id.i]-=1; return sym[p->opr.op[0]->id.i]-1; } else{ return ex(p->opr.op[0]);}
        case '+':       return ex(p->opr.op[0]) + ex(p->opr.op[1]);
        case '-':       return ex(p->opr.op[0]) - ex(p->opr.op[1]);
        case '*':       return ex(p->opr.op[0]) * ex(p->opr.op[1]);
        case '/':       return ex(p->opr.op[0]) / ex(p->opr.op[1]);
        case '<':       return ex(p->opr.op[0]) < ex(p->opr.op[1]);
        case '>':       return ex(p->opr.op[0]) > ex(p->opr.op[1]);
        case GE:        return ex(p->opr.op[0]) >= ex(p->opr.op[1]);
        case LE:        return ex(p->opr.op[0]) <= ex(p->opr.op[1]);
        case NE:        return ex(p->opr.op[0]) != ex(p->opr.op[1]);
        case EQ:        return ex(p->opr.op[0]) == ex(p->opr.op[1]);
        }
    }
    return 0;
}
