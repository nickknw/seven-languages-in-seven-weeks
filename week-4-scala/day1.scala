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
//    Some more
//      http://www.artima.com/scalazine/articles/scalable-language.html
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
//
//  I'm not especially happy with my solution here. It feels kind of ugly, but I
//  haven't been able to place exactly what would make it better without just
//  being overkill.

println("Testing win detection: \n")

object TicTac {

    val winner = "Player %s won!"

    def whoWon(board: Array[Array[Char]]) :String = {
        
        for(i <- 0 to 2) {
            if(same(board(i)(0), board(i)(1), board(i)(2))) {
                return winner.format(board(i)(0))
            }
        }

        for(i <- 0 to 2) {
            if(same(board(0)(i), board(1)(i), board(2)(i))) {
                return winner.format(board(0)(i))
            }
        }

        // diagonals
        if(same(board(0)(0), board(1)(1), board(2)(2))) {
            return winner.format(board(0)(0))
        }

        if(same(board(2)(0), board(1)(1), board(0)(2))) {
            return winner.format(board(2)(0))
        }

        if(board.map(row => row.contains(' ')).contains(true)) {
            return "No winner yet!"
        }

        return "It's a tie!"
    }

    def same(a:Char, b:Char, c:Char) :Boolean = {
        return a == b && b == c && a != ' '
    }
}

println(TicTac.whoWon(Array(
    "XOX".toCharArray(),
    "XOO".toCharArray(),
    "XXO".toCharArray())))

println(TicTac.whoWon( Array(
    "XOX".toCharArray(),
    "XOO".toCharArray(),
    " XO".toCharArray())))

println(TicTac.whoWon( Array(
    "XOX".toCharArray(),
    "XOO".toCharArray(),
    "OXO".toCharArray())))

println(TicTac.whoWon( Array(
    "XXO".toCharArray(),
    "XOO".toCharArray(),
    "OXX".toCharArray())))

// 2. Bonus Problem: Let two players play tic-tac-toe.

println("\nGame begin:")

object Game {
    def main(args:Array[String]) {
        var board = Array("   ".toCharArray(), "   ".toCharArray(), "   ".toCharArray())
        var player = 'X'
        while(TicTac.whoWon(board) == "No winner yet!") {
            printBoard(board)
            println("Player %s's turn.".format(player))

            print("Enter row: ")
            val row = Console.readInt

            print("Enter column: ")
            val col = Console.readInt

            if(valid(board, row, col)) {
                board(row)(col) = player

                player = if(player == 'X') 'O' else 'X'
            }
            else {
                println("\nCan't move there, try again!")
            }
        }

        println(TicTac.whoWon(board))
        printBoard(board)
        println("")
    }

    def printBoard(board:Array[Array[Char]]) = {
        println("\n   0   1   2")
        println("0  %s | %s | %s".format(board(0)(0), board(0)(1), board(0)(2)))
        println("  ---+---+---")
        println("0  %s | %s | %s".format(board(1)(0), board(1)(1), board(1)(2)))
        println("  ---+---+---")
        println("0  %s | %s | %s".format(board(2)(0), board(2)(1), board(2)(2)))
        println("")
    }

    def valid(board:Array[Array[Char]], row:Int, col:Int):Boolean = {
        if(row > 2 || row < 0 || col > 3 || col < 0) {
            return false
        }

        if(board(row)(col) != ' ') {
            return false
        }

        return true
    }
}

Game.main(null)
