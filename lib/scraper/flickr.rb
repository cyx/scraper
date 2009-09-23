# Copyright (c) 2009 [Cyril David]
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'uri'

module Scraper
  class Flickr
    @@config = {
      :valid_host_name      => /\A([a-z]+\.)?flickr\.com\z/,
      :photo_path_matcher   => /\/photos\/[a-zA-Z0-9\@]+(\/([0-9]+))?\/?/,
      :title_selector       => 'h1',
      :description_selector => '.photoDescription',
    }
    
    include Modules::Web::MetaData
    
    def self.=~( args )
      return false unless args[:url]
      
      uri = URI.parse(args[:url])
      
      if valid_host?(uri.host) and valid_path?(uri.path)
        return new(args)
      end
    end
    
    def self.valid_host?( host_name )
      host_name.match(config[:valid_host_name])
    end
    
    def self.valid_path?( path )
      path.match(config[:photo_path_matcher])
    end
    
    def initialize( args = {} )
      @uri = URI.parse(args[:url])
    end
    
    def photostream?
      matches = @uri.path.match(config[:photo_path_matcher])
      matches[1].nil?
    end
    
    def thumbnail
      if photostream?
        doc.search('img.pc_img').first.attribute('src').to_s
      else
        doc.search('link[rel=image_src]').first.attribute('href').to_s
      end
    end
    
    def img
      unless photostream?
        doc.search('.photoImgDiv img').first.attribute('src').to_s
      end
    end
  end
end