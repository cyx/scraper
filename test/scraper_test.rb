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
        @url = "http://www.alistapart.com/articles/unwebbable/"
        @scraper1 = Scraper::Article.new(:content => @article)
        @scraper2 = Scraper::Article.new(:url => @url)
      end

      should "have the same HTML extracted" do
        assert_equal @scraper1.html, @scraper2.html
      end
    end
  end
end
