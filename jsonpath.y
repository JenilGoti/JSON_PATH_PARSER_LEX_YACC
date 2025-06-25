%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
void yyerror(const char *s);
int yylex(void);
%}
%debug
%union {
    int num;
    char* str;
    char* path; // for reconstructed path
}

%token DOLLAR DOT LBRACKET RBRACKET WILDCARD
%token <num> NUMBER
%token <str> IDENTIFIER


%type <path> jsonpath selector_list selector
%%

jsonpath:
    DOLLAR selector_list {
        printf("✅ Valid JSONPath expression\n");
        printf("Parsed Path: $%s\n", $2); // $2 holds the full path after $
        free($2); // clean up
    }
    ;

selector_list:
    selector {
        $$ = $1;
    }
    | selector_list selector {
        // concatenate previous path with new selector
        size_t len = strlen($1) + strlen($2) + 1;
        $$ = (char*) malloc(len + 1);
        sprintf($$, "%s%s", $1, $2);
        free($1);
        free($2);
    }
    ;

selector:
    DOT IDENTIFIER {
        size_t len = strlen($2) + 2;
        $$ = (char*) malloc(len);
        sprintf($$, ".%s", $2);
        free($2);
    }
    | LBRACKET NUMBER RBRACKET {
        char buf[32];
        sprintf(buf, "[%d]", $2);
        $$ = strdup(buf);
    }
    | LBRACKET WILDCARD RBRACKET {
        $$ = strdup("[*]");
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "❌ Syntax error: %s\n", s);
}
