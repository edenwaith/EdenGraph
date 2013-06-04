#include <sys/cdefs.h>
#ifndef lint
#if 0
static char yysccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
#else
__IDSTRING(yyrcsid, "$NetBSD: skeleton.c,v 1.14 1997/10/20 03:41:16 lukem Exp $");
#endif
#endif
#include <stdlib.h>
#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYLEX yylex()
#define YYEMPTY -1
#define yyclearin (yychar=(YYEMPTY))
#define yyerrok (yyerrflag=0)
#define YYRECOVERING (yyerrflag!=0)
#define YYPREFIX "yy"
#line 12 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
#include <libc.h>

/* extern int signgam; */

#include <math.h>


int printingError = 0;
#line 25 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
double mem[26];
#line 27 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
typedef union
{
   int    ival;
   double dval;
} YYSTYPE;
#line 37 "/Users/admin/Programs/EdenGraph 1.2.2/build/EdenGraph.build/Deployment/Evaluator (Upgraded).build/DerivedSources/y.tab.c"
#define NUMBER 257
#define VAR 258
#define SIN 259
#define COS 260
#define TAN 261
#define ASIN 262
#define ACOS 263
#define ATAN 264
#define ABS 265
#define SINH 266
#define COSH 267
#define TANH 268
#define ASINH 269
#define ACOSH 270
#define ATANH 271
#define SQRT 272
#define MOD 273
#define LN 274
#define LOG 275
#define PI 276
#define E 277
#define FLOOR 278
#define CEIL 279
#define UMINUS 280
#define POW 281
#define ROUND 282
#define YYERRCODE 256
short yylhs[] = {                                        -1,
    0,    0,    3,    3,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    1,    1,    1,    1,    1,    1,
    1,    1,    1,    1,    1,    1,    1,    1,    2,    2,
    2,
};
short yylen[] = {                                         2,
    1,    2,    2,    4,    3,    1,    3,    3,    3,    3,
    3,    2,    2,    2,    2,    2,    2,    2,    2,    2,
    2,    2,    2,    2,    3,    3,    3,    3,    3,    2,
    2,    2,    2,    2,    2,    2,    2,    1,    1,    1,
    1,
};
short yydefred[] = {                                      0,
   39,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   40,   41,
    0,    0,    0,    0,    0,    0,    0,    0,   38,    1,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    2,    0,    0,    0,    0,    0,    0,
    0,    0,    3,    0,   36,    0,    5,   25,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    4,
};
short yydgoto[] = {                                      27,
   28,   29,   30,
};
short yysindex[] = {                                    178,
    0,  -59,  178,  178,  178,  178,  178,  178,  178,  178,
  178,  178,  178,  178,  178,  178,  178,  178,    0,    0,
  178,  178,  178,  178,  178,  178,  178,   28,    0,    0,
  178,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,  -32,
  -32,  -32,  -32,  -32,  -27,  -27,  -27,  -27,  -32,  -32,
  -30,   84,  142,    0,  178,  178,  178,  178,  178,  178,
  178,  178,    0,  178,    0,  142,    0,    0,  -27,  153,
  153,  -32,  -32,  -27,  -29,  -29,   44,    0,
};
short yyrindex[] = {                                      0,
    0,  -10,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,  170,  184,  269,  277,  286,  297,  305,  343,  353,
  362,  421,  448,  459,   53,   64,  100,  109,  466,  473,
    0,    0,   16,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,   72,    0,    0,  118,  158,
  247,  484,  495,  129,   -1,    8,    0,    0,
};
short yygindex[] = {                                      0,
  543,    0,  -19,
};
#define YYTABLESIZE 619
short yytable[] = {                                       6,
   65,   31,   65,   65,   60,   65,   60,   54,   26,    0,
   67,   58,   56,    0,   57,    0,   59,   27,    0,    0,
    0,    0,    6,    0,    0,   35,    6,    0,    0,    0,
    6,    6,    6,    6,    6,   26,    6,   63,    0,   26,
   26,   26,   26,   26,   27,   26,    0,    0,   27,   27,
   27,   27,   27,   78,   27,    0,   35,    0,    0,   35,
   65,   61,   32,   61,   60,    0,   61,    0,    0,   58,
   56,   64,   57,   30,   59,    0,   65,    0,    0,    0,
   60,    7,    0,    6,    0,   58,   56,    0,   57,   32,
   59,    0,   26,   32,   32,   32,   32,   32,    0,   32,
   30,   27,    0,    0,   30,   30,   30,   30,   30,   31,
   30,    0,    7,    6,    0,    7,   65,    0,   37,    0,
   60,   61,   26,    0,    0,   58,   56,   28,   57,    0,
   59,   27,    0,    0,    0,    0,   31,   61,   29,   35,
   31,   31,   31,   31,   31,   37,   31,    0,    0,   37,
   37,   37,   37,   37,   28,   37,    0,    0,   28,   28,
   28,   28,   28,    0,   28,   29,    0,    8,    0,   29,
   29,   29,   29,   29,   65,   29,   32,   61,   60,   12,
    0,    0,    0,   58,   56,   65,   57,   30,   59,   60,
    0,    0,    0,   13,   58,    7,    0,    0,    8,   59,
    8,    8,    8,    0,    0,    0,    0,   68,    0,    0,
   12,   12,   12,   12,   12,    0,   12,   24,    0,    0,
    0,    0,   21,   31,   13,   13,   13,   13,   13,    0,
   13,    0,   37,    0,    0,   61,    0,    0,    0,    0,
   55,   28,   55,    0,    0,    0,   61,    0,   62,    0,
   62,    0,   29,   62,    0,    0,    9,    0,    0,    0,
    0,    0,    6,    0,    0,    0,    0,    0,    0,    0,
    6,   26,    0,    0,    0,    0,    0,    0,   14,   26,
   27,    8,    0,    0,    0,    0,   15,    9,   27,    9,
    9,    9,    0,   12,    0,   16,    0,    0,    0,    0,
   55,   25,    0,    0,    0,    0,   17,   13,   62,   14,
   14,   14,   14,   14,   24,   14,   55,   15,   15,   15,
   15,   15,    0,   15,   62,   32,   16,   16,   16,   16,
   16,    0,   16,    0,    0,    0,   30,   17,   17,   17,
   17,   17,    0,   17,    0,   24,   24,   24,   24,   24,
    0,   24,   18,    0,    0,    0,   55,    0,    0,    0,
    0,    0,   19,    0,   62,    0,    0,    0,    0,    0,
    9,   20,   31,    0,    0,    0,    0,    0,    0,    0,
    0,   37,    0,   18,   18,   18,   18,   18,    0,   18,
   28,    0,   14,   19,   19,   19,   19,   19,    0,   19,
   15,   29,   20,   20,   20,   20,   20,    0,   20,   16,
    0,    0,    0,    0,   55,    0,    0,    0,    0,    0,
   17,    0,   62,    0,    0,   55,    0,    0,   24,    0,
   21,    0,    0,   62,    1,    2,    3,    4,    5,    6,
    7,    8,    9,   10,   11,   12,   13,   14,   15,   16,
    0,   17,   18,   19,   20,   22,   23,   22,    0,   26,
    0,   21,   21,   21,   21,   21,   18,   21,   23,    0,
    0,    0,    0,    0,    0,   33,   19,    0,    0,    0,
    0,    0,   34,    0,    0,   20,    0,    0,   22,   22,
   22,   22,   22,   10,   22,    0,    0,    0,    0,   23,
   23,   23,   23,   23,   11,   23,   33,   33,   33,   33,
   33,    0,   33,   34,   34,   34,   34,   34,    0,   34,
    0,    0,    0,    0,   10,   10,   10,   10,   10,    0,
   10,    0,    0,    0,    0,   11,   11,   11,   11,   11,
    0,   11,    0,    0,   21,   32,   33,   34,   35,   36,
   37,   38,   39,   40,   41,   42,   43,   44,   45,   46,
   47,    0,    0,   48,   49,   50,   51,   52,   53,    0,
    0,   22,    0,   66,    0,    0,    0,    0,    0,    0,
    0,    0,   23,    0,    0,    0,    0,    0,    0,   33,
    0,    0,    0,    0,    0,    0,   34,   69,   70,   71,
   72,   73,   74,   75,   76,    0,   77,   10,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,   11,
};
short yycheck[] = {                                      10,
   33,   61,   33,   33,   37,   33,   37,   27,   10,   -1,
   41,   42,   43,   -1,   45,   -1,   47,   10,   -1,   -1,
   -1,   -1,   33,   -1,   -1,   10,   37,   -1,   -1,   -1,
   41,   42,   43,   44,   45,   37,   47,   10,   -1,   41,
   42,   43,   44,   45,   37,   47,   -1,   -1,   41,   42,
   43,   44,   45,   10,   47,   -1,   41,   -1,   -1,   44,
   33,   94,   10,   94,   37,   -1,   94,   -1,   -1,   42,
   43,   44,   45,   10,   47,   -1,   33,   -1,   -1,   -1,
   37,   10,   -1,   94,   -1,   42,   43,   -1,   45,   37,
   47,   -1,   94,   41,   42,   43,   44,   45,   -1,   47,
   37,   94,   -1,   -1,   41,   42,   43,   44,   45,   10,
   47,   -1,   41,  124,   -1,   44,   33,   -1,   10,   -1,
   37,   94,  124,   -1,   -1,   42,   43,   10,   45,   -1,
   47,  124,   -1,   -1,   -1,   -1,   37,   94,   10,  124,
   41,   42,   43,   44,   45,   37,   47,   -1,   -1,   41,
   42,   43,   44,   45,   37,   47,   -1,   -1,   41,   42,
   43,   44,   45,   -1,   47,   37,   -1,   10,   -1,   41,
   42,   43,   44,   45,   33,   47,  124,   94,   37,   10,
   -1,   -1,   -1,   42,   43,   33,   45,  124,   47,   37,
   -1,   -1,   -1,   10,   42,  124,   -1,   -1,   41,   47,
   43,   44,   45,   -1,   -1,   -1,   -1,  124,   -1,   -1,
   41,   42,   43,   44,   45,   -1,   47,   40,   -1,   -1,
   -1,   -1,   45,  124,   41,   42,   43,   44,   45,   -1,
   47,   -1,  124,   -1,   -1,   94,   -1,   -1,   -1,   -1,
  273,  124,  273,   -1,   -1,   -1,   94,   -1,  281,   -1,
  281,   -1,  124,  281,   -1,   -1,   10,   -1,   -1,   -1,
   -1,   -1,  273,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
  281,  273,   -1,   -1,   -1,   -1,   -1,   -1,   10,  281,
  273,  124,   -1,   -1,   -1,   -1,   10,   41,  281,   43,
   44,   45,   -1,  124,   -1,   10,   -1,   -1,   -1,   -1,
  273,  124,   -1,   -1,   -1,   -1,   10,  124,  281,   41,
   42,   43,   44,   45,   10,   47,  273,   41,   42,   43,
   44,   45,   -1,   47,  281,  273,   41,   42,   43,   44,
   45,   -1,   47,   -1,   -1,   -1,  273,   41,   42,   43,
   44,   45,   -1,   47,   -1,   41,   42,   43,   44,   45,
   -1,   47,   10,   -1,   -1,   -1,  273,   -1,   -1,   -1,
   -1,   -1,   10,   -1,  281,   -1,   -1,   -1,   -1,   -1,
  124,   10,  273,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,  273,   -1,   41,   42,   43,   44,   45,   -1,   47,
  273,   -1,  124,   41,   42,   43,   44,   45,   -1,   47,
  124,  273,   41,   42,   43,   44,   45,   -1,   47,  124,
   -1,   -1,   -1,   -1,  273,   -1,   -1,   -1,   -1,   -1,
  124,   -1,  281,   -1,   -1,  273,   -1,   -1,  124,   -1,
   10,   -1,   -1,  281,  257,  258,  259,  260,  261,  262,
  263,  264,  265,  266,  267,  268,  269,  270,  271,  272,
   -1,  274,  275,  276,  277,  278,  279,   10,   -1,  282,
   -1,   41,   42,   43,   44,   45,  124,   47,   10,   -1,
   -1,   -1,   -1,   -1,   -1,   10,  124,   -1,   -1,   -1,
   -1,   -1,   10,   -1,   -1,  124,   -1,   -1,   41,   42,
   43,   44,   45,   10,   47,   -1,   -1,   -1,   -1,   41,
   42,   43,   44,   45,   10,   47,   41,   42,   43,   44,
   45,   -1,   47,   41,   42,   43,   44,   45,   -1,   47,
   -1,   -1,   -1,   -1,   41,   42,   43,   44,   45,   -1,
   47,   -1,   -1,   -1,   -1,   41,   42,   43,   44,   45,
   -1,   47,   -1,   -1,  124,    3,    4,    5,    6,    7,
    8,    9,   10,   11,   12,   13,   14,   15,   16,   17,
   18,   -1,   -1,   21,   22,   23,   24,   25,   26,   -1,
   -1,  124,   -1,   31,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,  124,   -1,   -1,   -1,   -1,   -1,   -1,  124,
   -1,   -1,   -1,   -1,   -1,   -1,  124,   55,   56,   57,
   58,   59,   60,   61,   62,   -1,   64,  124,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,  124,
};
#define YYFINAL 27
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 282
#if YYDEBUG
char *yyname[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,"'\\n'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,"'!'",0,0,0,"'%'",0,0,"'('","')'","'*'","'+'","','","'-'",0,"'/'",0,0,0,0,0,
0,0,0,0,0,0,0,0,"'='",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,"'^'",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,"'|'",0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,"NUMBER","VAR","SIN","COS","TAN","ASIN","ACOS","ATAN","ABS",
"SINH","COSH","TANH","ASINH","ACOSH","ATANH","SQRT","MOD","LN","LOG","PI","E",
"FLOOR","CEIL","UMINUS","POW","ROUND",
};
char *yyrule[] = {
"$accept : list",
"list : stat",
"list : list stat",
"stat : expr '\\n'",
"stat : expr ',' expr '\\n'",
"expr : '(' expr ')'",
"expr : VAR",
"expr : VAR '=' expr",
"expr : expr '+' expr",
"expr : expr '-' expr",
"expr : expr '*' expr",
"expr : expr '/' expr",
"expr : SIN expr",
"expr : COS expr",
"expr : TAN expr",
"expr : ASIN expr",
"expr : ACOS expr",
"expr : ATAN expr",
"expr : SINH expr",
"expr : COSH expr",
"expr : TANH expr",
"expr : ASINH expr",
"expr : ACOSH expr",
"expr : ATANH expr",
"expr : ABS expr",
"expr : '|' expr '|'",
"expr : expr '^' expr",
"expr : expr POW expr",
"expr : expr MOD expr",
"expr : expr '%' expr",
"expr : LN expr",
"expr : LOG expr",
"expr : SQRT expr",
"expr : FLOOR expr",
"expr : CEIL expr",
"expr : ROUND expr",
"expr : expr '!'",
"expr : '-' expr",
"expr : number",
"number : NUMBER",
"number : PI",
"number : E",
};
#endif
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 10000
#define YYMAXDEPTH 10000
#endif
#endif
#define YYINITSTACKSIZE 200
int yydebug;
int yynerrs;
int yyerrflag;
int yychar;
short *yyssp;
YYSTYPE *yyvsp;
YYSTYPE yyval;
YYSTYPE yylval;
short *yyss;
short *yysslim;
YYSTYPE *yyvs;
int yystacksize;
#line 132 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
 /* beginning of functions section */

/* http://www.gnu.org/software/libc/manual/html_node/Special-Functions.html */
/* References to signgam error with i386 compiler:
	http://sourceware.org/ml/newlib/2001/msg00368.html
	http://permalink.gmane.org/gmane.os.apple.fink.tracker/7619
 */
double factorial(double val)
{
    double g, lg;
    
    lg = lgamma(val+1);
    g = signgam*exp(lg); /* signgam is a predefined variable */
    
    return (g);
}

void yyerror(char *s)
{
  if (printingError == 0) {
     printf("Syntax Error: %s\n", s);
     fflush(stdout);
     printingError = 1;
  }
}

int main(int argc,char **argv)
{
  while (!feof(stdin)) {
     yyparse();
  }
  exit(0);
}

#line 366 "/Users/admin/Programs/EdenGraph 1.2.2/build/EdenGraph.build/Deployment/Evaluator (Upgraded).build/DerivedSources/y.tab.c"
/* allocate initial stack or double stack size, up to YYMAXDEPTH */
int yyparse __P((void));
static int yygrowstack __P((void));
static int yygrowstack()
{
    int newsize, i;
    short *newss;
    YYSTYPE *newvs;

    if ((newsize = yystacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return -1;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;
    i = yyssp - yyss;
    if ((newss = (short *)realloc(yyss, newsize * sizeof *newss)) == NULL)
        return -1;
    yyss = newss;
    yyssp = newss + i;
    if ((newvs = (YYSTYPE *)realloc(yyvs, newsize * sizeof *newvs)) == NULL)
        return -1;
    yyvs = newvs;
    yyvsp = newvs + i;
    yystacksize = newsize;
    yysslim = yyss + newsize - 1;
    return 0;
}

#define YYABORT goto yyabort
#define YYREJECT goto yyabort
#define YYACCEPT goto yyaccept
#define YYERROR goto yyerrlab
int
yyparse()
{
    int yym, yyn, yystate;
#if YYDEBUG
    char *yys;

    if ((yys = getenv("YYDEBUG")) != NULL)
    {
        yyn = *yys;
        if (yyn >= '0' && yyn <= '9')
            yydebug = yyn - '0';
    }
#endif

    yynerrs = 0;
    yyerrflag = 0;
    yychar = (-1);

    if (yyss == NULL && yygrowstack()) goto yyoverflow;
    yyssp = yyss;
    yyvsp = yyvs;
    *yyssp = yystate = 0;

yyloop:
    if ((yyn = yydefred[yystate]) != 0) goto yyreduce;
    if (yychar < 0)
    {
        if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
    }
    if ((yyn = yysindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, yystate, yytable[yyn]);
#endif
        if (yyssp >= yysslim && yygrowstack())
        {
            goto yyoverflow;
        }
        *++yyssp = yystate = yytable[yyn];
        *++yyvsp = yylval;
        yychar = (-1);
        if (yyerrflag > 0)  --yyerrflag;
        goto yyloop;
    }
    if ((yyn = yyrindex[yystate]) && (yyn += yychar) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yychar)
    {
        yyn = yytable[yyn];
        goto yyreduce;
    }
    if (yyerrflag) goto yyinrecovery;
    goto yynewerror;
yynewerror:
    yyerror("syntax error");
    goto yyerrlab;
yyerrlab:
    ++yynerrs;
yyinrecovery:
    if (yyerrflag < 3)
    {
        yyerrflag = 3;
        for (;;)
        {
            if ((yyn = yysindex[*yyssp]) && (yyn += YYERRCODE) >= 0 &&
                    yyn <= YYTABLESIZE && yycheck[yyn] == YYERRCODE)
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *yyssp, yytable[yyn]);
#endif
                if (yyssp >= yysslim && yygrowstack())
                {
                    goto yyoverflow;
                }
                *++yyssp = yystate = yytable[yyn];
                *++yyvsp = yylval;
                goto yyloop;
            }
            else
            {
#if YYDEBUG
                if (yydebug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *yyssp);
#endif
                if (yyssp <= yyss) goto yyabort;
                --yyssp;
                --yyvsp;
            }
        }
    }
    else
    {
        if (yychar == 0) goto yyabort;
#if YYDEBUG
        if (yydebug)
        {
            yys = 0;
            if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
            if (!yys) yys = "illegal-symbol";
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, yystate, yychar, yys);
        }
#endif
        yychar = (-1);
        goto yyloop;
    }
yyreduce:
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, yystate, yyn, yyrule[yyn]);
#endif
    yym = yylen[yyn];
    yyval = yyvsp[1-yym];
    switch (yyn)
    {
case 3:
#line 69 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{
  printf("%10g\n",yyvsp[-1].dval);
  printingError = 0;
  fflush(stdout);
}
break;
case 4:
#line 75 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{
  printf("%g,%g\n", yyvsp[-3].dval, yyvsp[-1].dval);
  printingError = 0;
  fflush(stdout);
}
break;
case 5:
#line 82 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{  yyval.dval = yyvsp[-1].dval; }
break;
case 6:
#line 83 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = mem[yyvsp[0].ival];}
break;
case 7:
#line 84 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = mem[yyvsp[-2].ival] = yyvsp[0].dval;}
break;
case 8:
#line 85 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = yyvsp[-2].dval + yyvsp[0].dval;}
break;
case 9:
#line 86 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = yyvsp[-2].dval - yyvsp[0].dval;}
break;
case 10:
#line 87 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = yyvsp[-2].dval * yyvsp[0].dval;}
break;
case 11:
#line 88 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = yyvsp[-2].dval / yyvsp[0].dval;}
break;
case 12:
#line 93 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = sin(yyvsp[0].dval);}
break;
case 13:
#line 94 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = cos(yyvsp[0].dval);}
break;
case 14:
#line 95 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = tan(yyvsp[0].dval);}
break;
case 15:
#line 96 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = asin(yyvsp[0].dval);}
break;
case 16:
#line 97 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = acos(yyvsp[0].dval);}
break;
case 17:
#line 98 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = atan(yyvsp[0].dval);}
break;
case 18:
#line 99 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = sinh(yyvsp[0].dval);}
break;
case 19:
#line 100 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = cosh(yyvsp[0].dval);}
break;
case 20:
#line 101 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = tanh(yyvsp[0].dval);}
break;
case 21:
#line 102 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = asinh(yyvsp[0].dval);}
break;
case 22:
#line 103 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = acosh(yyvsp[0].dval);}
break;
case 23:
#line 104 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = atanh(yyvsp[0].dval);}
break;
case 24:
#line 105 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = fabs(yyvsp[0].dval);}
break;
case 25:
#line 106 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = fabs(yyvsp[-1].dval);}
break;
case 26:
#line 107 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = pow(yyvsp[-2].dval,yyvsp[0].dval);}
break;
case 27:
#line 108 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = pow(yyvsp[-2].dval,yyvsp[0].dval);}
break;
case 28:
#line 109 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = fmod(yyvsp[-2].dval,yyvsp[0].dval);}
break;
case 29:
#line 110 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = fmod(yyvsp[-2].dval,yyvsp[0].dval);}
break;
case 30:
#line 111 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = log(yyvsp[0].dval);}
break;
case 31:
#line 112 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = log10(yyvsp[0].dval);}
break;
case 32:
#line 113 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = sqrt(yyvsp[0].dval);}
break;
case 33:
#line 114 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = floor(yyvsp[0].dval);}
break;
case 34:
#line 115 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = ceil(yyvsp[0].dval);}
break;
case 35:
#line 116 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = rint(yyvsp[0].dval);}
break;
case 36:
#line 118 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = factorial(yyvsp[-1].dval);}
break;
case 37:
#line 120 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{
     yyval.dval = -1 * yyvsp[0].dval; /* $$ = -$2; */
  }
break;
case 40:
#line 128 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = M_PI;		}
break;
case 41:
#line 129 "/Users/admin/Programs/EdenGraph 1.2.2/grammar.y"
{ yyval.dval = M_E;		        }
break;
#line 690 "/Users/admin/Programs/EdenGraph 1.2.2/build/EdenGraph.build/Deployment/Evaluator (Upgraded).build/DerivedSources/y.tab.c"
    }
    yyssp -= yym;
    yystate = *yyssp;
    yyvsp -= yym;
    yym = yylhs[yyn];
    if (yystate == 0 && yym == 0)
    {
#if YYDEBUG
        if (yydebug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        yystate = YYFINAL;
        *++yyssp = YYFINAL;
        *++yyvsp = yyval;
        if (yychar < 0)
        {
            if ((yychar = yylex()) < 0) yychar = 0;
#if YYDEBUG
            if (yydebug)
            {
                yys = 0;
                if (yychar <= YYMAXTOKEN) yys = yyname[yychar];
                if (!yys) yys = "illegal-symbol";
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, yychar, yys);
            }
#endif
        }
        if (yychar == 0) goto yyaccept;
        goto yyloop;
    }
    if ((yyn = yygindex[yym]) && (yyn += yystate) >= 0 &&
            yyn <= YYTABLESIZE && yycheck[yyn] == yystate)
        yystate = yytable[yyn];
    else
        yystate = yydgoto[yym];
#if YYDEBUG
    if (yydebug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *yyssp, yystate);
#endif
    if (yyssp >= yysslim && yygrowstack())
    {
        goto yyoverflow;
    }
    *++yyssp = yystate;
    *++yyvsp = yyval;
    goto yyloop;
yyoverflow:
    yyerror("yacc stack overflow");
yyabort:
    return (1);
yyaccept:
    return (0);
}
