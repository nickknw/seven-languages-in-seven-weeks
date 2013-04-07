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
//    I'm not sure I've got my terminology straight here, but I will give it a go.
//    In Scala, a code block is a piece of syntax that creates closures.
//
// Do:
//
// 1. Use foldLeft to compute the total size of a list of strings.
//

println("\n1.")

var stringList = List("here", "is", "a", "list", "of", "strings")
var totalStringSize = stringList.foldLeft(0)((total, string) => total + string.length)
var totalStringSize2 = (0 /: stringList) {(total, string) => total + string.length }
println(totalStringSize)
println(totalStringSize2)

// 2. Write a Censor trait with a method that will replace the curse words Shoot
//    and Darn with Pucky and Beans alternatives. Use a map to store the curse
//    words and their alternatives.
import scala.collection.mutable.HashMap

println("\n2.")

trait Censor {

    var curseWords = Map(
        "(?i)Shoot" -> "Pucky",
        "(?i)Darn" -> "Beans"
    )

    def setCurseWords(newCurseWords : Map[String, String]) = {
        curseWords = newCurseWords
    }

    def censorThyselfVillain (suspectPhrase : String) : String = {
       var wholesomePhrase = suspectPhrase

       for ((key, value) <- curseWords) {
            wholesomePhrase = wholesomePhrase.replaceAll(key, value)
       }

       return wholesomePhrase
    }

    def censorThyselfVillain2 (suspectPhrase : String) : String = {
        curseWords.foldLeft(suspectPhrase)((acc, pair) => acc.replaceAll(pair._1, pair._2))
    }
}

class PolitenessEnforcer extends Censor

var enforcer = new PolitenessEnforcer()

val rudePhrase = "Shoot, my darn head is stuck in the dumb freaking door. Holy gosh Batman!"

println("Spoken frankly: ")
println(rudePhrase)

println("The enforcer menaces with spikes of brass: ")
println(enforcer.censorThyselfVillain2(rudePhrase))

// 3. Load the curse words and alternatives from a file.

import scala.io.Source._

println("\n3.")

var cursesFromFile = Map.empty[String, String]

fromFile("curseWords.txt").getLines.foreach { line =>
    val curseWordPair = line.split('|')
    if(curseWordPair.length == 2) {
        cursesFromFile += ("(?i)" + curseWordPair(0).trim) -> curseWordPair(1).trim
    }
}

val stricterEnforcer = new PolitenessEnforcer()
stricterEnforcer.setCurseWords(cursesFromFile)

println("The enforcer menaces with spikes of onyx: ")
println(stricterEnforcer.censorThyselfVillain2(rudePhrase))
