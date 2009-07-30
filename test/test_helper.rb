require 'rubygems'
require 'test/unit'
require 'shoulda'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'scraper'

class Test::Unit::TestCase
  @@fixture_path = File.dirname(__FILE__) + '/fixtures/'
  
  def fixture_file( file )
    File.read(@@fixture_path + file)
  end
end
