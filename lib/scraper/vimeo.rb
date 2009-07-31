require 'uri'
require 'open-uri'
require 'nokogiri'
require 'builder'

module Scraper
  class Vimeo
    @@config = {
      :valid_host_name      => /\A([a-z]+\.)?vimeo\.com\z/,
      :video_id_matcher     => /\A\/?([0-9]+)\z/,
      :title_selector       => '.title',
      :description_selector => "#description",
      :thumbnail_selector   => ".current.clip .style_wrap img",
      :width                => 400,
      :height               => 300,
      :video_url            => "http://vimeo.com/moogaloop.swf?clip_id=%s&server=vimeo.com&show_title=1&show_byline=1&show_portrait=0&color=&fullscreen=1"
    }
    
    extend  Modules::Video::HostNameMatching
    include Modules::Video::Common
    
    def initialize( args = {} )
      @uri = URI.parse(args[:url])
      
      unless self.class.valid_host_name?(@uri.host)
        raise ArgumentError, "URL must be from vimeo.com"
      end
      
      unless @video_id = extract_video_id_from_path( @uri.path )
        raise ArgumentError, "URL must have a video ID in it"
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
        object.param :name => 'movie', :value => video_url
        object.embed(
          :src => video_url, 
          :type => config[:mime_type],
          :allowfullscreen => config[:allow_full_screen],
          :allowscriptaccess => 'always',
          :width => w,
          :height => h
        )
      end
    end
    
    def thumbnail
      @thumbnail ||=
        doc.search(config[:thumbnail_selector]).first.attribute('src').to_s
    end
    private
      def video_url
        sprintf(config[:video_url], video_id)
      end
      
      def extract_video_id_from_path( path )
        if matches = path.match(config[:video_id_matcher])
          return matches[1]
        end
      end
  end
end