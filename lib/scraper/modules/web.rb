require 'nokogiri'
require 'open-uri'

module Scraper
  module Modules
    module Web
      def self.open( *args )
        Kernel.open( *args )
      end
      
      module MetaData
        def self.included( base )
          base.cattr_accessor :config
        end

        def title
          @title ||= doc.search(config[:title_selector]).first.content.strip
        end
        
        def description
          return @description if @description
          
          if element = doc.search(config[:description_selector]).first
            html         = element.inner_html
            html.gsub!(/<br\/?>/u, ' ')
            html.gsub!("\302\240", ' ')
            @description = dom(html).content.strip
          else
            @description = ''
          end
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