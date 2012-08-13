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
      }.should fail_matching('} to include document "222" before document matching {"fld2"=>"val2"}')
    end
    it "fails when it can't find a doc matching first argument(s)" do
      lambda {
        @solr_resp_5_docs.should include("not_there").before("555")
      }.should fail_matching('} to include document "not_there" before document matching "555"')
    end
    it "fails when it can't find a doc matching second argument(s)" do
      lambda {
        @solr_resp_5_docs.should include("222").before("not_there")
      }.should fail_matching('} to include document "222" before document matching "not_there"')
    end
    it "fails when it can't find docs matching first or second argument(s)" do
      lambda {
        @solr_resp_5_docs.should include("not_there").before("still_not_there")
      }.should fail_matching('} to include document "not_there" before document matching "still_not_there"')
    end
  end # should include().before()
  context "should_NOT include().before()" do
    it "fails when criteria are met" do
      lambda {
        @solr_resp_5_docs.should_not include("111").before("222")
      }.should fail_matching('not to include document "111" before document matching "222"')
      lambda {
        @solr_resp_5_docs.should_not include("333").before("fld"=>["val1", "val2", "val3"])
      }.should fail_matching('not to include document "333" before document matching {"fld"=>["val1", "val2", "val3"]}')
      lambda {
        @solr_resp_5_docs.should_not include("fld"=>"val").before("fld"=>["val1", "val2", "val3"])
      }.should fail_matching('not to include document {"fld"=>"val"} before document matching {"fld"=>["val1", "val2", "val3"]}')
    end
    it "fails when criteria CAN BE met (more than one option)" do
      lambda {
        @solr_resp_5_docs.should_not include("111").before("fld"=>"val")
      }.should fail_matching('not to include document "111" before document matching {"fld"=>"val"}')
    end
    it "passes when docs aren't in expected order" do
        @solr_resp_5_docs.should_not include("222").before("fld2"=>"val2")
    end
    it "passes when it can't find a doc matching first argument(s)" do
      @solr_resp_5_docs.should_not include("not_there").before("555")
    end
    it "passes when it can't find a doc matching second argument(s)" do
      @solr_resp_5_docs.should_not include("222").before("not_there")
    end
    it "passes when it can't find docs matching first or second argument(s)" do
      @solr_resp_5_docs.should_not include("not_there").before("still_not_there")
    end
    
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