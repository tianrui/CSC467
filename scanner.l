%{
/**********************************************************************
 *
 * **YOUR GROUP INFO SHOULD GO HERE**
 *
 *  Interface to the scanner module for CSC467 course project
 **********************************************************************/


#include "common.h"
#include "parser.tab.h"
#include "string.h"


#define YY_USER_INIT { yyin = inputFile; }
#define	yyinput      input
#define yTRACE(x)    { if (traceScanner) fprintf(traceFile, "TOKEN %3d : %s\n", x, yytext); }
#define yERROR(x)    { fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: %s\n", yyline, x); errorOccurred = TRUE; yyterminate(); }

int CheckInt(void);
int yyline = 1;

%}
%option noyywrap

WS          [ \t]
DIGIT	    [0-9]
ID          [_a-zA-Z][_a-zA-Z0-9]*
SIGN	    [+|-]


%%
{WS}		{
		//Do nothing
		}

{SIGN}?[1-9]+{DIGIT}*		{
		printf("Matched int, val = %s\n", yytext);
		yylval.intval = atoi(yytext);
		yTRACE(INT_VAL);
		return (INT_VAL);
}

{SIGN}?{DIGIT}+"."{DIGIT}*	{
		printf("matched float\n");
		yylval.floatval = strtof(yytext, NULL);
		yTRACE(FLOAT_VAL);
		}


"int"      	{
		printf ("match int type\n");
	     	yTRACE(INT_TOK);
		return (INT_TOK);
		}

"bool"      	{
		printf ("match bool type\n");
	     	yTRACE(BOOL_TOK);
		return (BOOL_TOK);
		}

"bvec2"      	{
		printf ("match bvec2 type\n");
	     	yTRACE(BVEC2_TOK);
		return (BVEC2_TOK);
		}


"bvec3"      	{
		printf ("match bvec3 type\n");
	     	yTRACE(BVEC3_TOK);
		return (BVEC3_TOK);
		}

"bvec4"      	{
		printf ("match bvec4 type\n");
	     	yTRACE(BVEC4_TOK);
		return (BVEC4_TOK);
		}

"ivec2"      	{
		printf ("match ivec2 type\n");
	     	yTRACE(IVEC2_TOK);
		return (IVEC2_TOK);
		}

"ivec3"      	{
		printf ("match ivec3 type\n");
	     	yTRACE(IVEC3_TOK);
		return (IVEC3_TOK);
		}

"ivec4"      	{
		printf ("match ivec4 type\n");
	     	yTRACE(IVEC4_TOK);
		return (IVEC4_TOK);
		}

"vec2"      	{
		printf ("match vec2 type\n");
	     	yTRACE(VEC2_TOK);
		return (VEC2_TOK);
		}

"vec3"      	{
		printf ("match vec3 type\n");
	     	yTRACE(VEC3_TOK);
		return (VEC3_TOK);
		}

"vec4"      	{
		printf ("match vec4 type\n");
	     	yTRACE(VEC4_TOK);
		return (VEC4_TOK);
		}

"float"      	{
		printf ("match float type\n");
	     	yTRACE(FLOAT_TOK);
		return (FLOAT_TOK);
		}

"*"      	{
		printf ("match multiply tok\n");
	     	yTRACE(MUL_TOK);
		return (MUL_TOK);
		}

"+"      	{
		printf ("match add tok\n");
	     	yTRACE(ADD_TOK);
		return (ADD_TOK);
		}

"-"      	{
		printf ("match subtract tok\n");
	     	yTRACE(SUB_TOK);
		return (SUB_TOK);
		}

"/"      	{
		printf ("match divide tok\n");
	     	yTRACE(DIV_TOK);
		return (DIV_TOK);
		}

"="      	{
		printf ("match assign tok\n");
	     	yTRACE(ASSIGN_TOK);
		return (ASSIGN_TOK);
		}

"!"      	{
		printf ("match not tok\n");
	     	yTRACE(NOT_TOK);
		return (NOT_TOK);
		}

"&"      	{
		printf ("match and tok\n");
	     	yTRACE(AND_TOK);
		return (AND_TOK);
		}

"|"      	{
		printf ("match or tok\n");
	     	yTRACE(OR_TOK);
		return (OR_TOK);
		}

"^"      	{
		printf ("match xor tok\n");
	     	yTRACE(XOR_TOK);
		return (XOR_TOK);
		}

"<"      	{
		printf ("match less than tok\n");
	     	yTRACE(LS_TOK);
		return (LS_TOK);
		}

">"      	{
		printf ("match greater than tok\n");
	     	yTRACE(GT_TOK);
		return (GT_TOK);
		}

"("      	{
		printf ("match left paren tok\n");
	     	yTRACE(LPAREN_TOK);
		return (LPAREN_TOK);
		}

")"      	{
		printf ("match right paren tok\n");
	     	yTRACE(RPAREN_TOK);
		return (RPAREN_TOK);
		}

"{"      	{
		printf ("match left brace tok\n");
	     	yTRACE(LBRACE_TOK);
		return (LBRACE_TOK);
		}

"}"      	{
		printf ("match right brace tok\n");
	     	yTRACE(RBRACE_TOK);
		return (RBRACE_TOK);
		}

"["      	{
		printf ("match left bracket tok\n");
	     	yTRACE(LBRACKET_TOK);
		return (LBRACKET_TOK);
		}

"]"      	{
		printf ("match right bracket tok\n");
	     	yTRACE(RBRACKET_TOK);
		return (RBRACKET_TOK);
		}

";"      	{
		printf ("match semi-colon tok\n");
	     	yTRACE(SEMICOL_TOK);
		return (SEMICOL_TOK);
		}

"if"      	{
		printf ("match if tok\n");
	     	yTRACE(IF_TOK);
		return (IF_TOK);
		}

"else"      	{
		printf ("match else tok\n");
	     	yTRACE(ELSE_TOK);
		return (ELSE_TOK);
		}

"while"      	{
		printf ("match while tok\n");
	     	yTRACE(WHILE_TOK);
		return (WHILE_TOK);
		}


{ID}		{
		printf("matched identifier\n");
		int i = 0;
		for (; yytext[i] != '\0'; ++i) {
			;
		}
		if (i > 32)
			yERROR("Identifier too long\n");
		yTRACE(ID_VAL);
		return (ID_VAL);
		}


"/*"        {
              int c1      = 0;
              int c2      = yyinput();
              int curline = yyline;
              for(;;) {
                if (c2 == EOF) {
                  fprintf(errorFile, "\nLEXICAL ERROR, LINE %d: Unmatched /*\n", curline);
                  errorOccurred = TRUE;
                  yyterminate();
                }
                if (c1 == '*' && c2 == '/')
                  break;
                c1 = c2;
                c2 = yyinput();
                if (c1 == '\n' && c2 != EOF)
                  yyline++;
              }
            }

.           { yERROR("Unknown token"); }

%%
