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

  var items []rune
  for index := 0; index < len(lines); index+=3 {
    items = append(items,
                   getBadge( lines[index],
                             lines[index+1],
                             lines[index+2]  ))
  }

  fmt.Print("Bades:",items,"(")
  for _,item := range items {
    fmt.Printf("%c,", item)
  }
  fmt.Println(")")

  sum := 0
  for _,item := range items {
    sum += getPriority(item)
  }
  fmt.Println("Priority sum: ", sum)
}

/**
func findItem(contents string) rune {
  pocket1,pocket2 := getPockets(contents)
  fmt.Println("Pocket1: ", pocket1)
  fmt.Println("Pocket2: ", pocket2)
  return getCommonChar(pocket1,pocket2)
}

func getPockets(contents string) (string,string) {
  size := len(contents)
  half := size / 2
  return contents[0:half],contents[half:size]
}

func getCommonChar(pocket1 string, pocket2 string) rune {
  // Ugh, if Go had sets, this would just be intersection(pocket1,pocket2)
  counter := make(map[rune]int)
  for _,char := range pocket1 {
    counter[char] += 1
  }
  for _,char := range pocket2 {
    if counter[char] > 0 {
      return char
    }
  }
  return 0
}
**/

func getPriority(char rune) int {
  // Shift ASCII values to 1-26,27-52
  if char >= 'a' {
    return int(char-96)
  }
  return int(char-38)
}

func getBadge(pack1 string,
              pack2 string,
              pack3 string) rune {
  fmt.Println()
  fmt.Println("Pack1: ", pack1)
  fmt.Println("Pack2: ", pack2)
  fmt.Println("Pack3: ", pack3)
  counter := make(map[rune]int)
  for _,char := range removeDuplicateValues(pack1) {
    counter[char] += 1
  }
  for _,char := range removeDuplicateValues(pack2) {
    counter[char] += 1
  }

  for _,char := range pack3 {
    if counter[char] > 1 {
      return char
    }
  }
  return 0
}

// Stolen from https://www.geeksforgeeks.org/how-to-remove-duplicate-values-from-slice-in-golang/
func removeDuplicateValues(str string) string {
    keys := make(map[rune]bool)
    list := []rune{}
    runeSlice := []rune(str)
    for _, entry := range runeSlice {
        if _, value := keys[entry]; !value {
            keys[entry] = true
            list = append(list, entry)
        }
    }
    return string(list)
}
