require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "should include().before()" do
    it "passes when criteria are met" do
      @solr_resp_5_docs.should include("111").before("222")
      @solr_resp_5_docs.should include("333").before("fld"=>["val1", "val2", "val3"])
      @solr_resp_5_docs.should include("fld"=>"val").before("fld"=>["val1", "val2", "val3"])
    end
    it "passes when criteria CAN BE met (more than one option)" do
# FIXME:  before first occurrence of??      
      @solr_resp_5_docs.should include("111").before("fld"=>"val")
    end
    it "fails when docs aren't in expected order" do
      lambda {
        @solr_resp_5_docs.should include("222").before("fld2"=>"val2")
      }.should fail_matching('before document(s) matching {"fld2"=>"val2"}')
    end
    it "fails when it can't find a doc matching first argument(s)" do
      lambda {
        @solr_resp_5_docs.should include("not_there").before("555")
        }.should fail_matching('before document(s) matching "555"')
    end
    it "fails when it can't find a doc matching second argument(s)" do
      lambda {
        @solr_resp_5_docs.should include("222").before("not_there")
        }.should fail_matching('before document(s) matching "not_there"')
    end
    it "fails when it can't find docs matching first or second argument(s)" do
      lambda {
        @solr_resp_5_docs.should include("not_there").before("still_not_there")
        }.should fail_matching('before document(s) matching "still_not_there"')
    end
  end # should include().before()
  context "should_NOT include().before()" do
    
  end # should_NOT include().before()
  
  before(:all) do
    @solr_resp_5_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 5, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111", "fld"=>"val", "fld2"=>"val2"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333", "fld"=>"val"}, 
                                {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                {"id"=>"555"}
                              ]
                          }
                        })
  end
  
end