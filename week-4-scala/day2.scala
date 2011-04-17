// Find:
//
// 1. A discussion on how to use Scala files
//
//    I'm not entirely clear what this question is looking for. Maybe something
//    like this?
//      http://www.scala-lang.org/node/166
//
// 2. What makes a closure different from a code block
//
//    I'm not sure what this question is looking for either. I guess that a code
//    block is a closure, but a closure is not necessarily a code block. A code
//    block is just a way to create a closure.
//
//    Hopefully I've got that right.
//
// Do:
//
// 1. Use foldLeft to compute the total size of a list of strings.
//

var stringList = List("here", "is", "a", "list", "of", "strings")
var totalStringSize = stringList.foldLeft(0) ( (total, string) => total + string.length )
println(totalStringSize)

// 2. Write a Censor trait with a method that will replace the curse words Shoot
//    and Darn with Pucky and Beans alternatives. Use a map to store the curse
//    words and their alternatives.



// 3. Load the curse words and alternatives from a file.
