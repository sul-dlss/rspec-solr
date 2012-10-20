require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "#include().in_each_of_first(n)" do
    context "should" do
      it "passes when all docs in range meet criteria" do
        @solr_resp.should include("fld" => "val").in_each_of_first(2)
        @solr_resp.should include("fld" => "val").in_each_of_first(2).documents
        @solr_resp.should include("fld" => "val").in_each_of_first(2).results
      end
      it "fails when doc in range doesn't meet criteria" do
        lambda {
          @solr_resp.should include("fld2" => "val2").in_each_of_first(2)
        }.should fail_matching('expected each of the first 2 documents to include {"fld2"=>"val2"}')
        lambda {
          @solr_resp.should include("fld" => "val").in_each_of_first(3)
        }.should fail_matching('expected each of the first 3 documents to include {"fld"=>"val"}')
      end
    end
    context "should_NOT" do
      it "fails when all docs in range meet criteria" do
        lambda {
          @solr_resp.should_not include("fld" => "val").in_each_of_first(2)
        }.should fail_matching('expected some of the first 2 documents not to include {"fld"=>"val"}')
        lambda {
          @solr_resp.should_not include("fld" => "val").in_each_of_first(2).documents
        }.should fail_matching('expected some of the first 2 documents not to include {"fld"=>"val"}')
        lambda {
          @solr_resp.should_not include("fld" => "val").in_each_of_first(2).results
        }.should fail_matching('expected some of the first 2 documents not to include {"fld"=>"val"}')
      end
      it "passes when doc in range doesn't meet criteria" do
        @solr_resp.should_not include("fld" => "val").in_each_of_first(3)
        @solr_resp.should_not include("fld2" => "val2").in_each_of_first(2)
      end
    end
    it "should expect a Hash for the include" do
      expect {
        @solr_resp.should include("111").in_each_of_first(1)
      }.to raise_error(ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method")
      expect {
        @solr_resp.should include(["111", "222"]).in_each_of_first(1)
      }.to raise_error(ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method")
      expect {
        @solr_resp.should_not include("111").in_each_of_first(1)
      }.to raise_error(ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method")
      expect {
        @solr_resp.should include("fld" => "val").in_each_of_first(1)
      }.to_not raise_error(ArgumentError)
      expect {
        @solr_resp.should include({"fld" => "val", "fld2" => "val2"}).in_each_of_first(1)
      }.to_not raise_error(ArgumentError)
    end
  end
    
  before(:all) do
    @solr_resp = RSpecSolr::SolrResponseHash.new({ "response" =>
                    { "numFound" => 5, 
                      "start" => 0, 
                      "docs" => 
                        [ {"id"=>"111", "fld"=>"val", "fld2"=>"val2"}, 
                          {"id"=>"222", "fld"=>"val"}, 
                          {"id"=>"333"}, 
                          {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                          {"id"=>"555"}
                        ]
                    }
                  })
  end
  
end