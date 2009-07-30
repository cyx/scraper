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
    VALID_HOST_NAME = /\A([a-z]+\.)?youtube\.com\z/
    VIDEO_ID_MATCHER = /([^&]+&)?v=([^&]+)/
    
    WIDTH             = 325
    HEIGHT            = 244
    ALLOW_FULL_SCREEN = true
    MIME_TYPE         = 'application/x-shockwave-flash'
    
    attr_reader :video_id
    
    def initialize( args = {} )
      uri = URI.parse(args[:url])
      
      unless valid_host_name?(uri.host)
        raise ArgumentError, "URL must be from youtube.com"
      end
      
      unless @video_id = extract_video_id_from_query_string( uri.query )
        raise ArgumentError, "URL must have a video ID in it"
      end
    end
    
    def html( args = {} )
      w, h = args[:width] || WIDTH, args[:height] || HEIGHT
      
      xml = Builder::XmlMarkup.new
      xml.object(:width => w, :height => h) do |object|
        object.param :name => 'movie', :value => movie_url
        object.param :name => 'allowFullScreen', :value => ALLOW_FULL_SCREEN
        object.param :name => 'allowscriptaccess', :value => 'always'
        object.embed :src => movie_url, 
          :type => MIME_TYPE, 
          :allowscriptaccess => 'always', 
          :allowfullscreen => ALLOW_FULL_SCREEN,
          :width => w,
          :height => h
      end
    end
    
    private
      def movie_url
        :"http://www.youtube.com/v/#{video_id}&hl=en&fs=1"
      end
      
      def valid_host_name?( host_name )
        host_name.match(VALID_HOST_NAME)
      end
      
      def extract_video_id_from_query_string( query_string )
        if matches = query_string.match(VIDEO_ID_MATCHER)
          matches[2]
        end
      end
  end
end