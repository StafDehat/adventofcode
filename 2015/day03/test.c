#include <stdio.h>

struct Var {
  int id;
};
struct Var var;

void test(int in, int *out, struct Var *obj) {
  printf("In: %i, Out: %i\n", in, *out);
  *out = 4;
  *obj = var;
  printf("In: %i, Out: %i\n", in, *out);
  return;
}

int main() {
  int x=2;
  int y=3;
  var.id = 99;
 
  struct Var second;
 
  printf("X: %i, Y: %i\n", x, y);
  test(x,&y,&second);
  printf("VarID: %i\n", var.id);
  printf("2ndID: %i\n", second.id);
  printf("X: %i, Y: %i\n", x, y);
}


