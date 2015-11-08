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

// Operator precedence
%right "then" ELSE

%left     OR     //Lowest
%left     AND
%left     '<' LEQ '>' GEQ EQ NEQ
%left     '+' '-'
%left     '*' '/'
%right    '^'
%right '!' UMINUS

%left     '(' '['   //Highest

// Initial solution for else dangling
// match statements with else and without else
// treat the two cases (if then, if then else)
// as separate rules with left associativity
// to be paired with the closest else
%left MATCHED_ELSE
%left UNMATCHED_ELSE

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
  : declaration type ID ';'
  { yTRACE("declaration -> type ID\n");}  
  | declaration type ID '=' expr ';'
  { yTRACE("declaration -> type ID = expr\n");}  
  | declaration CONST type ID '=' expr ';'
  { yTRACE("declaration -> const type ID = expr\n");}  
  |
  { yTRACE("declaration -> empty\n");}
  ;

statements
  : statements statement
  { yTRACE("statements -> statements statement\n");}
  |
  { yTRACE("statements -> empty\n");}
  ;

statement
  : var '=' expr ';'
  { yTRACE("statement -> variable = expression\n");}
  | IF '(' expr ')' statement %prec "then"
  { yTRACE("statement -> if (expression) statement\n");}
  | IF '(' expr ')' statement ELSE statement 
  { yTRACE("statement -> if (expression) statement else statement\n");}
  | WHILE '('expr ')' statement
  { yTRACE("statement -> while (expression) statement\n");}
  | scope
  { yTRACE("statement -> scope\n");}
  | ';'
  { yTRACE("statement -> ;\n");}
  ;

/*
statement
  : var '=' expr ';'
  { yTRACE("statement -> variable = expression\n");}
  | IF '(' expr ')' statement else_statement
  { yTRACE("statement -> if (expression) statement\n");}
  | WHILE '('expr ')' statement
  { yTRACE("statement -> while (expression) statement\n");}
  | scope
  { yTRACE("statement -> scope\n");}
  | ';'
  { yTRACE("statement -> ;\n");}
  ;

else_statement
  : ELSE statement
  { yTRACE("else_statement -> else statment\n");}
  |
  ;
*/


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

/*
expr
  : unary_op expr
  { yTRACE("expression -> unary_op expression\n");}
  | expr_prime binary_op expr
  { yTRACE("expression -> expression binary_op expression\n");}
  | expr_prime
  ;

expr_prime
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
  | TRUE_C 
  { yTRACE("expression -> true\n");}  
  | FALSE_C
  { yTRACE("expression -> false\n");}
  | '(' expr ')'
	{ yTRACE("expression -> (expression)\n");}
  ;
*/

var
  : ID
  { yTRACE("variable -> ID\n");}
  | ID '[' INT_C ']' %prec '['
  { yTRACE("variable -> ID[int literal]\n");}
  ;

unary_op
  : '!'
  { yTRACE("unary_op -> !\n");}
  | '-'
  { yTRACE("unary_op -> -\n");}
  ;

binary_op
  : AND
  { yTRACE("binary_op -> AND\n");}
  | OR
  { yTRACE("binary_op -> OR\n");}
  | EQ
  { yTRACE("binary_op -> EQ\n");}
  | NEQ
  { yTRACE("binary_op -> NE\n");}
  | '<'
  { yTRACE("binary_op -> <\n");}
  | LEQ
  { yTRACE("binary_op -> LEQ\n");}
  | '>'
  { yTRACE("binary_op -> >\n");}
  | GEQ
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
  : type '(' arguments ')' %prec '('
  { yTRACE("constructor -> ( arguemnts )\n");}
  ;

fn
  : fn_name '(' arguments_opt ')' %prec '('
  { yTRACE("function -> function name ( arguments_opt )\n");}
  ;

fn_name
  : FUNC
  { 
    if (yyval.as_func == 0) {
      yTRACE("function name -> dp3\n");
    }
    if (yyval.as_func == 1) {
      yTRACE("function name -> lit\n");
    }
    if (yyval.as_func == 2) {
      yTRACE("function name -> rsq\n");
    }
  }
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


