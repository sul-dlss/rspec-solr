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
  
  # fixture below
  
  context "has_document?" do
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
     
  end  # has_document?
  
  context "get_first_doc_index" do
    it "should get the right document index with an id String argument" do
      @solr_resp_5_docs.get_first_doc_index("333").should == 2
      @solr_resp_5_docs.get_first_doc_index("111").should == 0
    end
    
    it "should get the first occurrence of a doc meeting a Hash argument" do
      @solr_resp_5_docs.get_first_doc_index("fld"=>"val").should == 0
      @solr_resp_5_docs.get_first_doc_index("id"=>"333").should == 2
    end
    
    it "should get the index of the doc occurring first in the results from an Array argument" do
      @solr_resp_5_docs.get_first_doc_index(["fld"=>"val"]).should == 0
      @solr_resp_5_docs.get_first_doc_index(["222", "444"]).should == 1
    end
    
    it "should return nil when the expectation argument isn't met" do
      @solr_resp_5_docs.get_first_doc_index("666").should be_nil
      @solr_resp_5_docs.get_first_doc_index("not_there"=>"not_there").should be_nil
      @solr_resp_5_docs.get_first_doc_index(["222", "666"]).should be_nil
    end
    
  end
  
  context "get_min_index" do    
    it "should return nil when both arguments are nil" do
      @solr_resp_5_docs.send(:get_min_index, nil, nil).should be_nil
    end
    it "should return the first argument when the second argument is nil" do
      @solr_resp_5_docs.send(:get_min_index, 3, nil).should == 3
    end
    it "should return the second argument when the first argument is nil" do
      @solr_resp_5_docs.send(:get_min_index, nil, 5).should == 5
    end
    it "should return the minimum of the two arguments when neither of them is nil" do
      @solr_resp_5_docs.send(:get_min_index, 2, 5).should == 2
      @solr_resp_5_docs.send(:get_min_index, 5, 2).should == 2
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
                                {"id"=>"444"}, 
                                {"id"=>"555"}
                              ]
                          }
                        })
  end
  
end