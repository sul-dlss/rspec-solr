require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr::SolrResponseHash do
  
  context "has_document?" do
    before(:all) do
      @solr_resp_5_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                            { "numFound" => 5, 
                              "start" => 0, 
                              "docs" => 
                                [ {"id"=>"111", "fld"=>"val"}, 
                                  {"id"=>"222"}, 
                                  {"id"=>"333", "fld"=>"val"}, 
                                  {"id"=>"444"}, 
                                  {"id"=>"555"}
                                ]
                            }
                          })
    end
    
    it "should be true when single document meets requirement" do
      @solr_resp_5_docs.should have_document({"id" => "222"})
      @solr_resp_5_docs.should have_document({"id" => "111", "fld" => "val"})
    end
    
    it "should be true when at least one doc meets param" do
      @solr_resp_5_docs.should have_document({"fld" => "val"})
    end
    
    it "should be false when no docs meet requirement" do
      @solr_resp_5_docs.should_not have_document({"id" => "666"})
    end
    
    it "should be false when only part of requirement is met" do
      @solr_resp_5_docs.should_not have_document({"id" => "222", "fld" => "val"})
    end   
  end  
  
end