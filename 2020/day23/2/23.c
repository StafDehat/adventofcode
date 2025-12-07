#include <stdio.h>

int cupInput[9]={9,5,2,3,1,6,4,8,7};

int numCups=1000000;
int next[1000001]; // Cups are 1-based, indices are 0-based.
//int numCups=20;
//int next[21];

//int numMoves=100;
int numMoves=10000000;

int printCups() {
  int startCup=1;
  int thisCup=next[startCup];
  printf("%i ", startCup);
  for ( int x=0; x<sizeof(next); x++ ) {
    printf("%i ", thisCup);
    thisCup=next[thisCup];
    if ( thisCup == startCup ) {
      break;
    }
  }
}

int main() {
  // Just print the list we got as input:
  printf("Cup Input: ");
  for (int x=0; x<sizeof(cupInput)/sizeof(int); x++) {
    printf("%i ", cupInput[x]);
  }
  printf("\n");

  // Stick the given cups into next[]
  int thisCup;
  int nextCup;
  for (int x=0; x<sizeof(cupInput)/sizeof(int)-1; x++) {
    thisCup=cupInput[x];
    nextCup=cupInput[x+1];
    printf("Inserting next[%i] = %i\n", thisCup, nextCup);
    next[thisCup]=nextCup;
  }

  // The last cup we inserted is pointing at a nonexistent cup - fix that
  printf("Inserting edge case, next[%i]=%i\n",
           (int)(cupInput[sizeof(cupInput)/sizeof(int)-1]),
           (int)(sizeof(cupInput)/sizeof(int)+1) );
  next[cupInput[sizeof(cupInput)/sizeof(int)-1]]=sizeof(cupInput)/sizeof(int)+1;

  // Append additional, implicit cups
  printf("Appending %i more cups.\n", (int)(numCups-sizeof(cupInput)/sizeof(int)));
  for (int x=sizeof(cupInput)/sizeof(int)+1; x<numCups; x++) {
    //printf("Inserting next[%i] = %i\n", x, x+1);
    next[x]=x+1;
  }
  // Last one in the list is broken again - loop it back to the first
  printf("Lastly, next[%i]=%i\n", numCups, cupInput[0]);
  next[numCups]=cupInput[0];

  int pickup1;
  int pickup2;
  int pickup3;
  int postPickup;
  int dest;
  int postDest;
  int moveCount=0;
  int current=cupInput[0];
  while ( moveCount < numMoves ) {
    // Set vars to remember the important cups
    pickup1=next[current];
    pickup2=next[pickup1];
    pickup3=next[pickup2];
    postPickup=next[pickup3];

    // Figure out the destination cup
    dest=current-1; //Ideally...
    while (1) {
      if ( dest <= 0 ) {
        dest=numCups;
      }
      // As long as our ideal cup isn't picked up, we're good:
      if ( dest != pickup1 &&
           dest != pickup2 &&
           dest != pickup3 ) {
        break;
      }
      dest--;
    }
    postDest=next[dest];

    //printf("Move %i\n", moveCount);
    //printCups();
    //printf("\n");
    //printf("Current: %i\n", current);
    //printf("Pickup: %i %i %i\n", pickup1, pickup2, pickup3);
    //printf("Destination: %i\n\n", dest);

    // Remove picked-up cups from sequence
    next[current]=postPickup;

    // Insert picked-up cups between dest & postDest
    next[dest]=pickup1;
    next[pickup3]=postDest;

    // Update the 'current' cup
    current=postPickup;

    moveCount++;
    if ( moveCount % 1000000 == 0 ) {
      printf("Completed %i moves\n", moveCount);
    }
  }

  // Print the 2 cups following cup1
  int first=next[1];
  int second=next[first];
  printf("Two cups following Cup1: %i %i\n", first, second);

  return 0;
}


