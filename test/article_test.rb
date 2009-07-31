require 'test_helper'

class Scraper::ArticleTest < Test::Unit::TestCase
  context "given an unreadable content (youtube's homepage for ex)" do
    setup do
      @content = fixture_file('non-article.html') 
    end

    should "raise an Article::Unsupported error" do
      assert_raise Scraper::Article::Unsupported do
        Scraper::Article.new(:content => @content)
      end
    end
  end
  
  context "given an argument :foobar" do
    should "raise an ArgumentError" do
      assert_raise ArgumentError do
        Scraper::Article.new(:foobar => 'asehtusaeotu')
      end
    end
  end
  
  context "given the unwebbable A-List-Apart article" do
    setup do
      @fixture = fixture_file('unwebbable.html')
      @article = Scraper::Article.new( :content => @fixture )
    end
    
    should "not raise an error during initialization" do
      assert_nothing_raised do
        @article = Scraper::Article.new( :content => @fixture )
      end
    end
    
    should "have a title: A List Apart: Articles: Unwebbable" do
      assert_equal 'A List Apart: Articles: Unwebbable',
        @article.title
    end
    
    should "have a content body starting with It's time we came to grips" do
      assert_match(/It’s time we came to grips/m, @article.text)
    end
    
    should "have a content ending with XML is finally a viable option." do
      assert_match(/XML is finally a viable option.$/, @article.text)
    end
    
    should "have the html content in scraped" do
      assert_equal fixture_file('scraped.html'),
        @article.html
    end
  end
end
