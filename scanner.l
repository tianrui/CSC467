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
{SIGN}?{DIGIT}+	    {
		printf("Matched int\n");
		printf("val = %s\n", yytext);
		yylval.intval = atoi(yytext);
		yTRACE(INTTOK);
		return (INTTOK);
}

{SIGN}?{DIGIT}+"."{DIGIT}* {printf("matched float\n"); yTRACE(FLOATTOK);}


"bool"      	{
		printf ("match bool type\n");
	     	yTRACE(BOOL_TTOK);
		}

"int"      	{
		printf ("match int type\n");
	     	yTRACE(INT_TTOK);
		return (INT_TTOK);
		}


"bvec2"      	{
		printf ("match bvec2 type\n");
	     	yTRACE(BVEC2_TTOK);
		}


"bvec3"      	{
		printf ("match bvec3 type\n");
	     	yTRACE(BVEC3_TTOK);
		}

"bvec4"      	{
		printf ("match bvec4 type\n");
	     	yTRACE(BVEC4_TTOK);
		}

"ivec2"      	{
		printf ("match ivec2 type\n");
	     	yTRACE(IVEC2_TTOK);
		}

"ivec3"      	{
		printf ("match ivec3 type\n");
	     	yTRACE(IVEC3_TTOK);
		}

"ivec4"      	{
		printf ("match ivec4 type\n");
	     	yTRACE(IVEC4_TTOK);
		}




{ID}		{
		printf("matched identifier\n");
		yTRACE(IDTOK);
		return (IDTOK);
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
