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
require 'builder'

module Scraper
  class Youtube
    @@config = {
      :valid_host_name      => /\A([a-z]+\.)?youtube\.com\z/,
      :title_selector       => 'h1',
      :description_selector => '.expand-content .description span',
      :video_id_matcher     => /([^&]+&)?v=([^&]+)/,
      :width                => 325,
      :height               => 244,
      :allow_full_screen    => true,
      :mime_type            => 'application/x-shockwave-flash'
    }
    
    extend  Modules::Video::HostNameMatching
    include Modules::Video::Common
    include Modules::Web::MetaData
    
    def initialize( args = {} )
      @uri = URI.parse(args[:url])
      
      unless self.class.valid_host_name?(@uri.host)
        raise ArgumentError, "URL must be from youtube.com"
      end
      
      unless @video_id = extract_video_id_from_query_string( @uri.query )
        raise ArgumentError, "URL must have a video ID in it"
      end
    end
    
    def html( args = {} )
      w, h = args[:width] || config[:width], args[:height] || config[:height]
      
      xml = Builder::XmlMarkup.new
      xml.object(:width => w, :height => h) do |object|
        object.param :name => 'movie', :value => video_url
        object.param(
          :name => 'allowFullScreen', :value => config[:allow_full_screen]
        )
        object.param :name => 'allowscriptaccess', :value => 'always'
        object.embed :src => video_url, 
          :type => config[:mime_type], 
          :allowscriptaccess => 'always', 
          :allowfullscreen => config[:allow_full_screen],
          :width => w,
          :height => h
      end
    end
    
    def thumbnail
      "http://i.ytimg.com/vi/#{video_id}/2.jpg"
    end
    
    private
      def video_url
        :"http://www.youtube.com/v/#{video_id}&hl=en&fs=1"
      end
      
      def extract_video_id_from_query_string( query_string )
        if matches = query_string.match(config[:video_id_matcher])
          matches[2]
        end
      end
  end
end