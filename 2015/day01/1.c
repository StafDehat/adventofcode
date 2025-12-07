#include <stdio.h>

int meat(FILE *fp) {
  char token;
  int floor = 0;

  while ( token=fgetc((FILE*)fp) ) {
    if ( token == EOF ) { break; }
    if ( token == '(' ) { floor++; }
    if ( token == ')' ) { floor--; }
    //printf("%c\n", token);
  }
  printf("On floor: %i\n", floor);
}

int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");
  
  meat(fp);
}
