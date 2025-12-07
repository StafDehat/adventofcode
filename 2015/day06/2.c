#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

#define NUMCOLS 1000
#define NUMROWS 1000

int lights[NUMCOLS][NUMROWS];
char line[40];

void mod(int minX, int minY, int maxX, int maxY, int value) {
  for (int x=minX; x<=maxX; x++) {
    for (int y=minY; y<=maxY; y++) {
      lights[x][y] = lights[x][y] + value;
      if ( lights[x][y] < 0 )
        lights[x][y] = 0;
    }
  }
}

int countBrightness() {
  int count=0;
  for (int x=0; x<NUMCOLS; x++) {
    for (int y=0; y<NUMROWS; y++) {
      count = count + lights[x][y];
    }
  }
  return count;
}

void getCoords(char* line, int* x, int* y) {
  int tmp = 0;
  int i = 0;
  // Find X coord
  while ( line[i] != ',' ) {
    if ( line[i] >= '0' && line[i] <= '9' ) {
      tmp = ( tmp * 10 ) + ( line[i] - '0' );
    }
    i++;
  }
  *x = tmp;
  tmp = 0;
  // Find Y coord
  while ( line[i] != ' ' && line[i] != '\0' ) {
    if ( line[i] >= '0' && line[i] <= '9' ) {
      tmp = ( tmp * 10 ) + ( line[i] - '0' );
    }
    i++;
  }
  *y = tmp;
}

int meat(FILE *fp) {
  // Initialize every light to 0
  for (int i=0; i<1000; i++) {
    memset(lights[i], 0, 1000*sizeof(int));
  }

  int minX;
  int minY;
  int maxX;
  int maxY;
  // Read the instructions, line-by-line
  while ( fgets(line,40,fp) ) {
    // Set min/max X/Y:
    getCoords(line, &minX, &minY);
    getCoords(strstr(line, "through"), &maxX, &maxY);

    // Perform the described action
    if ( strstr(line, "toggle") )
      mod(minX, minY, maxX, maxY, 2);
    else if ( strstr(line, "turn on") )
      mod(minX, minY, maxX, maxY, 1);
    else if ( strstr(line, "turn off") )
      mod(minX, minY, maxX, maxY, -1);
  }

  int howBright = countBrightness();
  printf("Total brightness: %i\n", howBright);
}

int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");

  meat(fp);
}

