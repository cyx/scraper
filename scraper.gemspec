# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{scraper}
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Cyril David"]
  s.date = %q{2009-08-01}
  s.email = %q{cyx.ucron@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.markdown"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.markdown",
     "Rakefile",
     "VERSION",
     "lib/scraper.rb",
     "lib/scraper/article.rb",
     "lib/scraper/flickr.rb",
     "lib/scraper/modules.rb",
     "lib/scraper/modules/video.rb",
     "lib/scraper/modules/web.rb",
     "lib/scraper/vimeo.rb",
     "lib/scraper/youtube.rb",
     "scraper.gemspec",
     "test/article_test.rb",
     "test/fixtures/5826468.html",
     "test/fixtures/dLO2s7SDHJo.html",
     "test/fixtures/non-article.html",
     "test/fixtures/photostream.html",
     "test/fixtures/scraped.html",
     "test/fixtures/show_photo.html",
     "test/fixtures/unwebbable.html",
     "test/flickr_test.rb",
     "test/scraper_test.rb",
     "test/test_helper.rb",
     "test/vimeo_test.rb",
     "test/web_test.rb",
     "test/youtube_test.rb"
  ]
  s.homepage = %q{http://github.com/cyx/scraper}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.3}
  s.summary = %q{TODO}
  s.test_files = [
    "test/article_test.rb",
     "test/flickr_test.rb",
     "test/scraper_test.rb",
     "test/test_helper.rb",
     "test/vimeo_test.rb",
     "test/web_test.rb",
     "test/youtube_test.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
