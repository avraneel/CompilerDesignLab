%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>
    #include "hash_table.c"
    int line_no = 1;
    int char_no = 0;
    ht_hash_table* ht;
%}

/* Regular definitions */
delim           [ \t\n\v]
ws              {delim}+
letter          [A-Za-z]
digit           [0-9]
id              {letter}({letter}|{digit})*
intlit          [-+]?{digit}+
number          {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
singcomm        \/\/[^\n]*
stringlit       \"(\\.|[^"\\])*\"
charlit         \'(\\.|[^\\])\'
relop           [<>=!]=>?
arithop         "+"|"-"|"*"|"/"|"%"|"^"
logicop         "&&"|"||"|"!"
opsep           [{(]
closesep        [})]
term            ;
%%

{ws} {
    if(*yytext == '\n') {
        line_no++;
    }
}

{singcomm} {
    // Do nothing
}

int|float|double|boolean|char|void|final {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Keyword,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

#include[^\n]+ {
    fprintf(yyout,"Including %s at line %d. To be expanded by the preprocessor.\n", yytext, line_no);
}

{arithop} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Arithmetic operator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{relop} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Relational operator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{logicop} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Logical operator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{stringlit} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: String Literal,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{id} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Identifier,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{term} {
    //fprintf(yyout,"{Terminator} ");
}

& {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Reference Operator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

"=" {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Assignment operator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{intlit} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Integer Literal,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{number} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Floating Point Literal,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{charlit} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "\t\t\tType: Character Literal,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{opsep} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Opening Separator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

{closesep} {
    char *values = malloc(sizeof(int));
    sprintf(values, "%d", line_no);
    char *s = "Type: Closing separator,\tLine: ";
    char *final = malloc(strlen(s) + strlen(values)+1);
    strcat(final, s);
    strcat(final, values);
    ht_insert(ht, yytext, final);
}

%%

int main() {
    extern FILE *yyin, *yyout;
    ht  = ht_new();
    yyin = fopen("inp.c", "r");
    yyout = fopen("op.txt", "w+");
	yylex();
    fprintf(yyout,"Symbol Table\n\n");
    ht_print_hashtable(ht, yyout);
    printf("%d\n",line_no);
    return 0;
}	

int yywrap() {
    return 1;
}
