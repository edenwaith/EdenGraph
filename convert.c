#include <stdio.h>
#include <string.h>
#include <ctype.h>

/* TYPES: Numbers (0..9), operators (+, -, *, /, ^), variables (x), parenthesis ( () ), 
   trig functs( sin, cos...), nothing */
   
/* TYPES of errors: mismatched parenthesis, unrecognized function or variable (like sim, instead of sin) */

enum eg_type {NUMBER, OPERATOR, VARIABLE, PARENTHESIS, TRIG, NOTHING};

int is_digit(char ch);

int main ()
{
  char orig_string[30] = "3 + 2X";
  char conv_string[30] = ""; /* keep in mind this might get longer than the original string */
  int orig_len = 0;
  int i = 0;
  int j = 0;
  enum eg_type prev_type = NOTHING;
  enum eg_type cur_type = NOTHING;

  orig_len = strlen(orig_string);

  printf("\norig_leng: %d\n", orig_len);

  for (i = 0; i < orig_len; i++)
  {
    /* pre-testing */
    if (is_digit(orig_string[i]) == 1)
    {
        printf("See number: %c\n", orig_string[i]);
        cur_type = NUMBER;
    }
    else if (orig_string[i] == 'x')
    {
        printf("See little x\n");
        cur_type = VARIABLE;
    }
    else if (orig_string[i] == 'X')
    {
        printf("In X\n");
        orig_string[i] = tolower(orig_string[i]);
        cur_type = VARIABLE;
    }
    else
    {
        printf("Otherwise: %c\n", orig_string[i]);
    }
    
    /* fix string if necessary */
    if (isspace(orig_string[i]) == 0) // if it is not white space
    {
        conv_string[j] = orig_string[i];
        j++;

    }
    else
    {
        //printf("%c %d\n", orig_string[i], isspace(orig_string[i]));
    }
  }

  printf("conv_string: .%s.\n", conv_string);
}

/* return 1 if true, and 0 if false */
int is_digit(char ch)
{
    switch (ch)
    {
        case '0': return 1; break;
        case '1': return 1; break;
        case '2': return 1; break;
        case '3': return 1; break;
        case '4': return 1; break;
        case '5': return 1; break;
        case '6': return 1; break;
        case '7': return 1; break;
        case '8': return 1; break;
        case '9': return 1; break;
        default: return 0;
    }
}
