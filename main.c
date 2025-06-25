#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse();
extern void yy_scan_string(const char *);
extern void yy_delete_buffer(void *);
extern int yydebug;

extern char* parsed_ydb_global_ref;  // declared in parser


int main() {
    char input[1024];

    // yydebug = 1; // Enable debugging if needed

    printf("Enter JSONPath expression (or 'exit' to quit):\n");

    while (1) {
        printf(">>> ");
        if (!fgets(input, sizeof(input), stdin)) break;

        input[strcspn(input, "\n")] = 0;

        if (strcmp(input, "exit") == 0) break;

        if (parsed_ydb_global_ref) {
            free(parsed_ydb_global_ref);
            parsed_ydb_global_ref = NULL;
        }

        yy_scan_string(input);

        if (yyparse() == 0) {
            if (parsed_ydb_global_ref) {
                printf("✅ Parsing succeeded\n YottaDB Global Reference: %s\n", parsed_ydb_global_ref);
            } else {
                printf("✅ Parsing succeeded but ❌ no output.\n");
            }
        } else {
            printf("Parsing failed.\n");
        }
    }

    return 0;
}
