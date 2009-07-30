Scraper Library
===============

Objectives
----------
To provide a generic ruby gem which easily facilitates the scraping of various sites. The following lists all the types of webpages that will be targeted by this libary:

1. Youtube.com
2. Wikipedia.org
3. Vimeo.com
4. Flickr.com
5. Any blog, article, news, etc.

Extracting information from Youtube or vimeo
--------------------------------------------

For youtube and vimeo, the following sample code best describes what you can expect:
    
    @scraper = Scraper( :url => "http://www.youtube.com/watch?v=MDhMBxAHGYE" )
    # => #<Scraper::Youtube>
 
    @scraper.thumbnail
    # => "http://i.ytimg.com/vi/MDhMBxAHGYE/2.jpg"   

    @scraper.title
    # => "Rick Roll [Geek Edition]"

    @scraper.html
    # => "<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/MDhMBxAHGYE&hl=en&fs=1&"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/MDhMBxAHGYE&hl=en&fs=1&" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>"

Extracting content from blogs, news articles, and beyond
--------------------------------------------------------

When a url from a webpage that isn't part of the special group (movies, photos, and other multimedia), the content portion of the page is extracted from that url using a relevancy scoring algorithm.

Example:

    @scraper = Scraper( :url => "http://www.alistapart.com/articles/unwebbable")
    # => #<Scraper::Article>

    @scraper.title 
    # => "A List Apart: Articles: Unwebbable"

    @scraper.text
    # => "It's time we came to grips with the fact that not every "document" can be a web page." ...

