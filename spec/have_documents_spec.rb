require 'rspec-solr'

describe RSpecSolr do
  before(:all) do
    @solr_resp = { "responseHeader" => 
                    { "status" => 0, 
                      "QTime" => 111, 
                      "params" => {"q"=>"foo", "wt"=>"ruby"}
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
                        { "facet1" => [ "val1", 1, "val2", 2, "val3", 3], 
                          "facet2" => [ "val4", 4, "val5", 5, "val6", 6], 
                        }
                    } # facet_counts
                  }
  end

  
  it "have_results matcher" do
    @solr_resp.should have_documents
  end
  
end