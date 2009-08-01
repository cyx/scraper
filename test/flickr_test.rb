require 'test_helper'

class Scraper::FlickrTest < Test::Unit::TestCase
  context "given a photostream url" do
    setup do
      @url = "http://www.flickr.com/photos/80186783@N00/"
      @flickr = Scraper::Flickr.new(:url => @url)
      Scraper::Modules::Web.stubs(:open).returns(
        File.open(@@fixture_path + '/photostream.html', 'r')
      )
    end

    should "return the photo stream's title" do
      assert_equal "David Lazar's photostream", @flickr.title
    end
    
    should "say that it's a photostream" do
      assert @flickr.photostream?
    end
    
    should "return the first photo as the thumbnail" do
      @t = 'http://farm1.static.flickr.com/38/124484929_ed8c345cb9_m.jpg'
      assert_equal @t, @flickr.thumbnail
    end
    
    should "have no description" do
      assert_equal '', @flickr.description
    end
  end
  
  context "given a photo url" do
    setup do
      @url = "http://www.flickr.com/photos/80186783@N00/124484929/"
      Scraper::Modules::Web.stubs(:open).returns(
        File.open(@@fixture_path + '/show_photo.html', 'r')
      )
      @flickr = Scraper::Flickr.new(:url => @url)
    end

    should "return the photo's title" do
      assert_equal 'Debian Box', @flickr.title
    end
    
    should "return the photo's description" do
      assert_equal 'An empty desktop.', @flickr.description
    end
    
    should "return the photo's thumbnail" do
      @t = "http://farm1.static.flickr.com/38/124484929_ed8c345cb9_m.jpg"
      assert_equal @t, @flickr.thumbnail
    end
  end
  
  # 
end