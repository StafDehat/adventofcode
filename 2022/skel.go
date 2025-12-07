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


}
