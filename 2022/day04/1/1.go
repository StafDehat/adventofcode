package main

import (
  "fmt"
  "os"
  "log"
  "bufio"
  "strings"
  //"io"
  "strconv"
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

  sum := 0
  for _,line := range lines {
    zone1,zone2,chk := strings.Cut(line,",")
    if ! chk {
      continue
    }

    if isRedundant(zone1,zone2) {
      fmt.Println("Redundant: ",zone1,zone2)
      sum += 1
    }
  }
  fmt.Println("Fully redundant pairs: ", sum)
}


func isRedundant(zone1,zone2 string) bool {
  min1,max1 := getMinMax(zone1)
  min2,max2 := getMinMax(zone2)
  if min1 >= min2 {
    if max1 <= max2 {
      return true
    }
  }
  if min2 >= min1 {
    if max2 <= max1 {
      return true
    }
  }
  return false
}


func getMinMax(zone string) (int,int) {
  min,max,chk := strings.Cut(zone,"-")
  if ! chk {
    fmt.Printf("Failed to split '%s' on '-'\n",zone)
    return 0,0
  }
  imin, err := strconv.Atoi(min)
  if err != nil {
    panic(err)
  }
  imax, err := strconv.Atoi(max)
  if err != nil {
    panic(err)
  }
  return imin,imax
}

