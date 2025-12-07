#include <stdio.h>

int meat(FILE *fp) {

}

int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");
  
  meat(fp);
}
