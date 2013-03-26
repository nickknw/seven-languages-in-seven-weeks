// Run this file with 'scala -Dfile.encoding=UTF-8 day1.scala'
//
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

// Do:
//
// 1. Write a game that will take a tic-tac-toe board with X, O, and blank
//    characters and detect the winner or whether there is a tie or no winner yet.
//    Use classes where appropriate.
//

sealed abstract class Player
case object X extends Player
case object O extends Player
case object Blank extends Player {
    override def toString = " "
}

object GameResult extends Enumeration {
    type GameResult = Value
    val X, O, Tie, None = Value

    def displayGameResult(gameResult: GameResult) : String = {
        val winnerText = "Player %s won!"

        gameResult match {
            case GameResult.None => "No winner yet!"
            case GameResult.Tie => "It's a tie!"
            case player => winnerText.format(player)
        }
    }
}

class TicTacToeBoard(board : Array[Array[Player]]) {

    def this(stringBoard: Array[String]) = this(stringBoard.map(row => TicTacToeBoard.getPlayersFromString(row)))
    def this(rows: Int, cols: Int) = this(Array.fill(rows, cols)(Blank) : Array[Array[Player]])
    def this(size: Int) = this(size, size)

    val rowCount = board.length
    val columnCount = if (board.isEmpty) 0 else board(0).length
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

    def determineWinner : GameResult.Value = {
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

        val winnerText = "Player %s won!"
        val checkForWinner = { array : Array[Player] =>
            TicTacToeBoard.nInARow(numInARowNeeded, array) match {
                case Some(player) => 
                    // non-local return!
                    return if (player == X) GameResult.X 
                    else if (player == O) GameResult.O
                    else GameResult.None
                case None =>
            }
        }

        rows foreach checkForWinner
        columns foreach checkForWinner
        diagonalsLTR foreach checkForWinner
        diagonalsRTL foreach checkForWinner

        if(board.map(row => row.contains(Blank)).contains(true)) {
            return GameResult.None
        }

        return GameResult.Tie
    }

    override def toString : String = {
        var boardRepresentation = ""

        def p = { str : String => boardRepresentation = boardRepresentation.concat(str + "\n") }

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
        if(row >= rowCount || row < 0 || col >= columnCount || col < 0 || board(row)(col) != Blank ) {
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

    def getPlayersFromString(row : String) : Array[Player] = {
        row.map(char => { if(char == 'X') X : Player else if(char == 'O') O : Player else Blank : Player } ).toArray
    }

    def threeInARow(list : List[Player]) : Option[Player] = list match {
        case Nil => None
        case x :: y :: z :: tail if x == y && y == z && z != Blank => Some(z)
        case _ :: tail => threeInARow(tail)
    }

    def nInARow(n : Int, array : Array[Player]) : Option[Player] = {
        for(i <- 0 until array.length - (n-1)) {
            var allTrue = true;
            for(j <- i+1 until i+n) {
                allTrue = allTrue && (array(j-1) == array(j)) && (array(j) != Blank)
            }
            if(allTrue) {
                return Some(array(i))
            }
        }

        return None
    }

}

// Testing win detection

assert(new TicTacToeBoard(Array(
    "XOX",
    "XOO",
    "XXO"
)).determineWinner == GameResult.X)

assert(new TicTacToeBoard(Array(
    "XOX",
    "OOO",
    "XXO"
)).determineWinner == GameResult.O)

assert(new TicTacToeBoard(Array(
    "XOX",
    "XOO",
    " XO"
)).determineWinner == GameResult.None)

assert(new TicTacToeBoard(Array(
    "XOX",
    "XOO",
    "OXO"
)).determineWinner == GameResult.Tie)

assert(new TicTacToeBoard(Array(
    "XXO",
    "XOO",
    "OXX"
)).determineWinner == GameResult.O)

assert(new TicTacToeBoard(Array(
    "XXO",
    "XXO",
    "OOX"
)).determineWinner == GameResult.X)

assert(new TicTacToeBoard(Array(
    "OXOXO",
    "XXOXO",
    "OXXOX",
    "OOXXO",
    "OOXXO"
)).determineWinner == GameResult.X)

assert(new TicTacToeBoard(Array(
    "OXOXO",
    "XXOXO",
    "OXXOX",
    "OOOXO",
    "OOXXO"
)).determineWinner == GameResult.O)

// 2. Bonus Problem: Let two players play tic-tac-toe.

object Game {
    val Position = """([A-Za-z]+)\s*(\d+)""".r

    def main(args:Array[String]) {
        print("Enter board size: ")
        val size = Console.readInt
        var board = new TicTacToeBoard(size)
        println("\n" + board.numInARowNeeded + " in a row to win (" + size + "x" + size + " board)")

        var player : Player = X
        while(board.determineWinner == GameResult.None) {
            println(board)
            println("Player %s's turn.".format(player))

            var validMove = false
            var col = -1
            var row = -1
            while(!validMove) {
                var input = ""
                try {
                    print("Enter square: (e.g. A0): ")
                    input = Console.readLine
                    val Position(columnName, rowNumber) = input
                    row = rowNumber.toInt
                    col = board.columnNumber(columnName.toUpperCase)
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
        println(GameResult.displayGameResult(board.determineWinner))
        println
    }

}

Game.main(null) // run it!
