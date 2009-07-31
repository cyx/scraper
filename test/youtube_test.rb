require 'test_helper'
require 'hpricot'

class Scraper::YoutubeTest < Test::Unit::TestCase
  def stub_open_uri!
    Scraper::Modules::Web.expects(:open).returns(
      File.open(@@fixture_path + '/dLO2s7SDHJo.html', 'r')
    )
  end
  
  context "given http://www.youtube.com/watch?v=dLO2s7SDHJo&feature=rec-HM-r2" do
    setup do
      @youtube = Scraper::Youtube.new(
        :url => "http://www.youtube.com/watch?v=dLO2s7SDHJo&feature=rec-HM-r2"
      )
    end

    should "have a video_id dLO2s7SDHJo" do
      assert_equal "dLO2s7SDHJo", @youtube.video_id
    end
    
    should "have a title 'How to Hack Flash Games'" do
      stub_open_uri!
      
      assert_equal 'How to Hack Flash Games', @youtube.title
    end
    
    should "have a description Cheat Engine: ..." do
      stub_open_uri!
      
      @desc = "Cheat Engine: http://cheatengine.org/downloads.php"
      @desc << "  Music by: Reasoner http://reasoner.newgrounds.com"
      @desc << "  Twitter: http://www.twitter.com/householdhacker"
      @desc << "  We are going to show you how to hack any flash game using Cheat engine. You can hack games like bloons, desktop tower defense and many others."
      
      assert_equal @desc, @youtube.description
    end
    
    should "have a thumbnail with it's video id in it" do
      assert_match(/dLO2s7SDHJo/, @youtube.thumbnail)
    end
  end
  
  context "given http://www.youtube.com/watch?feature=rec-HM-r2&v=dLO2s7SDHJo" do
    setup do
      @youtube = Scraper::Youtube.new(
        :url => "http://www.youtube.com/watch?feature=rec-HM-r2&v=dLO2s7SDHJo"
      )
    end

    should "have a video_id dLO2s7SDHJo" do
      assert_equal "dLO2s7SDHJo", @youtube.video_id
    end
  end
  
  context "given http://vimeo.com/5702579" do
    should "raise an ArgumentError" do
      assert_raise ArgumentError do
        Scraper::Youtube.new(:url => "http://vimeo.com/5702579")
      end
    end
  end
  
  context "given http://www.youtube.com/watch?feature=rec-HM-r2" do
    should "raise an ArgumentError" do
      assert_raise ArgumentError do
        Scraper::Youtube.new(:url => 
          "http://www.youtube.com/watch?feature=rec-HM-r2"
        )
      end
    end
  end
  
  context "HTML given a 1024x760 dimension configuration" do
    setup do
      @youtube = Scraper::Youtube.new(
        :url => "http://www.youtube.com/watch?feature=rec-HM-r2&v=dLO2s7SDHJo"
      )
      @doc = Hpricot(@youtube.html(:width => 1024, :height => 768))
      @embed = @doc.search('embed').first
      @object = @doc.search('object').first
    end

    should "have an embed tag with 1024 width" do
      assert_equal '1024', @embed.attributes['width']
    end
    
    should "have an embed tag with 768 height" do
      assert_equal '768', @embed.attributes['height']
    end
    
    should "have an embed tag with the movie's id in its src" do
      assert_match(/dLO2s7SDHJo/, @embed.attributes['src'])
    end
    
    should "have an object tag with 1024 width" do
      assert_equal '1024', @object.attributes['width']
    end
    
    should "have an object tag with 768 height" do
      assert_equal '768', @object.attributes['height']
    end
    
    should "have an object tag with the movie's id in its params" do
      param = @object.search('param').detect { |p| p.attributes['name'] == 'movie' }
      
      assert_match(/dLO2s7SDHJo/, param.attributes['value'])
    end
  end
end
