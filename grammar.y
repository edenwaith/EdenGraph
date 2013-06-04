%{
#include <libc.h>
/* extern int signgam; */
#include <math.h>


int printingError = 0;
%}

%start list

%{
double mem[26];
%}
%union
{
   int    ival;
   double dval;
}

%token <dval> NUMBER
%token <ival> VAR
%token <dval> SIN COS TAN ASIN ACOS ATAN ABS
%token <dval> SINH COSH TANH ASINH ACOSH ATANH
%token <dval> SQRT MOD LN LOG PI E
%type  <dval> expr number 

/* http://www.ifi.unizh.ch/study/Vorlesungen/unix/thema14/017_14.htm */

%right '='
%left '+' '-'
%left '*' '/' 
%left SIN COS TAN ASIN ACOS ATAN SINH COSH TANH ASINH ABS FLOOR CEIL ROUND
%left ACOSH ATANH
%left '%' SQRT MOD LN LOG
%nonassoc UMINUS   /* supplies precedence for unary minus */
%left '^' POW
%left NUMBER
%left VAR


%%             /* beginning of rules section */

list : stat
     | list stat
     ;

stat : expr '\n'
{
  printf("%10g\n",$1);
  printingError = 0;
  fflush(stdout);
}
| expr ',' expr '\n'
{
  printf("%g,%g\n", $1, $3);
  printingError = 0;
  fflush(stdout);
}
;

expr   : '(' expr ')' {  $$ = $2; }
  | VAR { $$ = mem[$1];}
  | VAR '=' expr { $$ = mem[$1] = $3;}
  | expr '+' expr   { $$ = $1 + $3;}
  | expr '-' expr   { $$ = $1 - $3;}
  | expr '*' expr   { $$ = $1 * $3;}
  | expr '/' expr   { $$ = $1 / $3;} 
/*  | expr expr 	    { $$ = $1 * $2;} */
/*  | expr expr  %prec '*' { $$ = $1 * $2;} */

  | SIN expr	    { $$ = sin($2);}
  | COS expr	    { $$ = cos($2);}
  | TAN expr	    { $$ = tan($2);}
  | ASIN expr	    { $$ = asin($2);}
  | ACOS expr	    { $$ = acos($2);}
  | ATAN expr	    { $$ = atan($2);}
  | SINH expr	    { $$ = sinh($2);}
  | COSH expr	    { $$ = cosh($2);}
  | TANH expr	    { $$ = tanh($2);}
  | ASINH expr	    { $$ = asinh($2);}
  | ACOSH expr	    { $$ = acosh($2);}
  | ATANH expr	    { $$ = atanh($2);}
  | ABS expr	    { $$ = fabs($2);} 	/* Added by CWA */
  | '|' expr '|'    { $$ = fabs($2);} 	/* Added by CWA */
  | expr '^' expr   { $$ = pow($1,$3);}
  | expr POW expr   { $$ = pow($1,$3);}  /* Added by CWA */
  | expr MOD expr   { $$ = fmod($1,$3);}
  | expr '%' expr   { $$ = fmod($1,$3);} /* Added by CWA */
  | LN expr	        { $$ = log($2);}
  | LOG expr	    { $$ = log10($2);}
  | SQRT expr	    { $$ = sqrt($2);}
  | FLOOR expr	    { $$ = floor($2);}	/* Added by CWA */
  | CEIL expr	    { $$ = ceil($2);}	/* Added by CWA */
  | ROUND expr      { $$ = rint($2);}	/* Added by CWA */
/*  | FACT expr       { $$ = sqrt($2);} */
  | expr '!'	    { $$ = factorial($1);} /* Added by CWA */
  | '-' expr  %prec UMINUS
  {
     $$ = -1 * $2; /* $$ = -$2; */
  }  

  | number
	;

number      : NUMBER   /* lex number */
  | PI      { $$ = M_PI;		}
  | E	    { $$ = M_E;		        }
  ;

%% /* beginning of functions section */

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
  if (printingError == 0) 
  {
     printf("Syntax Error: %s\n", s);
     fflush(stdout);
     printingError = 1;
  }
}

int main(int argc,char **argv)
{
  while (!feof(stdin)) 
  {
     yyparse();
  }
  exit(0);
}

