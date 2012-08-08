require 'rspec-solr'

describe RSpecSolr do

  context "have_documents with no doc matcher" do
    it "passes if response.should has documents" do
      @solr_resp_w_docs.should have_documents
    end

    it "passes if response.should_not has no documents" do
      @solr_resp_no_docs.should_not have_documents
    end

    it "failure message for should" do
      expect {@solr_resp_no_docs.should have_documents}.
        to raise_error(RSpec::Expectations::ExpectationNotMetError, /expected documents in Solr response /)
    end

    it "failure message for should_not" do
      expect {@solr_resp_w_docs.should_not have_documents}.
        to raise_error(RSpec::Expectations::ExpectationNotMetError, /did not expect documents, but Solr response had /)
    end    
  end
  
  before(:all) do
    @solr_resp_w_docs = { "responseHeader" => 
                          { "status" => 0, 
                            "QTime" => 111, 
                            "params" => {"q"=>"foo", "wt"=>"ruby", "json.nl" => "arrarr"}
                          }, 
                        "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333"}, 
                                {"id"=>"444"}, 
                                {"id"=>"555"}
                              ]
                          }, # response
                        "facet_counts" => 
                          { "facet_queries" => {}, 
                            "facet_fields" =>
                              { "facet1" => [["val1", 1], ["val2", 2], ["val3", 3]], 
                                "facet2" => [["val4", 4], ["val5", 5], ["val6", 6]], 
                              }
                          } # facet_counts
                        }

    @solr_resp_no_docs = { "responseHeader" => 
                          { "status" => 0, 
                            "QTime" => 111, 
                            "params" => {"q"=>"nodocsmatchme", "wt"=>"ruby", "json.nl" => "arrarr"}
                          }, 
                        "response" =>
                          { "numFound" => 0, 
                            "start" => 0, 
                            "docs" => [] 
                          },
                        "facet_counts" => 
                          { "facet_queries" => {}, 
                            "facet_fields" =>
                              { "facet1" => [], 
                                "facet2" => [], 
                              }
                          }
                        } 
  end
  
  
  
end