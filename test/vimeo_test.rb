require 'test_helper'
require 'hpricot'

class Scraper::VimeoTest < Test::Unit::TestCase
  def stub_open_uri!
    Scraper::Modules::Web.expects(:open).returns(
      File.open(@@fixture_path + '/5826468.html', 'r')
    )
  end
  
  context "given a url not from vimeo.com" do
    should "raise an ArgumentError" do
      assert_raise ArgumentError do
        Scraper::Vimeo.new(:url => 'http://wikipedia.org/bla.html')
      end
    end
  end
  
  context "a vimeo url without an id in it" do
    setup do
      @url = "http://vimeo.com/user1269265/videos"
    end

    should "raise an ArgumentError" do
      assert_raise ArgumentError do
        Scraper::Vimeo.new(:url => @url)
      end
    end
  end
  
  context "given the canonical URL http://vimeo.com/5826468" do
    setup do
      @url = "http://vimeo.com/5826468"
      @vimeo = Scraper::Vimeo.new( :url => @url )
    end

    should "not raise an error" do
      assert_nothing_raised do
        Scraper::Vimeo.new( :url => @url )
      end
    end
    
    should "have a video_id 5826468" do
      assert_equal '5826468', @vimeo.video_id
    end
    
    should "have a video title 'Sunlight Heaven'" do
      stub_open_uri!
      assert_equal 'Sunlight Heaven', @vimeo.title
    end
    
    should "have a video description 'Sunrise is one of the greatest...'" do
      stub_open_uri!
      
      @desc = "Sunrise is one of the greatest things in life. it’s a pity that i don’t see it very often. Here i tried to catch the mood of the morning sun on the way back home to Sajkod from Balatonsound festival."
      @desc << "  \nshot in Hungary @ lake Balaton, mainly on the ferry from Szántód to Tihany."
      @desc << "  \nthe music is Sunlight, Heaven from Julianna Barwick"
      @desc << "  \ni used \ncanon hv30 \nDIY 35mm adapter (static) with nikon lens (50mm) 1.4"
      
      assert_equal @desc, @vimeo.description
    end
    
    context "embed html width 1024x768 dimensions" do
      setup do
        @html = @vimeo.html( :width => 1024, :height => 768 )
        @doc  = Hpricot(@html)
        @object = @doc.search('object').first
        @embed  = @doc.search('object > embed').first
      end

      should "have an object tag with 1024 width" do
        assert_equal '1024', @object.attributes['width']
      end
      
      should "have an object tag with 768 height" do
        assert_equal '768', @object.attributes['height']
      end
      
      should "have a param tag with it's video url in it" do
        movie = @object.search('param').detect { |p| 
          p.attributes['name'] == 'movie' 
        }
        assert_match(/5826468/, movie.attributes['value'])
      end
      
      should "have an embed tag with 1024 width" do
        assert_equal '1024', @embed.attributes['width']
      end
      
      should "have an embed tag with 768 height" do
        assert_equal '768', @embed.attributes['height']
      end
      
      should "have the correct thumbnail" do
        stub_open_uri!
        
        @expected = "http://ts.vimeo.com.s3.amazonaws.com"
        @expected << "/204/207/20420769_100.jpg"
        
        assert_equal @expected, @vimeo.thumbnail
      end
    end
    
  end
  
  context "a url like http://vimeo.com/5826468?ref=blablabla" do
    setup do
      @scraper = Scraper::Vimeo.new(:url => 
        "http://vimeo.com/5826468?ref=blablabla"
      )
    end

    should "have a video_id 5826468" do
      assert_equal '5826468', @scraper.video_id
    end
  end
  
end