// Find:
//
// 1. The Scala API
//
//      http://www.scala-lang.org/api/current/index.html
//
// 2. A comparison of Java and Scala
//
//    Quite a nice article, well-written, good detail level
//      http://www.ibm.com/developerworks/java/library/j-scala01228/index.html
//
//    Overiew/summary level comparison of Java, Scala, Groovy, Clojure
//      http://stackoverflow.com/questions/1314732/scala-vs-groovy-vs-clojure
//
//    This is funny and kind of revealing, even if the question leads to a bit of a biased picture.
//      http://stackoverflow.com/questions/2952732/samples-of-scala-and-java-code-where-scala-code-looks-simpler-has-fewer-lines
//
//    More low-level comparison
//      http://blogs.sun.com/sundararajan/entry/scala_for_java_programmers
//
//  
//      http://www.ibm.com/developerworks/java/library/j-scala01228/index.html
//
// 3. A discussion of val versus var
// 
//      http://stackoverflow.com/questions/1791408/what-is-the-difference-between-a-var-and-val-definition-in-scala
//

// Do:
//
// 1. Write a game that will take a tic-tac-toe board with X, O, and blank
//    characters and detect the winner or whether there is a tie or no winner yet.
//    Use classes where appropriate.
//
//  run with: 'scala -howtorun:script day1.scala'

object TicTac {
    def whoWon(board: Array[String]) :String = {
        
        for(i <- 0 to 2) {
            if(same(board(i)(0), board(i)(1), board(i)(2))) {
                return board(i)(0) + "s won!"
            }
        }

        for(i <- 0 to 2) {
            if(same(board(0)(i), board(1)(i), board(2)(i))) {
                return board(0)(i) + "s won!"
            }
        }

        // diagonals
        if(same(board(0)(0), board(1)(1), board(2)(2))) {
            return board(0)(0) + "s won!"
        }

        if(same(board(2)(0), board(1)(1), board(0)(2))) {
            return board(2)(0) + "s won!"
        }

        if(board.map(row => row.contains(' ')).contains(true)) {
            return "No winner yet!"
        }

        return "It's a tie!"
    }

    def same(a:Char, b:Char, c:Char) :Boolean = {
        return a == b && b == c
    }
}

println(TicTac.whoWon(Array(
    "XOX",
    "XOO",
    "XXO")))

println(TicTac.whoWon( Array(
    "XOX",
    "XOO",
    " XO")))

println(TicTac.whoWon( Array(
    "XOX",
    "XOO",
    "OXO")))

println(TicTac.whoWon( Array(
    "XXO",
    "XOO",
    "OXX")))

// 2. Bonus Problem: Let two players play tic-tac-toe.

object Game {
    def main(args :Array[String]) {
        board = Array("   ", "   ", "   ")
        while(TicTac.whoWon(board) == "No winner yet!")
    }
}
