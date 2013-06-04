/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton interface for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

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

/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     NUMBER = 258,
     VAR = 259,
     SIN = 260,
     COS = 261,
     TAN = 262,
     ASIN = 263,
     ACOS = 264,
     ATAN = 265,
     ABS = 266,
     SINH = 267,
     COSH = 268,
     TANH = 269,
     ASINH = 270,
     ACOSH = 271,
     ATANH = 272,
     SQRT = 273,
     MOD = 274,
     LN = 275,
     LOG = 276,
     PI = 277,
     E = 278,
     ROUND = 279,
     CEIL = 280,
     FLOOR = 281,
     UMINUS = 282,
     POW = 283
   };
#endif
/* Tokens.  */
#define NUMBER 258
#define VAR 259
#define SIN 260
#define COS 261
#define TAN 262
#define ASIN 263
#define ACOS 264
#define ATAN 265
#define ABS 266
#define SINH 267
#define COSH 268
#define TANH 269
#define ASINH 270
#define ACOSH 271
#define ATANH 272
#define SQRT 273
#define MOD 274
#define LN 275
#define LOG 276
#define PI 277
#define E 278
#define ROUND 279
#define CEIL 280
#define FLOOR 281
#define UMINUS 282
#define POW 283




#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 16 "/Users/admin/Programs/Mac/EdenGraph/grammar.y"
{
   int    ival;
   double dval;
}
/* Line 1529 of yacc.c.  */
#line 110 "/Users/admin/Programs/Mac/EdenGraph/build/EdenGraph.build/Development/Evaluator (Upgraded).build/DerivedSources/y.tab.h"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif

extern YYSTYPE yylval;

