module Scraper
  autoload :Article, 'scraper/article'
  autoload :Youtube, 'scraper/youtube'
  
  HANDLERS = [ :Youtube, :Article ]
end

def Scraper( args = {} )
  if handler = Scraper::HANDLERS.detect { |h| Scraper.const_get(h) =~ args }
    Scraper.const_get( handler ).new( args )
  else
    raise ArgumentError, "Scraper cannot handle content from #{args}"
  end
end

$LOAD_PATH.unshift( File.dirname(__FILE__) )