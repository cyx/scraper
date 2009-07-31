module Scraper
  module Modules
    module Web
      def self.open( *args )
        Kernel.open( *args )
      end
    end
  end
end