# for test coverage

require 'rspec-solr'
require 'simplecov'
require 'rspec/collection_matchers'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

RSpec.configure do |_config|
end
