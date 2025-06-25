%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char* parsed_ydb_global_ref = NULL;
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
        size_t len = strlen("^store") + strlen($2) + 1;
        parsed_ydb_global_ref = malloc(len + 1);
        sprintf(parsed_ydb_global_ref, "^store%s", $2);
        // printf("✅ Valid JSONPath expression\n");
        // printf("YottaDB Global Reference: %s\n", result);
        free($2);
        // free(result);
    }
    ;
selector_list:
    selector {
        $$ = $1;
    }
    | selector_list selector {
        size_t len = strlen($1) + strlen($2) + 1;
        char* tmp = malloc(len + 1);
        sprintf(tmp, "%s%s", $1, $2);
        free($1);
        free($2);
        $$ = tmp;
    }
    ;

selector:
    DOT IDENTIFIER {
        size_t len = strlen($2) + 4; // 2 for quotes + 2 for parentheses
        char* tmp = malloc(len);
        sprintf(tmp, "(\"%s\")", $2);
        free($2);
        $$ = tmp;
    }
    | LBRACKET STRING RBRACKET {
        size_t len = strlen($2) + 4;
        char* tmp = malloc(len);
        sprintf(tmp, "(\"%s\")", $2);
        free($2);
        $$ = tmp;
    }
    | RECURSIVE IDENTIFIER {
        size_t len = strlen($2) + 8; // for "(\"..%s\")"
        char* tmp = malloc(len);
        sprintf(tmp, "(\"..%s\")", $2);
        free($2);
        $$ = tmp;
    }
    | LBRACKET NUMBER RBRACKET {
        char buf[32];
        snprintf(buf, sizeof(buf), "(%d)", $2);
        $$ = strdup(buf);
    }
    | LBRACKET NUMBER COMMA NUMBER RBRACKET {
        // Represent multi-index as a string subscript in quotes
        char buf[64];
        snprintf(buf, sizeof(buf), "(\"[%d,%d]\")", $2, $4);
        $$ = strdup(buf);
    }
    | LBRACKET NUMBER COLON NUMBER RBRACKET {
        char buf[64];
        snprintf(buf, sizeof(buf), "(\"[%d:%d]\")", $2, $4);
        $$ = strdup(buf);
    }
    | LBRACKET NUMBER COLON NUMBER COLON NUMBER RBRACKET {
        char buf[64];
        snprintf(buf, sizeof(buf), "(\"[%d:%d:%d]\")", $2, $4, $6);
        $$ = strdup(buf);
    }
    | LBRACKET WILDCARD RBRACKET {
        $$ = strdup("(*)");
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "❌ Syntax error: %s\n", s);
}
