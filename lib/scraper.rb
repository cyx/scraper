require 'rubygems'
require 'activesupport'

module Scraper
  autoload :Article, 'scraper/article'
  autoload :Youtube, 'scraper/youtube'
  autoload :Vimeo,   'scraper/vimeo'
  autoload :Modules, 'scraper/modules'

  HANDLERS = [ :Youtube, :Vimeo, :Article ]
end

def Scraper( args = {} )
  Scraper::HANDLERS.each do |handler| 
    if object = (Scraper.const_get(handler) =~ args)
      return object
    end
  end
  raise ArgumentError, "Scraper cannot handle content from #{args}"
end

$LOAD_PATH.unshift( File.dirname(__FILE__) )