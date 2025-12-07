#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/**
The neighbourhood will be a cartesian plane, but
since C can't do negative array indices, I'll implement
that plane with 4x 2d arrays - one per quadrant:
 1 | 2
---+---
 3 | 4
Notes: 0,0 is in quadrant2.  Malloc as necessary
**/
struct Quadrant {
  int id;
  int** coords;
  int limitX;
  int limitY;
};
struct Quadrant quadrant1;
struct Quadrant quadrant2;
struct Quadrant quadrant3;
struct Quadrant quadrant4;

int sledX;
int sledY;

// Initialize quadrant
void initQuadrant(struct Quadrant *q, int id) {
  q->id = id;
  q->limitX = 1;
  q->limitY = 1;
  q->coords = malloc(q->limitX * sizeof(int*));
  for (int i=0; i<q->limitX; i++) {
    q->coords[i] = malloc(q->limitY * sizeof(int));
    memset(q->coords[i], 0, q->limitY * sizeof(int));
  }
}
// Double X & Y range of given quadrant
void growQuadrant(struct Quadrant *q) {
  int newX = q->limitX * 2;
  int newY = q->limitY * 2;

  printf("Old limits: %ix%i\n", q->limitX, q->limitY);

  //  Alloc new memory
  q->coords = realloc(q->coords, newX*sizeof(int*));
  printf("Array of pointers grown to %ix%i\n", newX, newY);
  for (int i=q->limitX; i<newX; i++) {
    printf("Size of 1d: %i\n", sizeof(q->coords[i])/sizeof(int));
    q->coords[i] = realloc(q->coords[i], newY*sizeof(int));
  }

  // Initialize newly-alloc'd memory to 0
  for (int i=0; i<q->limitY; i++) {
    memset(&q->coords[i][q->limitX], 0, q->limitX*sizeof(int));
  }
  for (int i=q->limitY; i<newY; i++) {
    memset(&q->coords[i][0], 0, newX*sizeof(int));
  }

  q->limitX = newX;
  q->limitY = newY;
}

void printQuadrant(struct Quadrant q) {
  for (int y=0; y<q.limitX; y++) {
    for (int x=0; x<q.limitY; x++) {
      printf("%i ", q.coords[x][y]);
    }
    printf("\n");
  }
}

// Identify the quadrant containing current sledCoords,
// and abs(x|y) coords.
void decodeCoords(struct Quadrant **q, int *x, int *y) {
  if ( *x < 0 ) { 
    if ( *y < 0 ) {
      *q = &quadrant3;
      *x = -1 - *x;
      *y = -1 - *y;
    } else { // *y >= 0
      *q = &quadrant1;
      *x = -1 - *x;
      //*y = *y;
    }
  } else { // *x >= 0
    if ( *y < 0 ) {
      *q = &quadrant4;
      //*x = *x; 
      *y = -1 - *y;
    } else { // *y >= 0
      *q = &quadrant2;
      //*x = *x;
      //*y = *y;
    }
  }
}

// Set coordinates x,y to given value
void setPos(int x, int y, int val) {
  struct Quadrant* q;
  int xPos=x;
  int yPos=y;
  decodeCoords(&q, &xPos, &yPos);
  printf("(%i,%i) decoded to Q%i, (%i,%i)\n", x,y,q->id,xPos,yPos);
  while ( xPos >= q->limitX || yPos >= q->limitY ) {
    printf("Out of space - growing Quadrant %i\n", q->id);
    growQuadrant(q);
  }
  q->coords[xPos][yPos] = val;
  return;
}
// Return value at coordinates x,y
int getPos(int x, int y) {
  struct Quadrant* q;
  int xPos = x;
  int yPos = y;
  decodeCoords(&q, &xPos, &yPos);
  if ( xPos >= q->limitX || yPos >= q->limitY ) {
    return 0;
  }
  return q->coords[xPos][yPos];
}

// Deliver a present to house at (x,y)
void deliver(int x, int y) {
  setPos(x,y,getPos(x,y)+1);
  //printf("New value at %i, %i: %i\n", x, y, getPos(x,y));
  return;
}

int countQuadrantHouses(struct Quadrant q) {
  int count=0;
  printf("Counting houses in Q%i\n", q.id);
  for (int i=0; i<q.limitX; i++) {
    for (int j=0; j<q.limitY; j++) {
      if (q.coords[i][j]) {
        count++;
      }
    }
  }
  return count;
}

int countHouses() {
  return countQuadrantHouses(quadrant1) +
         countQuadrantHouses(quadrant2) +
         countQuadrantHouses(quadrant3) +
         countQuadrantHouses(quadrant4);
}


// 
int meat(FILE *fp) {
  char token;
  int floor = 0;

  initQuadrant(&quadrant1, 1);
  initQuadrant(&quadrant2, 2);
  initQuadrant(&quadrant3, 3);
  initQuadrant(&quadrant4, 4);

  // Sled starts at (0,0).
  sledX=0;
  sledY=0;
  // Deliver first present.
  deliver(sledX, sledY);

  // Read instruction, travel, and deliver a present
  while ( token=fgetc((FILE*)fp) ) {
    if ( token == '^' ) { sledY+=1; }
    else if ( token == 'v' ) { sledY-=1; }
    else if ( token == '<' ) { sledX-=1; }
    else if ( token == '>' ) { sledX+=1; }
    else { break; }
    printf("Delivering to: %i, %i\n", sledX, sledY);
    deliver(sledX, sledY);
  }

  //printQuadrant(quadrant4);
  printf("Deliveries in Q1: %i\n", countQuadrantHouses(quadrant1));
  printf("Deliveries in Q2: %i\n", countQuadrantHouses(quadrant2));
  printf("Deliveries in Q3: %i\n", countQuadrantHouses(quadrant3));
  printf("Deliveries in Q4: %i\n", countQuadrantHouses(quadrant4));
  printf("Total houses visited: %i\n", countHouses() );
}

int main( int argc, char *argv[] ) {
  char * filename = argv[1];
  FILE *fp;
  fp = fopen(filename, "r");
  
  meat(fp);
}
