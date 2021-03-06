require 'test_helper'

class ScraperTest < Test::Unit::TestCase
  context "given a Youtube URL" do
    setup do
      @url = "http://www.youtube.com/watch?v=dLO2s7SDHJo&feature=rec-HM-r2"
    end

    should "be able to make a youtube object without failing" do
      assert_nothing_raised do
        Scraper::Youtube.new(:url => @url)
      end
    end
  end
  
  context "Scraper( <youtube url > )" do
    setup do
      @url = "http://www.youtube.com/watch?v=dLO2s7SDHJo&feature=rec-HM-r2"
      @scraper = Scraper( :url => @url )
    end

    should "return a Scraper::Youtube object" do
      assert_instance_of Scraper::Youtube, @scraper
    end
  end
  
  context "Scraper( <vimeo url> )" do
    setup do
      @url = "http://vimeo.com/5826468"
      @scraper = Scraper(:url => @url)
    end

    should "return a Scraper::Vimeo object" do
      assert_instance_of Scraper::Vimeo, @scraper
    end
  end
  
  context "Scraper( <flickr url> )" do
    setup do
      @url = "http://www.flickr.com/photos/80186783@N00/124484929/"
      @scraper = Scraper(:url => @url)
    end

    should "return a Scraper::Flickr object" do
      assert_instance_of Scraper::Flickr, @scraper
    end
    
    context "when the url doesn't have the photo part at the end" do
      setup do
        @url = "http://www.flickr.com/photos/80186783@N00"
        @scraper = Scraper(:url => @url)
      end

      should "return a Scraper::Flickr object still" do
        assert_instance_of Scraper::Flickr, @scraper
      end
    end
  end
  
  
  context "given an article from A-List-Apart" do
    setup do
      @article = fixture_file('unwebbable.html')
    end

    should "be able to make an article object without failing" do
      assert_nothing_raised do
        Scraper::Article.new(:content => @article)
      end
    end
    
    context "when extracting the actual content using the URL" do
      setup do
        Scraper::Modules::Web.expects(:open).returns(
          File.open(@@fixture_path + '/unwebbable.html', 'r')
        )
        
        @url = "http://www.alistapart.com/articles/unwebbable/"
        @scraper1 = Scraper::Article.new(:content => @article)
        @scraper2 = Scraper::Article.new(:url => @url)
      end

      should "have the same HTML extracted" do
        assert_equal @scraper1.html, @scraper2.html
      end
    end
  end
  
  context "Scraper( <alist apart content >)" do
    setup do
      @article = fixture_file('unwebbable.html')
    end

    should "return an instance of Article" do
      assert_instance_of Scraper::Article, Scraper( :content => @article )
    end
  end
  
  context "Scraper( <alist apart url> )" do
    setup do
      Scraper::Modules::Web.expects(:open).returns(
        File.open(@@fixture_path + '/unwebbable.html', 'r')
      )
      
      @url = "http://www.alistapart.com/articles/unwebbable/"
    end

    should "return an instance of Article" do
      assert_instance_of Scraper::Article, Scraper( :url => @url )
    end
  end
  
  context "given the non-article content" do
    setup do
      @content = fixture_file('non-article.html')
    end

    should "raise an ArgumentError (can't handle content from args)" do
      assert_raise ArgumentError do
        Scraper(:content => @content)
      end
    end
  end
  
end
