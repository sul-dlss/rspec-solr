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
      expect(RSpecSolr::SolrResponseHash.new({}).id_field).to eq("id")
      expect(@srh.id_field).to eq("id")
    end
    it "should be changable to whatever" do
      @srh.id_field='new'
      expect(@srh.id_field).to eq('new')
      @srh.id_field='newer'
      expect(@srh.id_field).to eq('newer')
    end
  end
  
  # fixture below
  
  context "has_document?" do
    it "should be true when single document meets expectation" do
      expect(@solr_resp_5_docs).to have_document({"id" => "222"})
      expect(@solr_resp_5_docs).to have_document({"id" => "111", "fld" => "val"})
    end
    
    it "should be true when at least one doc meets expectation" do
      expect(@solr_resp_5_docs).to have_document({"fld" => "val"})
    end
    
    it "should be false when no docs meet expectation" do
      expect(@solr_resp_5_docs).not_to have_document({"id" => "not_there"})
    end
    
    it "should be false when only part of expectation is met" do
      expect(@solr_resp_5_docs).not_to have_document({"id" => "222", "fld" => "val"})
    end  
    
    it "should be true when document is < =  expected position in results" do
      expect(@solr_resp_5_docs).to have_document({"id" => "222"}, 2)
    end
    
    it "should be false when document is > expected position in results" do
      expect(@solr_resp_5_docs).not_to have_document({"id" => "222"}, 1)
    end
     
  end  # has_document?
  
  context "get_first_doc_index" do
    it "should get the right document index with an id String argument" do
      expect(@solr_resp_5_docs.get_first_doc_index("333")).to eq(2)
      expect(@solr_resp_5_docs.get_first_doc_index("111")).to eq(0)
    end
    
    it "should get the first occurrence of a doc meeting a Hash argument" do
      expect(@solr_resp_5_docs.get_first_doc_index("fld"=>"val")).to eq(0)
      expect(@solr_resp_5_docs.get_first_doc_index("id"=>"333")).to eq(2)
    end
    
    it "should get the index of the doc occurring first in the results from an Array argument" do
      expect(@solr_resp_5_docs.get_first_doc_index(["fld"=>"val"])).to eq(0)
      expect(@solr_resp_5_docs.get_first_doc_index(["222", "444"])).to eq(1)
    end
    
    it "should return nil when the expectation argument isn't met" do
      expect(@solr_resp_5_docs.get_first_doc_index("666")).to be_nil
      expect(@solr_resp_5_docs.get_first_doc_index("not_there"=>"not_there")).to be_nil
      expect(@solr_resp_5_docs.get_first_doc_index(["222", "666"])).to be_nil
    end
    
  end
  
  context "get_min_index" do    
    it "should return nil when both arguments are nil" do
      expect(@solr_resp_5_docs.send(:get_min_index, nil, nil)).to be_nil
    end
    it "should return the first argument when the second argument is nil" do
      expect(@solr_resp_5_docs.send(:get_min_index, 3, nil)).to eq(3)
    end
    it "should return the second argument when the first argument is nil" do
      expect(@solr_resp_5_docs.send(:get_min_index, nil, 5)).to eq(5)
    end
    it "should return the minimum of the two arguments when neither of them is nil" do
      expect(@solr_resp_5_docs.send(:get_min_index, 2, 5)).to eq(2)
      expect(@solr_resp_5_docs.send(:get_min_index, 5, 2)).to eq(2)
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