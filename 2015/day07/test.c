#include <stdio.h>

int main() {
  printf("Int:    %5li\n", sizeof(int));
  printf("Short:  %5li\n", sizeof(short));
  printf("Long:   %5li\n", sizeof(long));
  printf("LLong:  %5li\n", sizeof(long long));
  
  printf("UInt:   %5li\n", sizeof(unsigned int));
  printf("ULong:  %5li\n", sizeof(unsigned long));
  printf("UShort: %5li\n", sizeof(unsigned short));

  printf("2<<1: %d\n", 2<<1);
  return 1;
}
