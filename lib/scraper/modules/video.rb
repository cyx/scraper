require 'nokogiri'
require 'open-uri'

module Scraper
  module Modules
    module Video
      module HostNameMatching
        def =~( args )
          if args[:url]
            uri = URI.parse( args[:url] )

            if valid_host_name?( uri.host )
              return new( args )
            end
          end
        end

        def valid_host_name?( host_name )
          host_name.match(config[:valid_host_name])
        end
      end

      module Common
        def self.included( base )
          base.cattr_accessor :config
        end
        
        def title
          @title ||= doc.search(config[:title_selector]).first.content
        end
        
        def description
          return @description if @description
          
          html = doc.search(config[:description_selector]).first.inner_html
          @description = dom(html.gsub(/<br\/?>/, ' ')).content.strip
        end
        
        def video_id
          @video_id
        end
        
        protected
          def dom( html )
            Nokogiri::HTML( html )
          end
          
          def uri
            @uri.scheme + '://' + @uri.host + @uri.request_uri
          end
          
          def doc
            @doc ||= dom( Modules::Web.open( uri ).read )
          end
      end
    end
  end
end