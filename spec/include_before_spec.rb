require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "should include().before()" do
    
    it "passes when criteria are met" do
      @solr_resp_5_docs.should include("111").before("222")
      @solr_resp_5_docs.should include("333").before("fld"=>["val1", "val2", "val3"])
      @solr_resp_5_docs.should include("fld"=>"val").before("fld"=>["val1", "val2", "val3"])
      @solr_resp_5_docs.should include(["111", "222"]).before(["333", "555"])
      @solr_resp_5_docs.should include([{"id"=>"111"}, {"id"=>"333"}]).before([{"id"=>"444"}, {"id"=>"555"}])
    end
    it "passes when criteria CAN BE met (more than one option)" do
      @solr_resp_5_docs.should include("111").before("fld"=>"val")
    end
    it "fails when docs aren't in expected order" do
      expect {
        @solr_resp_5_docs.should include("222").before("fld2"=>"val2")
      }.to raise_error.with_message a_string_including 'expected response to include document "222" before document matching {"fld2"=>"val2"}'
      expect {
        @solr_resp_5_docs.should include("111", "444").before([{"id"=>"333"}, {"id"=>"555"}])
      }.to raise_error.with_message a_string_including 'expected response to include documents "111" and "444" before documents matching [{"id"=>"333"}, {"id"=>"555"}]'
      expect {
        @solr_resp_5_docs.should include([{"id"=>"222"}, {"id"=>"444"}]).before([{"id"=>"333"}, {"id"=>"555"}])
      }.to raise_error.with_message a_string_including 'expected response to include documents [{"id"=>"222"}, {"id"=>"444"}] before documents matching [{"id"=>"333"}, {"id"=>"555"}]'
    end
    it "fails when it can't find a doc matching first argument(s)" do
      expect {
        @solr_resp_5_docs.should include("not_there").before("555")
      }.to raise_error.with_message a_string_including 'expected response to include document "not_there" before document matching "555"'
    end
    it "fails when it can't find a doc matching second argument(s)" do
      expect {
        @solr_resp_5_docs.should include("222").before("not_there")
      }.to raise_error.with_message a_string_including 'expected response to include document "222" before document matching "not_there"'
    end
    it "fails when it can't find docs matching first or second argument(s)" do
      expect {
        @solr_resp_5_docs.should include("not_there").before("still_not_there")
      }.to raise_error.with_message a_string_including 'expected response to include document "not_there" before document matching "still_not_there"'
    end
    
  end # should include().before()
  
  
  context "should_NOT include().before()" do
    
    it "fails when criteria are met" do
      expect {
        @solr_resp_5_docs.should_not include("111").before("222")
      }.to raise_error.with_message a_string_including 'not to include document "111" before document matching "222"'
      expect {
        @solr_resp_5_docs.should_not include("333").before("fld"=>["val1", "val2", "val3"])
      }.to raise_error.with_message a_string_including 'not to include document "333" before document matching {"fld"=>["val1", "val2", "val3"]}'
      expect {
        @solr_resp_5_docs.should_not include("fld"=>"val").before("fld"=>["val1", "val2", "val3"])
      }.to raise_error.with_message a_string_including 'not to include document {"fld"=>"val"} before document matching {"fld"=>["val1", "val2", "val3"]}'
      expect {
        @solr_resp_5_docs.should_not include(["111", "222"]).before(["333", "555"])
      }.to raise_error.with_message a_string_including 'not to include documents ["111", "222"] before documents matching ["333", "555"]'
      expect {
        @solr_resp_5_docs.should_not include([{"id"=>"111"}, {"id"=>"333"}]).before([{"id"=>"444"}, {"id"=>"555"}])
      }.to raise_error.with_message a_string_including 'not to include documents [{"id"=>"111"}, {"id"=>"333"}] before documents matching [{"id"=>"444"}, {"id"=>"555"}]'
    end
    it "fails when criteria CAN BE met (more than one option)" do
      expect {
        @solr_resp_5_docs.should_not include("111").before("fld"=>"val")
      }.to raise_error.with_message a_string_including 'not to include document "111" before document matching {"fld"=>"val"}'
    end
    it "passes when docs aren't in expected order" do
        @solr_resp_5_docs.should_not include("222").before("fld2"=>"val2")
        # NOTE: it is picky about the next line include() being ["111", "444"], not just "111", "444"
        @solr_resp_5_docs.should_not include(["111", "444"]).before([{"id"=>"333"}, {"id"=>"555"}])
        @solr_resp_5_docs.should_not include([{"id"=>"222"}, {"id"=>"444"}]).before([{"id"=>"333"}, {"id"=>"555"}])
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