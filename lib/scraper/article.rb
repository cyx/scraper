# Copyright (c) 2009 [Cyril David]
# 
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
# 
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

require 'nokogiri'
require 'open-uri'

module Scraper
  class Article
    class Unsupported < StandardError; end
    
    BAD_CLASS_NAMES = /(comment|meta|footer|footnote)/
    GOOD_CLASS_NAMES = /((^|\\s)(post|hentry|entry[-]?(content|text|body)?|article[-]?(content|text|body)?)(\\s|$))/
    
    BAD_ID_NAMES = /(comment|meta|footer|footnote)/
    GOOD_ID_NAMES = /^(post|hentry|entry[-]?(content|text|body)?|article[-]?(content|text|body)?)$/
    attr_reader :title
    
    def self.=~( args )
      return true
    end
    
    # Usage:
    # ======
    # 
    #     require 'open-uri'
    #     @resource = open("http://tinyurl.com/ys9wt")
    #     @article = Scraper::Article.new(@resource.read) 
    #     @article.title
    #     => "Open Source Initiative OSI - The MIT License:Licensing ..."
    #     
    #     @article.text
    #     => "The MIT License\nCopyright (c) <year> <copyright holders> ..."
    #
    #     @article.html
    #     => "<img width=\"100\" height=\"137\" alt=\"[OSI Approved ..." 
    #
    #  In some cases, this might raise an Unsupported error. Submit an issue 
    #  at http://github.com/cyx/scraper/issues in that case.
    #
    def initialize( args = {} )
      content   = extract_from_args( args )
      @document = Nokogiri::HTML replace_double_brs_and_fonts(content)
      @title    = @document.search('title').first.content
      @top_div  = calculate_top_div @document.search('p')
      
      unless @top_div
        raise Unsupported, "The content is unsupported at this time"
      end
      
      clean!( @top_div )
    end
    
    def text
      @top_div.content.strip
    end
    
    def html
      @top_div.inner_html
    end
    
    private
      def extract_from_args(args)
        if args[:content]
          return args[:content]
        elsif args[:url]
          open(args[:url]).read
        else
          raise ArgumentError, "Scraper::Article#initialize only accepts content or url as its argument options"
        end
      end
      
      def clean!( node )
        clean_styles!(node)
        kill_divs!(node)
        clean_tags!(node, "form")
        clean_tags!(node, "object")
        clean_tags!(node, "table")
        clean_tags!(node, "h1")
        clean_tags!(node, "h2")
        clean_tags!(node, "iframe")
      end
      
      def calculate_top_div( paragraphs )
        scores = rate_and_score_paragraphs( paragraphs )
        scores.sort_by { |e| e[:score] }.last[:node]
      end
      
      def rate_and_score_paragraphs( paragraphs )
        paragraphs.map do |paragraph|
          rating = { :node => paragraph.parent, :score => 0 }

          if rating[:node].attribute('class').to_s.match(BAD_CLASS_NAMES)
            rating[:score] -= 50
          elsif rating[:node].attribute('class').to_s.match(GOOD_CLASS_NAMES)
            rating[:score] += 25
          end

          if rating[:node].attribute('id').to_s.match(BAD_ID_NAMES)
            rating[:score] -= 50
          elsif rating[:node].attribute('id').to_s.match(GOOD_ID_NAMES)
            rating[:score] += 25
          end

          if paragraph.content.length > 10
            rating[:score] += 1
          end

          rating[:score] += get_char_count(rating[:node])
          rating
        end
      end

      def replace_double_brs_and_fonts( content )
        pattern = /<br\/?>[ \r\n\s]*<br\/?>/
        content.gsub(pattern, '</p><p>').gsub(/<\/?font[^>]*>/, '')
      end
      
      def get_char_count( node, char = ',' )
        node.content.split(char).length
      end
      
      def clean_styles!( node )
        node.search('*').remove_attr('style')
      end
      
      def kill_divs!( node )
        node.search('div').each do |div|
          p = div.search('p').length
          img = div.search('img').length
          li = div.search('li').length
          a = div.search('a').length
          embed = div.search('embed').length
          
          if get_char_count( div ) < 10 
            if img > p || li > p || a > p || p == 0 || embed > 0
              div.remove
            end
          end
        end
      end
      
      def clean_tags!(node, tags, min_words = 1000000)
        node.search(tags).each do |target|
          if get_char_count( target, " " ) < min_words
            target.remove
          end
        end
      end
  end
end