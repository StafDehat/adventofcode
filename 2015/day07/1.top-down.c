#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

// Initialize a hash to sizeof(maximum 2-digit base-27 number)
// 27*27=729
// 0 = 0
// a = 1
// z = 26
// aa = 27
int hash[729];

unsigned short indexOf(char* pos) {
  char b27digit;
  int  b10index = 0;
  for (int x=0; x<strlen(pos); x++) {
    b27digit = pos[x];
    b10index = b10index*('z'-'a'+1) + (b27digit-'a'+1);
  }
  return b10index;
}

unsigned short getVar(char* var) {
  int val;
  // If it's numeric, just return its int value:
  if ( val=atoi(var) ) {
    return val;
  }
  // Otherwise, lookup the current value of that variable:
  return hash[indexOf(var)];
}

void setVar(char* var, unsigned short val) {
  //printf("Setting hash[%s]=%d\n", var, val);
  hash[indexOf(var)] = val;
}

int startsWith(const char *a, const char *b)
{
   if (strncmp(a, b, strlen(b)) == 0)
     return 1;
   return 0;
}

void negation(char* line) {
  // NOT inVar -> outVar
  char* inVar;
  char* outVar;
  unsigned short inVal;
  unsigned short outVal;

  strtok(line, " \n"); //Chomp "NOT"
  inVar  = strtok(NULL, " \n");
  strtok(NULL, " \n"); //Chomp "->"
  outVar = strtok(NULL, " \n");

  inVal = getVar(inVar);
  outVal = ~ inVal; // ^ 65535; //XOR with all 1s
  printf("%s = NOT %s(%d) = %d\n", outVar, inVar, inVal, outVal);
  setVar(outVar, outVal);
}

void assignment(char* line) {
  // number -> outVar
  unsigned short value; //16 bits, 0-65535
  char* outVar;

  value  = atoi(strtok(line, " \n"));
  strtok(NULL, " \n"); //Chomp "->"
  outVar = strtok(NULL, " \n");

  printf("%s = %d\n", outVar, value);
  setVar(outVar, value);
}

void operation(char* line) {
  // invVar1 OP inVar2 -> outVar
  char* inVar1;
  char* operator;
  char* inVar2;
  char* outVar;
  unsigned short inVal1;
  unsigned short inVal2;
  unsigned short outVal;

  inVar1   = strtok(line, " \n");
  operator = strtok(NULL, " \n");
  inVar2   = strtok(NULL, " \n");
  strtok(NULL, " \n"); //Chomp "->"
  outVar   = strtok(NULL, " \n");

  inVal1 = getVar(inVar1);
  if ( startsWith(operator, "AND") ) {
    inVal2 = getVar(inVar2);
    outVal = inVal1 & inVal2;
  } else if ( startsWith(operator, "OR") ) {
    inVal2 = getVar(inVar2);
    outVal = inVal1 | inVal2;
  } else if ( startsWith(operator, "LSHIFT") ) {
    inVal2 = getVar(inVar2);
    outVal = inVal1 << inVal2;
  } else if ( startsWith(operator, "RSHIFT") ) {
    inVal2 = getVar(inVar2);
    outVal = inVal1 >> inVal2;
  } else {
    printf("ERROR: Unexpected operator: %s\n", operator);
  }
  printf("%s = %s(%d) %s %s(%d) = %d\n", outVar, inVar1, inVal1, operator, inVar2, inVal2, outVal);
  setVar(outVar, outVal);
}

void meat(FILE *fp) {
  char line[40];

  // Read the instructions, line-by-line
  while ( fgets(line,40,fp) ) {
    // Line could take one of 3 forms, identifiable by the first token:
    // NOT inVar         -> outVar
    // number            -> outVar
    // invVar1 OP inVar2 -> outVar
    printf("Processing: %s", line);
    if ( startsWith(line, "NOT") ) {
      negation(line);
    } else if ( strstr(line, "SHIFT") != NULL ||
                strstr(line, "AND")   != NULL ||
                strstr(line, "OR")    != NULL ) {
      operation(line);
    } else {
      assignment(line);
    }
  }

  printf("\n");
  printf("d: %d\n", getVar("d"));
  printf("e: %d\n", getVar("e"));
  printf("f: %d\n", getVar("f"));
  printf("g: %d\n", getVar("g"));
  printf("h: %d\n", getVar("h"));
  printf("i: %d\n", getVar("i"));
  printf("x: %d\n", getVar("x"));
  printf("y: %d\n", getVar("y"));
}

int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");

  meat(fp);
}

