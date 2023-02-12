%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "HashTable.h"
    int line_no = 1;
    int char_no = 0;
%}

/* Regular definitions */
letter          [a-zA-Z]
digit           [0-9]
singcomm        "//"[^\n]*
intlit          [-+]?[0-9]*
floatlit        [-+]?[1-9][0-9]*"."[0-9]+[^\0]
charlit         '.'
id              [a-zA-Z][0-9a-zA-Z]*
delim           [ \t\n]+
term            ;
opsep           [{(]
closesep        [})]

%%

{singcomm} {
    fprintf(yyout,"{Single Line Comment} ");
    line_no++;
}

{delim} {
    fprintf(yyout,"{Delimter} ");
}

int|float|double|boolean|char|void|final|printf {
    fprintf(yyout,"{%s,Keyword} ", yytext);
}

#include {
    fprintf(yyout,"{%s,Include Statement}", yytext);
}

{id} {
    fprintf(yyout,"{%s,Identifier} ", yytext);
}

{term} {
    fprintf(yyout,"{Terminator} ");
    line_no++;
}

& {
    fprintf(yyout,"{Reference operator} ");
}

"=" {
    fprintf(yyout,"{Assignment operator} ");
}

{intlit} {
    fprintf(yyout,"{%s,Integer literal} ",yytext);
}

{floatlit} {
    fprintf(yyout,"{%s,Floating point literal} ",yytext);
}

{charlit} {
    fprintf(yyout,"{%s,Character Literal}",yytext);
}

{opsep} {
    fprintf(yyout,"{%s,Opening Separator} ",yytext);
}

{closesep} {
    fprintf(yyout,"{%s,Closing Separator} ",yytext);
    if(*yytext == '>' || *yytext == '}') {
        line_no++;
    }
}

%%

int main() {
    extern FILE *yyin, *yyout;
    yyin = fopen("inp.c", "r");
    yyout = fopen("op.txt", "w+");
	yylex();
    printf("%d\n",line_no);
    return 0;
}	

int yywrap() {
    return 1;
}
