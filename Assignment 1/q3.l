%{
    int op = 0;
    int a = 0;
    int b = 0;
%}

DIGIT   [0-9]*

%%

{DIGIT} {digi();}

"+"	{op=1;}
"-" {op=2;}
"*" {op=3;}
"/" {op=4;}
"%" {op=5;}
"^" {op=6;}
"\n" {
    printf("%d\n\n", a);
}

%%

int digi() {
    if(op==0) 
        a=atoi(yytext);
    else {
        b=atoi(yytext);
        switch(op) 
        {
            case 1: a = a+b;
                    break;
            case 2: a = a-b;
                    break;
            case 3: a = a*b;
                    break;
            case 4: a = a/b;
                    break;
            case 5: a = (int)((int)a%(int)b);
                    break;
            case 6: for(int i = a; b>1; b--) {
                        a=a*i;
                    }
                    break;            
        }
        op =0;
    }

}

void main() {
	printf("Enter string:\n");
	yylex();
}	

int yywrap() {
    return 1;
}
