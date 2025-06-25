all: jsonpath

jsonpath: main.c jsonpath.tab.c lex.yy.c
	gcc -o jsonpath main.c jsonpath.tab.c lex.yy.c -lfl

jsonpath.tab.c jsonpath.tab.h: jsonpath.y
	bison -d jsonpath.y

lex.yy.c: jsonpath.l
	flex jsonpath.l

clean:
	rm -f jsonpath lex.yy.c jsonpath.tab.* *.output
