package main

import (
  "fmt"
  "os"
  "log"
  "bufio"
  //"io"
//  "strconv"
//  "sort"
)

func check(e error) {
  if e != nil {
    panic(e)
  }
}

func main() {
  // CLI arg validation
  if len(os.Args) <= 1 {
    log.Fatal("Expected 1 argument, received ", len(os.Args)-1)
  }

  // Slurp file contents into an array, line-per-index
  var lines []string
  filePtr, err := os.OpenFile(os.Args[1], os.O_RDONLY, 0000)
  if err != nil {
    fmt.Println(err)
    log.Fatal("Unable to open file handle: ", os.Args[1])
  }
  fileScnr := bufio.NewScanner(filePtr)
  fileScnr.Split(bufio.ScanLines)
  for fileScnr.Scan() {
    lines = append(lines, fileScnr.Text())
  }
  fmt.Println("Num lines: ", len(lines))
  for _, line := range lines {
    fmt.Println(line)
  }

  // Close the file handle
  filePtr.Close()


  //
  /** Good god, finally down to actual logic **/
  //

  scoreSum := 0
  var goal rune // X,Y,Z
  var thatHand rune // A,B,C
  for _,line := range lines {
    fmt.Println("Evaluating: ",line)

    runic := []rune(line)
    goal = runic[2]
    thatHand = runic[0]
    scoreSum += strategize(goal,thatHand)
    fmt.Println("Score so far: ", scoreSum)
  }
  fmt.Println("Final score: ", scoreSum)
}


func strategize(goal rune,
                thatHand rune) int {
  thatToThis := 'X'-'A'
  var loss rune
  var win rune
  var tie rune

  fmt.Printf("Up against %c\n", thatHand)

  // Winning hand is always 1-more than opponent
  win = ( ( (thatHand-'A')+1 ) % 3 + 'X' )

  // Tie hand is always "same-as" opponent
  tie = thatHand + thatToThis

  // Losing hand is always 1-less than opponent
  // Or, on a 3-cycle, aka 2-more than opponent
  loss = ( ( (thatHand-'A')+2 ) % 3 + 'X' )


  if goal == 'X' {
    fmt.Println("Need to lose")
    return roundScore(loss, thatHand)
  }
  if goal == 'Y' {
    fmt.Println("Need to tie")
    return roundScore(tie, thatHand)
  }
  if goal == 'Z' {
    fmt.Println("Need to win")
    return roundScore(win, thatHand)
  }
  return 0
}


func roundScore(thisHand rune,
                thatHand rune) int {
  handScore := make(map[rune]int)
  handScore['A'] = 1 // 1 pts for playing rock
  handScore['B'] = 2 // 2 pts for playing paper
  handScore['C'] = 3 // 3 pts for playing scissors
  handScore['X'] = 1 // 1 pts for playing rock
  handScore['Y'] = 2 // 2 pts for playing paper
  handScore['Z'] = 3 // 3 pts for playing scissors

  fmt.Printf("Playing %c vs opponent's %c\n", thisHand, thatHand)

  // Tie
  if handScore[thisHand] == handScore[thatHand] {
    return 3 + handScore[thisHand]
  }

  if thisHand == 'X' { //rock
    if thatHand == 'C' { //scissors, I win
      return 6 + handScore[thisHand]
    }
    return 0 + handScore[thisHand]
  }
  if thisHand == 'Y' { //paper
    if thatHand == 'A' { //rock, I lose
      return 6 + handScore[thisHand]
    }
    return 0 + handScore[thisHand]
  }
  if thisHand == 'Z' { //scissors
    if thatHand == 'B' { //paper, I win
      return 6 + handScore[thisHand]
    }
    return 0 + handScore[thisHand]
  }
  fmt.Println("Issues")
  return -1
}

