#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yyparse();          // Parser function from Bison
extern void yy_scan_string(const char *); // Flex function to scan input string
extern void yy_delete_buffer(void *);     // Optional cleanup (if needed)
extern int yydebug;            // Enable parser debug trace

int main() {
    char input[1024];

    // Optional: enable debug info from Bison parser
    yydebug = 1;

    printf("Enter a JSONPath expression (or 'exit' to quit):\n");

    while (1) {
        printf(">>> ");
        if (!fgets(input, sizeof(input), stdin)) break;
        // Remove newline character
        input[strcspn(input, "\n")] = 0;
        if (strcmp(input, "exit") == 0) break;
        // Feed string to Flex (Lex)
        yy_scan_string(input);
        // Run the parser
        yyparse();
    }

    return 0;
}
