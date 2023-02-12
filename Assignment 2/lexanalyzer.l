%{
    #include <stdio.h>
    #include <stdlib.h>
    #include "HashTable.h"
    int line_no = 1;
    int char_no = 0;
%}

/* Regular definitions */
delim           [ \t\n]
ws              {delim}+
letter          [A-Za-z]
digit           [0-9]
id              {letter}({letter}|{digit})*
intlit          [-+]?{digit}+
number          {digit}+(\.{digit}+)?(E[+-]?{digit}+)?
singcomm        "//"[^n]
stringlit       \"(\\.|[^"\\])*\"
charlit         \'(\\.|[^\\])\'
opsep           [{(]
closesep        [})]
term            ;
%%

{ws} {
    // Do nothing
    //fprintf(yyout, "{ws}", yytext);
}

{singcomm} {
    // Do nothing
    line_no++;
}

int|float|double|boolean|char|void|final {
    fprintf(yyout,"{%s,Keyword} ", yytext);
}

#include {
    fprintf(yyout,"{%s,Include Statement}", yytext);
}

{stringlit} {
    fprintf(yyout, "{%s,String literal}", yytext);
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

{number} {
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
