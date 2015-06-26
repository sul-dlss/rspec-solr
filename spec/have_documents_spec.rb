require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do

  # fixtures below

  context "have_documents with no doc matcher" do
    it "passes if response.should has documents" do
      @solr_resp_w_docs.should have_documents
      @solr_resp_total_but_no_docs.should have_documents
    end

    it "passes if response.should_not has no documents" do
      @solr_resp_no_docs.should_not have_documents
    end

    it "failure message for should" do
      expect {
        @solr_resp_no_docs.should have_documents
      }.to raise_error.with_message a_string_including "expected documents in Solr response "
    end

    it "failure message for should_not" do
      expect {
        @solr_resp_w_docs.should_not have_documents
        @solr_resp_total_but_no_docs.should_not have_documents
      }.to raise_error.with_message a_string_including "did not expect documents, but Solr response had "
    end    
  end
  
  before(:all) do
    @solr_resp_w_docs = { "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333"}, 
                                {"id"=>"444"}, 
                                {"id"=>"555"}
                              ]
                          }
                        }

    @solr_resp_no_docs = { "response" =>
                          { "numFound" => 0, 
                            "start" => 0, 
                            "docs" => [] 
                          }
                        } 
    @solr_resp_total_but_no_docs = { "response" =>
                          { "numFound" => 1324, 
                            "start" => 0, 
                            "docs" => [] 
                          }
                        } 
  end
  
end