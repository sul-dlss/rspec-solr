require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  context "should include(doc_expectations)" do
    context "doc_predicate is for single valued fields" do
      it "should pass when response includes doc matching expectations" do
        @solr_resp_5_docs.should include({"id" => "111"})
      end
    end    
  end
  
  context "shouldn't break RSpec #include matcher" do
    it "for String" do
      "abc".should include("a")
      "abc".should_not include("d")
    end
    
    it "for Array" do
      [1,2,3].should include(3)
      [1,2,3].should include(2,3)
      [1,2,3].should_not include(4)
#      [1,2,3].should_not include(1,4)
    end
    
    it "for Hash" do
      {:key => 'value'}.should include(:key)
      {:key => 'value'}.should_not include(:key2)
#      {:key => 'value'}.should_not include(:key, :key2)
      {'key' => 'value'}.should include('key')
      {'key' => 'value'}.should_not include('key2')
    end
  end
  
  before(:all) do
    @solr_resp_5_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111", "fld"=>"val"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333", "fld"=>"val"}, 
                                {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                {"id"=>"555"}
                              ]
                          }
                        })
  end
  
end