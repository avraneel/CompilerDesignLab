%%
1[0|1]*101		printf("Recognized.\n");
[0-9a-zA-Z]*		printf("Not recognized.\n");
%%

void main() {
    yylex();
}

int yywrap() {
    return 1;
}