// Run with: scala -cp tagsoup-1.2.1.jar day3.scala
//
// Find:
//
// 1. For the sizer program, what would happen if you did not create a new actor
// for each link you wanted to follow? What would happen to the performance of
// the application?
//
// If you use a single actor for all links then you may as well not be using
// actors. The performance becomes the same as the sequential version.
//
// Do:
//
// 1. Take the sizer application and add a message to count the number of links
// on the page.

import scala.io._
import scala.actors._
import Actor._
import scala.xml.{Elem, XML, Node}
import scala.xml.factory.XMLLoader
import org.ccil.cowan.tagsoup.jaxp.SAXFactoryImpl
import java.net.URL

object PageLoader {
    def loadPageAsXml(url: String) = {
        val tagSoupXmlLoader = XML.withSAXParser(new SAXFactoryImpl().newSAXParser())
        tagSoupXmlLoader.load(new URL(url))
    }

    def getPageSize(url : String) = Source.fromURL(url).mkString.length

    def getNumberOfLinks(url : String) = {
        (loadPageAsXml(url) \\ "a").length
    }
}

val urls0 = List("http://amazon.com/",
    "https://twitter.com",
    "http://www.google.com",
    "http://www.stackoverflow.com",
    "http://nickknowlson.com")

val urls = List("http://nickknowlson.com")

def timeMethod(method: () => Unit) = {
    val start = System.nanoTime
    method()
    val end = System.nanoTime
    println("Method took " + (end - start)/1000000000.0 + " seconds.")
}

def getSequentially(method: (String => Long)) = {
    for(url <- urls) {
        println("Value for " + url + ": " + method(url))
    }
}

def getConcurrently(method: (String => Long)) = {
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

//println("Concurrent run of size:")
//timeMethod { () => getConcurrently(PageLoader.getPageSize) }

//println("Sequential run of size:")
//timeMethod { () => getSequentially(PageLoader.getPageSize) }

//println("Concurrent run of # of links:")
//timeMethod { () => getConcurrently(PageLoader.getNumberOfLinks) }

println("Sequential run of # of links:")
timeMethod { () => getSequentially(PageLoader.getNumberOfLinks) }

// Bonus: Make the sizer follow the links on a given page, and load them as
// well. For example, a sizer for "google.com" would compute the size for Google
// and all of the pages it links to.

object UrlHelper {
    def getAbsoluteUrl(linkUrl: String, currentUrl: String): String = {
        val absoluteUrl = "^http.*".r
        val relativeToSiteRoot = "/.*".r

        linkUrl match {
            case absoluteUrl() => 
                linkUrl
            case relativeToSiteRoot() => 
                combineUrlFragments(getBaseUrl(currentUrl), linkUrl)
            case _ => 
                combineUrlFragments(currentUrl, linkUrl)
        }
    }

    def combineUrlFragments(url1: String, url2: String): String = {
        return (url1 + url2).replace("(?<!:)//", "/")
    }

    def getBaseUrl(url: String): String = {
        val javaUrl = new URL(url)
        return javaUrl.getProtocol() + "://" + javaUrl.getAuthority() + "/"
    }
}

object PageLoaderR {

    def pageSize(page: Node) = page.mkString.length

    def numOfLinksOnPage(page: Node) = (page \\ "a").length

    def getPageInfoSeq(url: String, nodeInfoFn: Function[Node, Long], levelsDeep: Int) : Long = {
        val page = PageLoader.loadPageAsXml(url)
        val links = page \\ "a" \\ "@href"
        var result = nodeInfoFn(page)

        if (levelsDeep >= 0) {
            for(link <- links) {
                result += getPageInfoSeq(UrlHelper.getAbsoluteUrl(link.text, url), nodeInfoFn, levelsDeep - 1)
            }
        }

        result
    }

    def getPageSizeSeq(url: String) : Long = {
        getPageInfoSeq(url, pageSize, 1)
    }

    def getNumberOfLinksSeq(url: String) : Long = {
        getPageInfoSeq(url, numOfLinksOnPage, 1)
    }
}

//println("Sequential run of recursive size, 1 level deep:")
//timeMethod { () => getSequentially(PageLoaderR.getPageSizeSeq) }

println("Sequential run of recursive # of links, 1 level deep:")
timeMethod { () => getSequentially(PageLoaderR.getNumberOfLinksSeq) }
