%%
[+|-]?[1-9][0-9]*"."[0-9]+		printf("Recognized as floating point decimal number.\n");
[0-9a-zA-Z]*				printf("Not recognized.");
%%
