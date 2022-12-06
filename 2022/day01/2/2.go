package main

import (
  "fmt"
  "os"
  "log"
  "bufio"
  //"io"
  "strconv"
  "sort"
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

/**
  // Read input file
  input, err := os.ReadFile(os.Args[1])
  if err != nil {
    log.Fatal("Unable to read from file: ", os.Args[1])
  }
  // Print input data
  fmt.Print(string(input))
**/

/**
  // Open a file handle, for line-by-line proc
  filePtr, err := os.OpenFile(os.Args[1], os.O_RDONLY, 0000)
  if err != nil {
    fmt.Println(err)
    log.Fatal("Unable to open file handle: ", os.Args[1])
  }
  fileScnr := bufio.NewScanner(filePtr)
  fileScnr.Split(bufio.ScanLines)
  for fileScnr.Scan() {
    fmt.Println(fileScnr.Text())
  }
  // Back to start of file
  filePtr.Seek(0, io.SeekStart)
**/

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


  /** Good god, finally down to actual logic **/
  var elfCals []int
  sum := 0
  for _,line := range lines {
    fmt.Println("Evaluating: ", line)
    if line == "" {
      elfCals = append(elfCals, sum)
      sum = 0
      continue
    }
    lineI, err := strconv.Atoi(line)
    check(err)
    sum = sum + lineI
  }
  elfCals = append(elfCals, sum)

  // Print each elf's caloric load
  for _,elf := range elfCals {
    fmt.Println(elf)
  }

  // Sort elves by caloric load, decreasing
  sort.Slice(elfCals, func(i, j int) bool {
    return elfCals[i] > elfCals[j]
  })

  fmt.Println( elfCals[0] + elfCals[1] + elfCals[2] )
}
