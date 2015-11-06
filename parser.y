%{
/***********************************************************************
 * cd007
 * Tianrui Xiao 999018049
 * Chenhao Zhang
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

enum {
  DP3 = 0, 
  LIT = 1, 
  RSQ = 2
};

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

// defines the yyval union
%union {
  int as_int;
  int as_vec;
  float as_float;
  char *as_str;
  int as_func;
}

%token          FLOAT_T
%token          INT_T
%token          BOOL_T
%token          CONST
%token          FALSE_C TRUE_C
%token          FUNC
%token          IF WHILE ELSE
%token          AND OR NEQ EQ LEQ GEQ

// links specific values of tokens to yyval
%token <as_vec>   VEC_T
%token <as_vec>   BVEC_T
%token <as_vec>   IVEC_T
%token <as_float> FLOAT_C
%token <as_int>   INT_C
%token <as_str>   ID

%left     '|'
%left     '&'
%nonassoc '=' NEQ '<' LEQ '>' GEQ
%left     '+' '-'
%left     '*' '/'
%right    '^'
%nonassoc '!' UMINUS

%start    program

%%

/***********************************************************************
 *  Yacc/Bison rules
 *  Phase 2:
 *    1. Replace grammar found here with something reflecting the source
 *       language grammar
 *    2. Implement the trace parser option of the compiler
 ***********************************************************************/
program
  : scope
  { yTRACE("program -> scope\n");}
  ;

scope
  : '{' declarations statements '}'
  { yTRACE("scope -> { declarations statements }\n");}
  ;

declarations
  : declaration
  { yTRACE("declarations -> declarations declaration\n");}
  ;

declaration
  : type ID ';'
  { yTRACE("declaration -> type ID\n");}
  | CONST type ID '=' expr ';'
  { yTRACE("declaration -> const type ID = expr\n");}
  | declaration type ID ';'
  | declaration CONST type ID '=' expr ';'
  |
  ;

statements
  : statements statement
  { yTRACE("statements -> statements statement\n");}
  | statement
  ;

statement
  : var '=' expr ';'
  { yTRACE("statement -> variable = epxression\n");}
  | IF '(' expr ')' statement else_statement
  { yTRACE("statement -> if (expression) stament else statement\n");}
  | WHILE '('expr ')' statement
  { yTRACE("statement -> while (expression) statement\n");}
  | scope
  { yTRACE("statement -> scope\n");}
  | ';'
  { yTRACE("statement -> ;\n");}
  ;

else_statement
  : ELSE statement
  |
  ;

type
  : FLOAT_T
  { yTRACE("type -> FLOAT_T\n");}
  | INT_T
  { yTRACE("type -> INT_T\n");}
  | BOOL_T
  { yTRACE("type -> BOOL_T\n");}
  | VEC_T
  { yTRACE("type -> VEC_T\n");}
  | IVEC_T
  { yTRACE("type -> IVEC_T\n");}
  | BVEC_T
  { yTRACE("type -> BVEC_T\n");}
  ;

expr
  : ctor
  { yTRACE("expression -> constructor\n");}
  | fn
  { yTRACE("expression -> function\n");}
  | INT_C
  { yTRACE("expression -> int literal\n");}
  | FLOAT_C
  { yTRACE("expression -> float literal\n");}
  | var
  { yTRACE("expression -> variable\n");}
  | unary_op expr
  { yTRACE("expression -> unary_op expression\n");}
  | expr binary_op expr
  { yTRACE("expression -> expression binary_op expression\n");}
  | TRUE_C | FALSE_C
  { yTRACE("expression -> true\false\n");}
  | '(' expr ')'
  { yTRACE("expression -> (expression)\n");}
  ;

var
  : ID
  { yTRACE("variable -> ID\n");}
  | ID '[' INT_C ']'
  { yTRACE("variable -> ID[int literal]\n");}
  ;

unary_op
  : '!'
  { yTRACE("unary_op -> !\n");}
  | '-'
  { yTRACE("unary_op -> -\n");}
  ;

binary_op
  : '&&'
  { yTRACE("binary_op -> AND\n");}
  | '||'
  { yTRACE("binary_op -> OR\n");}
  | '=='
  { yTRACE("binary_op -> EQ\n");}
  | '!='
  { yTRACE("binary_op -> NE\n");}
  | '<'
  { yTRACE("binary_op -> <\n");}
  | '<='
  { yTRACE("binary_op -> LEQ\n");}
  | '>'
  { yTRACE("binary_op -> >\n");}
  | '>='
  { yTRACE("binary_op -> GEQ\n");}
  | '+'
  { yTRACE("binary_op -> +\n");}
  | '-'
  { yTRACE("binary_op -> -\n");}
  | '*'
  { yTRACE("binary_op -> *\n");}
  | '/'
  { yTRACE("binary_op -> /\n");}
  | '^'
  { yTRACE("binary_op -> ^\n");}
  ;

ctor
  : type '(' arguments ')'
  { yTRACE("constructor -> ( arguemnts )\n");}
  ;

fn
  : fn_name '(' arguments_opt ')'
  { yTRACE("function -> function name ( arguments_opt )\n");}
  ;

fn_name
  : 'dp3'
  { yTRACE("function name -> dp3\n");}
  | 'lit'
  { yTRACE("function name -> lit\n");}
  | 'rsq'
  { yTRACE("function name -> rsq\n");}
  ;

arguments_opt
  : arguments
  { yTRACE("arguments_opt -> arguments\n");}
  |
  ;

arguments
  : arguments ',' expr
  { yTRACE("arguments -> arguments, expression\n");}
  | expr
  { yTRACE("arguments -> expression\n");}
  ;

%%

/***********************************************************************ol
 * Extra C code.
 *
 * The given yyerror function should not be touched. You may add helper
 * functions as necessary in subsequent phases.
 ***********************************************************************/
void yyerror(char* s) {
  if(errorOccurred) {
    return;    /* Error has already been reported by scanner */
  } else {
    errorOccurred = 1;
  }

  fprintf(errorFile, "\nPARSER ERROR, LINE %d", yyline);
  
  if(strcmp(s, "parse error")) {
    if(strncmp(s, "parse error, ", 13)) {
      fprintf(errorFile, ": %s\n", s);
    } else {
      fprintf(errorFile, ": %s\n", s+13);
    }
  } else {
    fprintf(errorFile, ": Reading token %s\n", yytname[YYTRANSLATE(yychar)]);
  }
}

