#include <iostream.h>
#include <string.h>

int main ()
{
  char orig_string[30] = "food";
  char conv_string[30] = ""; // it is VITAL to initialize this string!  Otherwise, Mac OS X won't be able to
                             // go past printing out the orig_len: line.  Don't know why, that is just how
                             // it happens.
  int orig_len = 0;
  int i = 0;
  int j = 0;

  orig_len = strlen(orig_string);

//  printf("\norig_leng: %d\n", orig_len);
  cout << "orig_len: " << orig_len << endl;

  for (i = 0; i < orig_len; i++)
  {
    conv_string[i] = orig_string[i];
  }

//  printf("conv_string: %s\n", conv_string);
  cout << "conv_string: " << conv_string << endl;
}
