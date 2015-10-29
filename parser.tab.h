/* A Bison parser, made by GNU Bison 3.0.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2013 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_YY_Y_TAB_H_INCLUDED
# define YY_YY_Y_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    INT_VAL = 258,
    FLOAT_VAL = 259,
    ID_VAL = 260,
    INT_TOK = 261,
    BOOL_TOK = 262,
    BVEC2_TOK = 263,
    BVEC3_TOK = 264,
    BVEC4_TOK = 265,
    IVEC2_TOK = 266,
    IVEC3_TOK = 267,
    IVEC4_TOK = 268,
    VEC2_TOK = 269,
    VEC3_TOK = 270,
    VEC4_TOK = 271,
    FLOAT_TOK = 272,
    MUL_TOK = 273,
    ADD_TOK = 274,
    SUB_TOK = 275,
    DIV_TOK = 276,
    ASSIGN_TOK = 277,
    NOT_TOK = 278,
    AND_TOK = 279,
    OR_TOK = 280,
    XOR_TOK = 281,
    LS_TOK = 282,
    GT_TOK = 283,
    LPAREN_TOK = 284,
    RPAREN_TOK = 285,
    LBRACE_TOK = 286,
    RBRACE_TOK = 287,
    LBRACKET_TOK = 288,
    RBRACKET_TOK = 289,
    SEMICOL_TOK = 290,
    COMMA_TOK = 291,
    TRUE_TOK = 292,
    FALSE_TOK = 293,
    IF_TOK = 294,
    ELSE_TOK = 295,
    WHILE_TOK = 296
  };
#endif
/* Tokens.  */
#define INT_VAL 258
#define FLOAT_VAL 259
#define ID_VAL 260
#define INT_TOK 261
#define BOOL_TOK 262
#define BVEC2_TOK 263
#define BVEC3_TOK 264
#define BVEC4_TOK 265
#define IVEC2_TOK 266
#define IVEC3_TOK 267
#define IVEC4_TOK 268
#define VEC2_TOK 269
#define VEC3_TOK 270
#define VEC4_TOK 271
#define FLOAT_TOK 272
#define MUL_TOK 273
#define ADD_TOK 274
#define SUB_TOK 275
#define DIV_TOK 276
#define ASSIGN_TOK 277
#define NOT_TOK 278
#define AND_TOK 279
#define OR_TOK 280
#define XOR_TOK 281
#define LS_TOK 282
#define GT_TOK 283
#define LPAREN_TOK 284
#define RPAREN_TOK 285
#define LBRACE_TOK 286
#define RBRACE_TOK 287
#define LBRACKET_TOK 288
#define RBRACKET_TOK 289
#define SEMICOL_TOK 290
#define COMMA_TOK 291
#define TRUE_TOK 292
#define FALSE_TOK 293
#define IF_TOK 294
#define ELSE_TOK 295
#define WHILE_TOK 296

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE YYSTYPE;
union YYSTYPE
{
#line 57 "parser.y" /* yacc.c:1909  */

  int intval;
  float floatval;
  int id_len;

#line 142 "y.tab.h" /* yacc.c:1909  */
};
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;

int yyparse (void);

#endif /* !YY_YY_Y_TAB_H_INCLUDED  */
