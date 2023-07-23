/* Ujjwal Jain 2021BCS0059 */

%{
    #include<stdio.h>
    int count = 0;
%}

%%
[!@#$%^&*(),.?":{}|<>]   { count++; }
\n                        { return count; }
.                         { /* Ignore other characters */ }
%%

int main()
{
    yylex();
    printf("Number of special symbols: %d\n", count);
    return 0;

}
int yywrap( )
{
	return 1;
}