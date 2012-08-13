require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr::SolrResponseHash do
  
  context "id field" do
    before(:all) do
      @srh = RSpecSolr::SolrResponseHash.new({ "response" =>
                            { "docs" => 
                                [ {"id"=>"111"}, 
                                  {"not_id"=>"222"}, 
                                  {"id"=>"333"}, 
                                ]
                            }
                          })
    end
    it "should default to 'id'" do
      RSpecSolr::SolrResponseHash.new({}).id_field.should == "id"
      @srh.id_field.should == "id"
    end
    it "should be changable to whatever" do
      @srh.id_field='new'
      @srh.id_field.should == 'new'
      @srh.id_field='newer'
      @srh.id_field.should == 'newer'
    end
  end
  
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
    
    it "should be true when single document meets expectation" do
      @solr_resp_5_docs.should have_document({"id" => "222"})
      @solr_resp_5_docs.should have_document({"id" => "111", "fld" => "val"})
    end
    
    it "should be true when at least one doc meets expectation" do
      @solr_resp_5_docs.should have_document({"fld" => "val"})
    end
    
    it "should be false when no docs meet expectation" do
      @solr_resp_5_docs.should_not have_document({"id" => "not_there"})
    end
    
    it "should be false when only part of expectation is met" do
      @solr_resp_5_docs.should_not have_document({"id" => "222", "fld" => "val"})
    end  
    
    it "should be true when document is < =  expected position in results" do
      @solr_resp_5_docs.should have_document({"id" => "222"}, 2)
    end
    
    it "should be false when document is > expected position in results" do
      @solr_resp_5_docs.should_not have_document({"id" => "222"}, 1)
    end
     
  end  
  
end