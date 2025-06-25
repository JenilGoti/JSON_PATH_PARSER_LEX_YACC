%{
#include "jsonpath.tab.h"
#include <stdlib.h>
#include <string.h>
%}

%%
"\$"            { return DOLLAR; }
"\."            { return DOT; }
"\["            { return LBRACKET; }
"\]"            { return RBRACKET; }
"[*]"           { return WILDCARD; }
[0-9]+          { yylval.num = atoi(yytext); return NUMBER; }
[a-zA-Z_][a-zA-Z0-9_]*  { yylval.str = strdup(yytext); return IDENTIFIER; }
[ \t\n\r]+      { /* ignore whitespace */ }
.               { return yytext[0]; }  // default: return as char
%%
