#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>


int hasThreeVowels(char* name) {
  int numVowels=0;
  int len=strlen(name);
  for (int i=0; i<len; i++) {
    if ( name[i] == 'a' || name[i] == 'e' ||
         name[i] == 'i' || name[i] == 'o' ||
         name[i] == 'u' ) {
      numVowels++;
    }
    if ( numVowels >= 3 )
      return 1;
  }
  return 0;
}

int hasDoubles(char* name) {
  int len=strlen(name);
  for (int i=0; i<len-1; i++) {
    if ( name[i] == name[i+1] )
      return 1;
  }
  return 0;
}

int hasBadLetters(char* name) {
  if ( strstr(name, "ab") != NULL )
    return 1;
  if ( strstr(name, "cd") != NULL )
    return 1;
  if ( strstr(name, "pq") != NULL )
    return 1;
  if ( strstr(name, "xy") != NULL )
    return 1;
  return 0;
}

int hasMirror(char* name) {
  int len=strlen(name);
  for (int i=0; i<len-2; i++) {
    if ( name[i] == name[i+2] )
      return 1;
  }
  return 0;
}

int hasDoublePair(char* name) {
  int len=strlen(name);
  char pair[3];
  for (int i=0; i<len-3; i++) {
    memcpy( pair, &name[i], 2 );
    pair[3] = '\0';
    if ( strstr(&name[i+2], pair) != NULL )
      return 1;
  }
  return 0;
}

int isNice(char* name) {
  if ( ! hasMirror(name) )
    return 0;
  if ( ! hasDoublePair(name) )
    return 0;
  return 1;
}

int meat(FILE *fp) {
  char line[100];
  int numNice=0;
  int numNaughty=0;

  while ( fgets(line,100,fp) ) {
    if (isNice(line))
      numNice++;
    else
      numNaughty++;
  }
  printf("Nice kids: %i\n", numNice);
  printf("Naughty kids: %i\n", numNaughty);
}

// main() is just gonna open a filehandle to our input
int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");
  
  meat(fp);
}
