require 'rspec-solr'

describe RSpecSolr do

  context "should have(n)_documents" do
    
    it "pluralizes 'documents'" do
      @solr_resp_1_doc.should have(1).document
    end
    
    it "passes if target response has n documents" do
      @solr_resp_5_docs.should have(5).documents
      @solr_resp_no_docs.should have(0).documents
    end
    
    it "converts :no to 0" do
      @solr_resp_no_docs.should have(:no).documents
    end
    
    it "converts a String argument to Integer" do
      @solr_resp_5_docs.should have('5').documents
    end
    
    it "fails if target response has < n documents" do
      lambda {
        @solr_resp_5_docs.should have(6).documents
      }.should fail_with("expected 6 documents; got 5")
      lambda {
        @solr_resp_no_docs.should have(1).document
      }.should fail_with("expected 1 document; got 0")
    end
    
    it "fails if target response has > n documents" do
      lambda {
        @solr_resp_5_docs.should have(4).documents
      }.should fail_with("expected 4 documents; got 5")
      lambda {
        @solr_resp_1_doc.should have(0).documents
      }.should fail_with("expected 0 documents; got 1")
    end
    
  end
  
  context "should_not have(n).documents" do
    it "passes if target response has < n documents" do
      @solr_resp_5_docs.should_not have(6).documents
      @solr_resp_1_doc.should_not have(2).documents
      @solr_resp_no_docs.should_not have(1).document
    end
    
    it "passes if target response has > n documents" do
      @solr_resp_5_docs.should_not have(4).documents
      @solr_resp_1_doc.should_not have(0).documents
      @solr_resp_no_docs.should_not have(-1).documents
    end
    
    it "fails if target response has n documents" do
      lambda {
        @solr_resp_5_docs.should_not have(5).documents
      }.should fail_with("expected not to have 5 documents; got 5")
    end
  end
  
#  context "should have_exactly(n).documents" do
#    it "passes if target response has n documents" do
#      @solr_resp_5_docs.should have_exactly(5).documents
#      @solr_resp_no_docs.should have_exactly(0).documents
#    end
#    it "converts :no to 0" do
#      @solr_resp_no_docs.should have_exactly(:no).documents
#    end
#    it "fails if target response has < n documents" do
#      lambda {
#        @solr_resp_5_docs.should have_exacty(6).documents
#      }.should fail_with("expected 6 documents, got 5")
#      lambda {
#        @solr_resp_no_docs.should have_exactly(1).document
#      }.should fail_with("expected 1 document, got 0")
#    end
#    
#    it "fails if target response has > n documents" do
#      lambda {
#        @solr_resp_5_docs.should have_exactly(4).documents
#      }.should fail_with("expected 4 documents, got 5")
#      lambda {
#        @solr_resp_1_doc.should have_exactly(0).documents
#      }.should fail_with("expected 0 documents, got 1")
#    end
#  end
#  
  
  
# TODO:  check for should_not failure messages  
#
#  it "failure message for should_not" do
#    expect {@solr_resp_w_docs.should_not have_documents}.
#      to raise_error(RSpec::Expectations::ExpectationNotMetError, /FIXME did not expect documents, but Solr response had /)
#  end    
#
  
  
  before(:all) do
    @solr_resp_1_doc = { "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => [ {"id"=>"111"} ]
                          }
                        }

    @solr_resp_5_docs = { "response" =>
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
  end
  
  
  
end