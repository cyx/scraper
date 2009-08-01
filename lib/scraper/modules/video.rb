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
        def video_id
          @video_id
        end
      end
    end
  end
end