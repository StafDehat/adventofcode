#include <stdio.h>
#include <openssl/md5.h>
#include <stdlib.h>
#include <string.h>


char *str2md5(const char *str, int length) {
  int n;
  MD5_CTX c;
  unsigned char digest[16];
  char *out = (char*)malloc(33);

  MD5_Init(&c);

  while (length > 0) {
    if (length > 512) {
      MD5_Update(&c, str, 512);
    } else {
      MD5_Update(&c, str, length);
    }
    length -= 512;
    str += 512;
  }

  MD5_Final(digest, &c);

  for (n = 0; n < 16; ++n) {
    snprintf(&(out[n*2]), 16*2, "%02x", (unsigned int)digest[n]);
  }

  return out;
}

int startsWith(const char *a, const char *b)
{
   if (strncmp(a, b, strlen(b)) == 0)
     return 1;
   return 0;
}

int main(int argc, char **argv) {
  char* key="ckczppom";
  int count=0;

  char testStr[50];
  char numStr[50];
  char* hash;
  while (1) {
    if ( count % 10000 == 0 )
      printf("Testing %i\n", count);

    sprintf(numStr, "%i", count); 
    strcpy(testStr, key);
    strcat(testStr, numStr);

    //printf("Testing: %s\n", testStr);
    hash = str2md5(testStr, strlen(testStr));

    if ( startsWith(hash, "00000") )
      break;
    count++;
  }

  printf("%s\n", hash);
  printf("%i\n", count);
  return 0;
}

