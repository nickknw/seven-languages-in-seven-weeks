// Find:
//
// 1. For the sizer program, what would happen if you did not create a new actor
// for each link you wanted to follow? What would happen to the performance of
// the application?

// If you use a single actor for each link you want to follow then you may as
// well not be using actors. The performance becomes the same as the sequential
// version.
//
// Do:
//
// 1. Take the sizer application and add a message to count the number of links
// on the page.

import scala.io._
import scala.actors._
import Actor._

object PageLoader {
    def getPageSize(url : String) = Source.fromURL(url).mkString.length

    // does not count malformed links
    def getNumberOfLinks(url : String) = {
        val pageSource = Source.fromURL(url).mkString
        
        0
    }
}

val urls = List("http://amazon.com/",
    "http://www.twitter.com",
    "http://www.google.com",
    "http://www.cnn.com")

def timeMethod(method: () => Unit) = {
    val start = System.nanoTime
    method()
    val end = System.nanoTime
    println("Method took " + (end - start)/1000000000.0 + " seconds.")
}

def getSequentially(method: (String => Int)) = {
    for(url <- urls) {
        println("Value for " + url + ": " + method(url))
    }
}

def getConcurrently(method: (String => Int)) = {
    val caller = self

    for(url <- urls) {
        actor { caller ! (url, method(url)) }
    }

    for(i <- 1 to urls.size) {
        receive {
            case (url, size) => println("Value for " + url + ": " + size)
        }
    }
}

println("Concurrent run of size:")
timeMethod { () => getConcurrently(PageLoader.getPageSize) }

println("Sequential run of size:")
timeMethod { () => getSequentially(PageLoader.getPageSize) }

println("Concurrent run of # of links:")
timeMethod { () => getConcurrently(PageLoader.getNumberOfLinks) }

println("Sequential run of # of links:")
timeMethod { () => getSequentially(PageLoader.getNumberOfLinks) }

// Bonus: Make the sizer follow the links on a given page, and load them as
// well. For example, a sizer for "google.com" would compute the size for Google
// and all of the pages it links to.
