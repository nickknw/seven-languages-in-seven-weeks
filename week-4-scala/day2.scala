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

println("\n1.")

var stringList = List("here", "is", "a", "list", "of", "strings")
var totalStringSize = stringList.foldLeft(0) ( (total, string) => total + string.length )
println(totalStringSize)

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
        curseWords = newCurseWords;
    }

    def censorThyself (suspectPhrase : String) : String = {
       var wholesomePhrase = suspectPhrase

       for ((key, value) <- curseWords) {
            wholesomePhrase = wholesomePhrase.replaceAll(key, value)
       }

       return wholesomePhrase
    }
}

class FoulMouthedGoat {
    def speakFrankly() : String = {
        return "Shoot, my darn head is stuck in the dumb freaking door. Holy gosh Batman!"
    }
}

class PoliteFowl extends Censor

val delinquent = new FoulMouthedGoat()
val wordEnforcer = new PoliteFowl()

println("Spoken frankly: ")
println(delinquent.speakFrankly())

println("The polite fowl menaces with spikes of iron: ")
println(wordEnforcer.censorThyself(delinquent.speakFrankly()))

// 3. Load the curse words and alternatives from a file.
// well, it doesn't handle failure cases nicely, but it works

val source = scala.io.Source.fromFile("curseWords.txt")
val lines = source.getLines
source.close ()

var cursesFromFile = Map.empty[String, String]

for (line <- lines) {
    val curseWordPair = line.split('|')
    if(curseWordPair.length == 2) {
        cursesFromFile += ("(?i)" + curseWordPair(0).trim) -> curseWordPair(1).trim
    }
}

val stricterWordEnforcer = new PoliteFowl()
stricterWordEnforcer.setCurseWords(cursesFromFile)

println("The polite fowl menaces with spikes of onyx: ")
println(stricterWordEnforcer.censorThyself(delinquent.speakFrankly()))
