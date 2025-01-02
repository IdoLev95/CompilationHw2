%{
#include <stdio.h>
#include "part2_helpers.h"  // Include the helper functions
#include "parser.tab.h"

int line_number = 0;   // Line number for Flex
void print_type(const char* string_to_print, const char* type_to_print);
void printMiddleCharacters(const char* str);

%}

%x COMMENT
digit       ([0-9])
letter      ([a-zA-Z])
whitespace  ([\t\n ])
relop		(==|<>|<|<=|>|>=)
dropLine	(\r?\n)
TypeReserveWord (int|float|void)
ReservedWord (write|read|va_arg|while|do|if|then|else|return)
ReservedMarks ([(){},;:])

%%
{TypeReserveWord} {

ParserNode* myNode = makeNode("TYPE",yytext, NULL);
yylval.myClassVal = myNode; 
return TYPE;
}
{ReservedWord} {
ParserNode* myNode = makeNode("ReservedWord",yytext, NULL);
yylval.myClassVal = myNode; 
return ReservedWord;
}
{ReservedMarks} {
ParserNode* myNode = makeNode("ReservedMarks",yytext, NULL);
yylval.myClassVal = myNode; 
return yytext[0];
}
\.\.\. {  
    ParserNode* myNode = makeNode("DOTS", yytext, NULL);  
    yylval.myClassVal = myNode;  
    return DOTS;       // Custom token for '...'  
}
\"(\\n|\\t|\\\"|[^"\\\r\n])*\" {

ParserNode* myNode = makeNode("STRING",yytext, NULL);
yylval.myClassVal = myNode; 
return STRING;
}
#([^\r\n])* {}

\[0t]	{}
{letter}({letter}|{digit}|_)* {
ParserNode* myNode = makeNode("ID",yytext, NULL);
yylval.myClassVal = myNode; 
return ID;
}
{digit}+	{
ParserNode* myNode = makeNode("IntegerNum",yytext, NULL);
yylval.myClassVal = myNode; 
return IntegerNum;
}
{digit}+\.{digit}+	{
ParserNode* myNode = makeNode("RealNum",yytext, NULL);
yylval.myClassVal = myNode; 
return RealNum;
}
{relop}	{
ParserNode* myNode = makeNode("relop",yytext, NULL);
yylval.myClassVal = myNode; 
return relop;
}
[+-]	{
ParserNode* myNode = makeNode("addop",yytext, NULL);
yylval.myClassVal = myNode; 
return addop;
}
[*/]	{
ParserNode* myNode = makeNode("mulop",yytext, NULL);
yylval.myClassVal = myNode; 
return mulop;
}
[=]	{
ParserNode* myNode = makeNode("assign",yytext, NULL);
yylval.myClassVal = myNode; 
return assign;
}
&&	{
ParserNode* myNode = makeNode("and",yytext, NULL);
yylval.myClassVal = myNode; 
return and;
}
\|\|    {
ParserNode* myNode = makeNode("or",yytext, NULL);
yylval.myClassVal = myNode; 
return or;
}
!	{
ParserNode* myNode = makeNode("not",yytext, NULL);
yylval.myClassVal = myNode; 
return not;
}
{dropLine}	{ParserNode* myNode = makeNode("dropLine",yytext, NULL);
yylval.myClassVal = myNode; 
line_number++;
return dropLine;
}
\t {}
[ ] {}

<<EOF>>	{return 0;}
. { printf("\nLexical error: '%s' in line number %d\n", yytext, line_number); return 1; }
%%

void print_type(const char* string_to_print, const char* type_to_print) {
    printf("<%s,%s>", type_to_print, string_to_print);
}

void printMiddleCharacters(const char* str) {
    size_t len = strlen(str);  // Get the length of the string

    if (len <= 2) {
        return;
    }

    // Print from the second character to the second-last character
    for (size_t i = 1; i < len - 1; i++) {
        putchar(str[i]);
    }
}
