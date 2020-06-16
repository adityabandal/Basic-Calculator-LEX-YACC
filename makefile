calc: lex.yy.o y.tab.o cal_impl.c cal_3addr.c
	gcc y.tab.o lex.yy.o cal_impl.c -o impl  #executable that runs the calculator
	gcc y.tab.o lex.yy.o cal_3addr.c -o intm #executable that generates 3 address code

lex.yy.c: y.tab.c cal.l
	lex cal.l

y.tab.c: cal.y
	yacc -y -d cal.y
	
y.tab.o: y.tab.c
	gcc -c y.tab.c
	
lex.yy.o: lex.yy.c
	gcc -c lex.yy.c

clean: 
	rm -rf lex.yy.c y.tab.c y.tab.h impl intm lex.yy.o y.tab.o

