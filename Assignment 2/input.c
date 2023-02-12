#include <stdio.h>
int main() {
    // This is a single line comment
    int an45 = 23;
    char ch = 'a';
    float g = 12.45;
    long b = 35;
    long c = an45 + b;
    printf("Ans: %d\n", c);
    /*
        multi line
        comment */

    if(an45 >= 30 && an45 != 50) {
        printf("Less than 30\n");
    }
    printf("Hello World\n");
}