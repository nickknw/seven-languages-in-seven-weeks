// Run this file with scala -Dfile.encoding=UTF-8 day1.scala
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

sealed abstract class Player
case object X extends Player
case object O extends Player
case object Blank extends Player {
    override def toString = " "
}

class TicTacToeBoard(board : Array[Array[Player]]) {
    val rowCount = board.length
    val columnCount = board(0).length
    val columnNameMapping = (0 until 5*columnCount).map(n => (TicTacToeBoard.numToAlpha(n), n)).toMap

    val numInARowNeeded : Int = {
        // numbers chosen rather arbitrarily by me. I looked at this: http://en.wikipedia.org/wiki/M,n,k-game
        // and tried to pick numbers that more or less made sense
        if(rowCount <= 3|| columnCount <= 3)
        {
            // tic tac toe or bizarre tiny variants
            scala.math.min(rowCount, columnCount)
        } else if(rowCount <= 5) {
            // connect 4, sort of
            4
        } else if(rowCount <= 14) {
            // gomoku
            5
        } else {
            // connect6. Seems like a good place to leave it
            6
        }
    }

    val winnerText = "Player %s won!"

    def whoWon : String = {
        val rows = { 
            for(r <- 0 until rowCount) 
                yield board(r).toArray 
        }
        val columns = { 
            for(c <- 0 until columnCount) yield (
                for(r <- (0 until rowCount)) 
                    yield board(r)(c)
            ).toArray 
        }
        val diagonalsLTR = {
            for(offset <- (1-columnCount) until columnCount) yield (
                for(row <- 0 until rowCount if offset + row < columnCount && offset + row > -1)
                    yield(board(row)(row+offset))
            ).toArray
        }
        val diagonalsRTL = {
            for(offset <- 0 until rowCount + rowCount - 1) yield (
                for(col <- 0 until columnCount if offset - col < rowCount && offset - col > -1)
                    yield(board(offset - col)(col))
            ).toArray
        }

        val checkForWinner = { array : Array[Player] =>
            TicTacToeBoard.nInARow(numInARowNeeded, array) match {
                case Some(player) => return winnerText.format(player)
                case None =>
            }
        }

        rows foreach checkForWinner
        columns foreach checkForWinner
        diagonalsLTR foreach checkForWinner
        diagonalsRTL foreach checkForWinner

        if(board.map(row => row.contains(Blank)).contains(true)) {
            return "No winner yet!"
        }

        return "It's a tie!"
    }

    override def toString : String = {
        var boardRepresentation = ""

        def p = { str : String => boardRepresentation = boardRepresentation.concat(str + "\n") }

        val rowCount = board.length
        val columnCount = board(0).length

        val topLine = (1 until columnCount).foldLeft("   ┌")((acc, c) => acc.concat("───┬")).concat("───┐")
        val middleLine = (0 until columnCount).foldLeft("   │")((acc, c) => acc.concat("───│"))
        val bottomLine = (1 until columnCount).foldLeft("   └")((acc, c) => acc.concat("───┴")).concat("───┘")

        p("")
        p((0 until columnCount).foldLeft("     ")((acc, n) => acc.concat("%-4s".format(TicTacToeBoard.numToAlpha(n)))))
        p(topLine)
        for(r <- 0 until rowCount) {
            var rowString = "%-3d".format(r).concat("│")
            for(c <- 0 until columnCount) {
                rowString = rowString.concat(" %s │".format(board(r)(c)))
            }
            p(rowString)
            if(r < rowCount-1) {
                p(middleLine)
            }
        }
        p(bottomLine)
        p("")

        return boardRepresentation
    }

    def validMove(row : Int, col : Int) : Boolean = {
        if(row >= rowCount || col >= columnCount) {
            return false
        }
        if(board(row)(col) != Blank) {
            return false
        }

        return true
    }

    def update(row : Int, col : Int, player : Player) = {
        board(row)(col) = player
    }

    def columnNumber(columnName : String) : Int = {
        return columnNameMapping(columnName)
    }
}

object TicTacToeBoard {

    def create(size : Int) : TicTacToeBoard = {
        create(size, size)
    }

    def create(rows : Int, cols : Int) : TicTacToeBoard = {
        return new TicTacToeBoard(Array.fill(rows, cols)(Blank))
    }

    def create(stringBoard : Array[String]) : TicTacToeBoard = {  
        return new TicTacToeBoard(stringBoard.map(row => getPlayersFromString(row)))
    }

    private def getPlayersFromString(row : String) : Array[Player] = {
        row.map(char => { if(char == 'X') X : Player else if(char == 'O') O : Player else Blank : Player } ).toArray
    }

    private def threeInARow(list : List[Player]) : Option[Player] = list match {
        case Nil => None
        case x :: y :: z :: tail if x == y && y == z && z != Blank => Some(z)
        case _ :: tail => threeInARow(tail)
    }

    private def nInARow(n : Int, array : Array[Player]) : Option[Player] = {
        for(i <- 0 until array.length - (n-1)) {
            var allTrue = true;
            for(j <- i+1 until i+n) {
                allTrue = allTrue && array(j-1) == array(j) && array(j) != Blank
            }
            if(allTrue) {
                return Some(array(i))
            }
        }

        return None
    }

    def numToAlpha(number : Int) : String = {
        var dividend = number + 1 // internally, treat 1 as A - just makes it easier
        var letters = ""
        var modulo = 0

        while(dividend > 0) {
            modulo = (dividend - 1) % 26
            letters = (65 + modulo).toChar + letters
            dividend = (dividend - modulo) / 26
        }

        return letters
    }

}

println(TicTacToeBoard.create(Array(
    "XOX",
    "XOO",
    "XXO"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "XOX",
    "OOO",
    "XXO"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "XOX",
    "XOO",
    " XO"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "XOX",
    "XOO",
    "OXO"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "XXO",
    "XOO",
    "OXX"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "XXO",
    "XXO",
    "OOX"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "OXOXO",
    "XXOXO",
    "OXXOX",
    "OOXXO",
    "OOXXO"
)).whoWon)

println(TicTacToeBoard.create(Array(
    "OXOXO",
    "XXOXO",
    "OXXOX",
    "OOOXO",
    "OOXXO"
)).whoWon)

// 2. Bonus Problem: Let two players play tic-tac-toe.

println("\nGame begin:")

object Game {
    val Position = """([A-Za-z]+)(\d+)""".r

    def main(args:Array[String]) {
        print("Enter board size: ")
        val size = Console.readInt
        var board = TicTacToeBoard.create(size)
        println("\n" + board.numInARowNeeded + " in a row to win (" + size + "x" + size + " board)")

        var player : Player = X
        while(board.whoWon == "No winner yet!") {
            println(board)
            println("Player %s's turn.".format(player))

            var validMove = false
            var col = -1
            var row = -1
            while(!validMove) {
                var input = ""
                try {
                    print("Enter square: (e.g. B2): ")
                    input = Console.readLine
                    val Position(columnName, rowNumber) = input
                    row = rowNumber.toInt
                    col = board.columnNumber(columnName)
                } catch {
                    case e => { println("Error reading input: Could not understand \"" + input + "\"") } 
                }

                validMove = board.validMove(row, col)
                if(!validMove) {
                    println("Can't move there, try again!\n")
                }
            }

            board.update(row, col, player)
            player = if(player == X) O else X
        }

        println(board)
        println(board.whoWon)
        println
    }

}

Game.main(null)
