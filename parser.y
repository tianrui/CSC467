%{
/***********************************************************************
 * --YOUR GROUP INFO SHOULD GO HERE--
 * 
 *   Interface to the parser module for CSC467 course project.
 * 
 *   Phase 2: Implement context free grammar for source language, and
 *            parse tracing functionality.
 *   Phase 3: Construct the AST for the source language program.
 ***********************************************************************/

/***********************************************************************
 *  C Definitions and external declarations for this module.
 *
 *  Phase 3: Include ast.h if needed, and declarations for other global or
 *           external vars, functions etc. as needed.
 ***********************************************************************/

#include <string.h>
#include "common.h"
//#include "ast.h"
//#include "symbol.h"
//#include "semantic.h"
#define YYERROR_VERBOSE
#define yTRACE(x)    { if (traceParser) fprintf(traceFile, "%s\n", x); }

void yyerror(char* s);    /* what to do in case of error            */
int yylex();              /* procedure for calling lexical analyzer */
extern int yyline;        /* variable holding current line number   */

%}

/***********************************************************************
 *  Yacc/Bison declarations.
 *  Phase 2:
 *    1. Add precedence declarations for operators (after %start declaration)
 *    2. If necessary, add %type declarations for some nonterminals
 *  Phase 3:
 *    1. Add fields to the union below to facilitate the construction of the
 *       AST (the two existing fields allow the lexical analyzer to pass back
 *       semantic info, so they shouldn't be touched).
 *    2. Add <type> modifiers to appropriate %token declarations (using the
 *       fields of the union) so that semantic information can by passed back
 *       by the scanner.
 *    3. Make the %type declarations for the language non-terminals, utilizing
 *       the fields of the union as well.
 ***********************************************************************/

%{
#define YYDEBUG 1
%}


// TODO:Modify me to add more data types
// Can access me from flex useing yyval

%union {
  int intval;
  float floatval;
  int id_len;
}
// TODO:Replace myToken with your tokens, you can use these tokens in flex
%token    INT_VAL FLOAT_VAL ID_VAL
%token    INT_TOK BOOL_TOK BVEC2_TOK BVEC3_TOK BVEC4_TOK IVEC2_TOK IVEC3_TOK IVEC4_TOK
%token    VEC2_TOK VEC3_TOK VEC4_TOK FLOAT_TOK
%token    MUL_TOK ADD_TOK SUB_TOK DIV_TOK ASSIGN_TOK 
%token    NOT_TOK AND_TOK OR_TOK XOR_TOK LS_TOK GT_TOK
%token    LPAREN_TOK RPAREN_TOK LBRACE_TOK RBRACE_TOK LBRACKET_TOK RBRACKET_TOK
%token	  SEMICOL_TOK COMMA_TOK
%token	  IF_TOK ELSE_TOK WHILE_TOK


%start    program

%%

/***********************************************************************
 *  Yacc/Bison rules
 *  Phase 2:
 *    1. Replace grammar found here with something reflecting the source
 *       language grammar
 *    2. Implement the trace parser option of the compiler
 *  Phase 3:
 *    1. Add code to rules for construction of AST.
 ***********************************************************************/
program
  :   tokens       
  ;
tokens
  :  tokens token  
  |      
  ;
// TODO: replace myToken with the token the you defined.
token
  :	ID_VAL 
  |	INT_VAL 
  |	INT_TOK
  |	BOOL_TOK
  |	BVEC2_TOK 
  |	BVEC3_TOK 
  |	BVEC4_TOK 
  | 	IVEC2_TOK 
  |	IVEC3_TOK 
  |	IVEC4_TOK
  |     VEC2_TOK 
  |	VEC3_TOK 
  |	VEC4_TOK 
  |	FLOAT_TOK 
  |	MUL_TOK 
  |	ADD_TOK 
  |	SUB_TOK 
  |	DIV_TOK 
  |	ASSIGN_TOK
  |	NOT_TOK 
  |	AND_TOK 
  |	OR_TOK 
  |	XOR_TOK 
  |	LS_TOK 
  |	GT_TOK
  | 	LPAREN_TOK | RPAREN_TOK | LBRACE_TOK | RBRACE_TOK | LBRACKET_TOK | RBRACKET_TOK | SEMICOL_TOK | COMMA_TOK
  |	IF_TOK | ELSE_TOK | WHILE_TOK

  ;


%%

/***********************************************************************ol
 * Extra C code.
 *
 * The given yyerror function should not be touched. You may add helper
 * functions as necessary in subsequent phases.
 ***********************************************************************/
void yyerror(char* s) {
  if (errorOccurred)
    return;    /* Error has already been reported by scanner */
  else
    errorOccurred = 1;
        
  fprintf(errorFile, "\nPARSER ERROR, LINE %d",yyline);
  if (strcmp(s, "parse error")) {
    if (strncmp(s, "parse error, ", 13))
      fprintf(errorFile, ": %s\n", s);
    else
      fprintf(errorFile, ": %s\n", s+13);
  } else
    fprintf(errorFile, ": Reading token %s\n", yytname[YYTRANSLATE(yychar)]);
}

