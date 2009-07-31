require 'test_helper'

class Scraper::WebTest < Test::Unit::TestCase
  context "Web.open" do
    should "just delegate to Kernel.open" do
      Kernel.expects(:open).with(:timbuktu)
      
      Scraper::Modules::Web.open(:timbuktu)
    end
  end
  
end