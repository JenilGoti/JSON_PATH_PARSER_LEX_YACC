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
    char* path; // For reconstructed path
}

// Token declarations
%token DOLLAR DOT RECURSIVE LBRACKET RBRACKET COLON COMMA WILDCARD
%token <str> STRING IDENTIFIER
%token <num> NUMBER

// Non-terminal return types
%type <path> jsonpath selector_list selector

%%

jsonpath:
    DOLLAR selector_list {
        printf("✅ Valid JSONPath expression\n");
        printf("Parsed Path: $%s\n", $2);
        free($2);
    }
    ;

selector_list:
    selector {
        $$ = $1;
    }
    | selector_list selector {
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
    | LBRACKET STRING RBRACKET {
        size_t len = strlen($2) + 4;
        $$ = (char*) malloc(len);
        sprintf($$, "['%s']", $2);
        free($2);
    }
    | RECURSIVE IDENTIFIER {
        size_t len = strlen($2) + 3;
        $$ = (char*) malloc(len);
        sprintf($$, "..%s", $2);
        free($2);
    }
    | LBRACKET NUMBER RBRACKET {
        char buf[32];
        sprintf(buf, "[%d]", $2);
        $$ = strdup(buf);
    }
    | LBRACKET NUMBER COMMA NUMBER RBRACKET {
        char buf[64];
        sprintf(buf, "[%d,%d]", $2, $4);
        $$ = strdup(buf);
    }
    | LBRACKET NUMBER COLON NUMBER RBRACKET {
        char buf[64];
        sprintf(buf, "[%d:%d]", $2, $4);
        $$ = strdup(buf);
    }
    | LBRACKET NUMBER COLON NUMBER COLON NUMBER RBRACKET {
        char buf[64];
        sprintf(buf, "[%d:%d:%d]", $2, $4, $6);
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
