/*** Definition Section has one variable
which can be accessed inside yylex() 
and main() ***/
%{
int line_number=1;
void print_type(char* string_to_print,char* type_to_print);
void printMiddleCharacters(const char* str);
%}

%x COMMENT
digit       ([0-9])
letter      ([a-zA-Z])
whitespace  ([\t\n ])
relop		(==|<>|<|<=|>|>=)
dropLine	(\r?\n)
ReservedWord (int|float|void|write|read|va_arg|while|do|if|then|else|return)
ReservedMarks [(){},;:]|(\.\.\.)
 
%%
{ReservedWord} {printf("<%s>", yytext);}
{ReservedMarks} {printf("%s", yytext);}
\"(\\n|\\t|\\\"|[^"\\\r\n])*\" {printf("<str,"); printMiddleCharacters(yytext);printf(">");}
#([^\r\n])* {}

\[0t]	{}
{letter}({letter}|{digit}|_)* {print_type(yytext,"id");}
{digit}+	{print_type(yytext,"integernum");}
{digit}+\.{digit}+	{print_type(yytext,"realnum");}
{relop}	{print_type(yytext,"relop");}
[+-]	{print_type(yytext,"addop");}
[*/]	{print_type(yytext,"mulop");}
[=]	{print_type(yytext,"assign");}
&&	{print_type(yytext,"and");}
"|""|"	{print_type(yytext,"or");}
!	{print_type(yytext,"not");}
{dropLine}	{line_number++;printf("\n");}
\t {printf("	");}
[ ] {printf(" ");}

<<EOF>>	{return 0;}
. { printf("\nLexical error: '%s' in line number %d\n",yytext,line_number); return 1; }
%%
void print_type(char* string_to_print,char* type_to_print)
{
	printf("<%s,%s>",type_to_print,string_to_print);
}
void printMiddleCharacters(const char* str)
{
	
	size_t len = strlen(str);  // Get the length of the string

    if (len <= 2) {
        // If the string has 2 or fewer characters, there's nothing to print
        //printf("");
        return;
    }

    // Print from the second character to the second-last character
    for (size_t i = 1; i < len - 1; i++) {
        putchar(str[i]);
    }
}
int yywrap(){}

int main(){



yylex();

return 0;
}