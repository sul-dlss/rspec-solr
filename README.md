[![Build Status](https://travis-ci.org/sul-dlss/rspec-solr.svg?branch=master)](https://travis-ci.org/sul-dlss/rspec-solr)
[![Coverage Status](https://coveralls.io/repos/sul-dlss/rspec-solr/badge.svg)](https://coveralls.io/r/sul-dlss/rspec-solr)
[![Dependency Status](https://gemnasium.com/sul-dlss/rspec-solr.svg)](https://gemnasium.com/sul-dlss/rspec-solr)

# RSpec Solr

A Gem to provide RSpec custom matchers to be used with Solr response objects.

## Installation

Add this line to your application's Gemfile:

    gem 'rspec-solr'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rspec-solr

## Usage

See `MATCHERS.md` for syntax of supported expectations.

### Examples:

```ruby
 it "q of 'Buddhism' should get 8,500-10,500 results" do
   resp = solr_resp_doc_ids_only({'q'=>'Buddhism'})
   resp.should have_at_least(8500).documents
   resp.should have_at_most(10500).documents
 end
 
  it "q of 'Two3' should have excellent results", :jira => 'VUF-386' do
    resp = solr_response({'q'=>'Two3', 'fl'=>'id', 'facet'=>false}) 
    resp.should have_at_most(10).documents
    resp.should include("5732752").as_first_result
    resp.should include("8564713").in_first(2).results
    resp.should_not include("5727394")
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'two3'}))
    resp.should have_fewer_results_than(solr_resp_doc_ids_only({'q'=>'two 3'}))
  end
 
  it "Traditional Chinese chars 三國誌 should get the same results as simplified chars 三国志" do
  	resp = solr_response({'q'=>'三國誌', 'fl'=>'id', 'facet'=>false}) 
    resp.should have_at_least(240).documents
    resp.should have_the_same_number_of_results_as(solr_resp_doc_ids_only({'q'=>'三国志'})) 
  end
```

### How Do I Do That?

Essentially, you write a bunch of specs that
* send a request to your Solr index
* wrap the Solr Ruby response into the `RSpecSolr::SolrResponseHash`  (`blah = RSpecSolr::SolrResponseHash.new(orig_resp)``)
* utilize the matchers (`expect(blah).to have_document("222")``) -- see `MATCHERS.md`

There is an exemplar project utilizing rspec-solr at https://github.com/sul-dlss/sw_index_tests.  

Besides the specs themselves, it has essentially 4 files to smooth the way.

#### 1. Gemfile
Indicate the required gems for bundler

```ruby
 gem 'rsolr'       # for sending requests to and getting responses from solr
 gem 'rspec-solr'  # for rspec assertions against solr response object
```

#### 2. Rakefile
Make it easy to run various groups of specs from the command line

```ruby
 require 'rspec/core/rake_task'

 desc "run specs expected to pass" 
 RSpec::Core::RakeTask.new(:rspec) do |spec|
   spec.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb"]
 end
```

#### 3. config/solr.yml
Your Solr base url goes here

```yaml
 test:
  :url: http://your_solr_baseurl

 dev:
   :url: http://your_solr_baseurl
```

#### 4. spec/spec_helper.rb
Do a one time setup of Solr connection, and methods to make it easier to make desired Solr requests

```ruby
  require "yaml"
  require 'rsolr'
  
  $LOAD_PATH.unshift(File.dirname(__FILE__))
  
  RSpec.configure do |config|
    # FIXME:  hardcoded yml group
    solr_config = YAML::load_file('config/solr.yml')["test"]
    @@solr = RSolr.connect(solr_config)
    puts "Solr URL: #{@@solr.uri}"
  end
  
  private
  
  # send a GET request to the indicated Solr request handler with the indicated Solr parameters
  # @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters
  # @param req_handler [String] the pathname of the desired Solr request handler (defaults to 'select') 
  # @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response 
  def solr_response(solr_params, req_handler='select')  
    RSpecSolr::SolrResponseHash.new(@@solr.send_and_receive(req_handler, {:method => :get, :params => solr_params}))
  end
```

#### 4a.  a little more magic
You might want to add code such as that below to your spec_helper - it can help keep your solr responses small, which makes for easier debugging.
  
```ruby
  # send a GET request to the default Solr request handler with the indicated Solr parameters
  # @param solr_params [Hash] the key/value pairs to be sent to Solr as HTTP parameters, in addition to 
  #  those to get only id fields and no facets in the response
  # @return [RSpecSolr::SolrResponseHash] object for rspec-solr testing the Solr response 
  def solr_resp_doc_ids_only(solr_params)
    solr_response(solr_params.merge(@@doc_ids_only))
  end
  
  # use these Solr HTTP params to reduce the size of the Solr responses
  # response documents will only have id fields, and there will be no facets in the response
  # @return [Hash] Solr HTTP params to reduce the size of the Solr responses
  def doc_ids_only
    {'fl'=>'id', 'facet'=>'false'}
  end
```

## Contribute

I'm currently envisioning helper methods shared somehow - either on the github wikis, or in this gem as exemplars, or in a separate gem, or ...

Please share yours!

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Releases
- <b>3.0.0</b> Add compatibility with rspec ~> 3.5
- <b>2.0.0</b> No release notes
- <b>1.0.1</b> fix spec failing in travis due to diff error message in later rspec version
- <b>1.0.0</b> declare victory and make 0.2.0 into 1.0.0
- <b>0.2.0</b> add facet support  have_facet_field(fld_name).with_value(fld_value)
- <b>0.1.4</b> fix regex match to work with in_each_of_first(n)
- <b>0.1.3</b> added include().in_each_of_first(n)
- <b>0.1.2</b> added document matching via regex for field values 
- <b>0.1.1</b> improve README
- <b>0.1.0</b> Initial release
