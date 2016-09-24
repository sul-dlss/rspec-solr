
# # -*- encoding: utf-8 -*-
require File.expand_path('../lib/rspec-solr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = 'rspec-solr'
  gem.version       = RSpecSolr::VERSION
  gem.authors       = ['Naomi Dushay', 'Chris Beer']
  gem.email         = ['ndushay@stanford.edu', 'cabeer@stanford.edu']
  gem.description   = 'Provides RSpec custom matchers to be used with Solr response objects.'
  gem.summary       = 'RSpec custom matchers for Solr response objects'
  gem.homepage      = 'http://github.com/sul-dlss/rspec-solr'

  gem.extra_rdoc_files = ['LICENSE.txt', 'README.md', 'MATCHERS.md']
  gem.files         = `git ls-files`.split($OUTPUT_RECORD_SEPARATOR)
  gem.test_files    = gem.files.grep(%r{^spec/})
  gem.executables   = gem.files.grep(%r{^bin/}).map { |f| File.basename(f) }
  gem.require_path = ['lib']

  gem.add_runtime_dependency 'rspec', '~> 3.0', '< 3.4'
  gem.add_runtime_dependency 'rspec-collection_matchers'

  # Development dependencies
  # Bundler will install these gems too if you've checked out rspec-solr source from git and run 'bundle install'
  # It will not add these as dependencies if you require rspec-solr for other projects
  gem.add_development_dependency 'rake'
  # docs
  gem.add_development_dependency 'rdoc'
  gem.add_development_dependency 'yard'
  # test coverage for this gem
  gem.add_development_dependency 'simplecov'
  # continuous integration
  gem.add_development_dependency 'travis-lint'
  gem.add_development_dependency 'rubocop'
end
