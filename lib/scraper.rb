module Scraper
  autoload :Article, 'scraper/article'
  autoload :Youtube, 'scraper/youtube'
end

$LOAD_PATH.unshift( File.dirname(__FILE__) )