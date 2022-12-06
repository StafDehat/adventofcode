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
  var thisHand rune // X,Y,Z
  var thatHand rune // A,B,C
  for _,line := range lines {
    fmt.Println("Evaluating: ",line)

    runic := []rune(line)
    thisHand = runic[2]
    thatHand = runic[0]
    scoreSum += roundScore(thisHand,thatHand)
    fmt.Println("Score so far: ", scoreSum)
  }
  fmt.Println("Final score: ", scoreSum)
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

