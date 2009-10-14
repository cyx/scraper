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

require 'nokogiri'
require 'open-uri'

module Scraper
  class Slideshare
    @@config = {
      :valid_host_name      => /\A([a-z]+\.)?slideshare\.net\z/,
      :slide_id_matcher     => /\A\/[a-z0-9\.\-\_]+\/([a-z0-9\-\.\_]+)\z/i,
      :title_selector       => 'title',
      :description_selector => "#description",
      :thumbnail_selector   => "link[rel=image_src]",
      :width                => 400,
      :height               => 300,
      :slide_url_matcher    => 'link[rel="media:presentation"]'
    }
    
    attr_reader :slide_id
    extend  Modules::Video::HostNameMatching
    include Modules::Video::Common
    include Modules::Web::MetaData
    
    def initialize( args = {} )
      @uri = URI.parse(args[:url])
      
      unless self.class.valid_host_name?(@uri.host)
        raise ArgumentError, "URL must be from slideshare.net"
      end
      
      unless @slide_id = extract_slide_id_from_path( @uri.path )
        raise ArgumentError, "URL must have a slide ID in it"
      end
    end
    
    def html( args = {} )
      w, h = args[:width] || config[:width], args[:height] || config[:height]
      
      xml = Builder::XmlMarkup.new
      xml.object :width => w, :height => h do |object|
        object.param(
          :name => 'allowfullscreen', :value => config[:allow_full_screen]
        )
        object.param :name => 'allowscriptaccess', :value => 'always'
        object.param :name => 'movie', :value => slide_url
        object.embed(
          :src => slide_url, 
          :type => config[:mime_type],
          :allowfullscreen => config[:allow_full_screen],
          :allowscriptaccess => 'always',
          :width => w,
          :height => h
        )
      end
    end
    
    def thumbnail
      return @thumbnail if @thumbnail
      
      if elem = doc.search(config[:thumbnail_selector]).first
        @thumbnail = elem.attribute('src') || elem.attribute('href')
        @thumbnail = @thumbnail.to_s
      end
    end
    
    private
      def slide_url
        return @slide_url if @slide_url
        
        if elem = doc.search(config[:slide_url_matcher]).first
          @slide_url = elem.attribute('href').to_s
        end
      end
      
      def extract_slide_id_from_path( path )
        if matches = path.match(config[:slide_id_matcher])
          return matches[1]
        end
      end
  end
end