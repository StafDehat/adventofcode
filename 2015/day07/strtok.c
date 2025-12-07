#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

int min(int a, int b, int c) {
  if ( a < b & a < c ) {
    return a;
  }
  else if ( b < c ) {
    return b;
  }
  return c;
}

int getArea(char* line) {
  int l = atoi(strtok(line, "x"));
  int w = atoi(strtok(NULL, "x"));
  int h = atoi(strtok(NULL, "x"));
  //printf("Dimensions: %i x %i x %i\n", l, w, h);
  int top = l * w;
  int edge = l * h;
  int face = h * w;
  return top*2 + edge*2 + face*2 + min(top,edge,face);
}

int meat(FILE *fp) {
  char line[100];
  int sum=0;

  while ( fgets(line,100,fp) ) {
    sum+=getArea(line);
  }
  printf("Total area: %i\n", sum);
}

// main() is just gonna open a filehandle to our input
int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");
  
  meat(fp);
}
