#include <stdio.h>

int meat(FILE *fp) {
  char token;
  int floor = 0;
  int numTokens = 0;

  while ( token=fgetc((FILE*)fp) ) {
    if ( token == EOF ) { break; }
    if ( token == '(' ) { floor++; }
    if ( token == ')' ) { floor--; }
    numTokens++;
    if ( floor < 0 ) { break; }
  }
  printf("On floor %i after %i changes\n", floor, numTokens);
}

int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");
  
  meat(fp);
}
