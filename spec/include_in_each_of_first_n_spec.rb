require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "#include().in_each_of_first(n)" do
    context "should" do
      it "passes when all docs in range meet criteria" do
        expect(@solr_resp).to include("fld" => "val").in_each_of_first(2)
        expect(@solr_resp).to include("fld" => "val").in_each_of_first(2).documents
        expect(@solr_resp).to include("fld" => "val").in_each_of_first(2).results
      end
      it "passes when all docs in range meet regex criteria" do
        expect(@solr_resp).to include("fld" => /val/).in_each_of_first(2)
        expect(@solr_resp).to include("fld" => /al/).in_each_of_first(2)
        expect(@solr_resp).to include("fld" => /Val/i).in_each_of_first(2)
      end
      it "fails when doc in range doesn't meet criteria" do
        expect {
          expect(@solr_resp).to include("fld2" => "val2").in_each_of_first(2)
        }.to raise_error.with_message a_string_including 'expected each of the first 2 documents to include {"fld2"=>"val2"}'
        expect {
          expect(@solr_resp).to include("fld" => "val").in_each_of_first(3)
        }.to raise_error.with_message a_string_including 'expected each of the first 3 documents to include {"fld"=>"val"}'
      end
      it "fails when doc in range doesn't meet regex criteria" do
        expect {
          expect(@solr_resp).to include("fld2" => /l2/).in_each_of_first(2)
        }.to raise_error.with_message a_string_including 'expected each of the first 2 documents to include {"fld2"=>/l2/}'
        expect {
          expect(@solr_resp).to include("fld" => /al/).in_each_of_first(3)
        }.to raise_error.with_message a_string_including 'expected each of the first 3 documents to include {"fld"=>/al/}'
      end
    end
    context "should_NOT" do
      it "fails when all docs in range meet criteria" do
        expect {
          expect(@solr_resp).not_to include("fld" => "val").in_each_of_first(2)
        }.to raise_error.with_message a_string_including 'expected some of the first 2 documents not to include {"fld"=>"val"}'
        expect {
          expect(@solr_resp).not_to include("fld" => "val").in_each_of_first(2).documents
        }.to raise_error.with_message a_string_including 'expected some of the first 2 documents not to include {"fld"=>"val"}'
        expect {
          expect(@solr_resp).not_to include("fld" => "val").in_each_of_first(2).results
        }.to raise_error.with_message a_string_including 'expected some of the first 2 documents not to include {"fld"=>"val"}'
      end
      it "fails when all docs in range meet regex criteria" do
        expect {
          expect(@solr_resp).not_to include("fld" => /val/).in_each_of_first(2)
        }.to raise_error.with_message a_string_including 'expected some of the first 2 documents not to include {"fld"=>/val/}'
        expect {
          expect(@solr_resp).not_to include("fld" => /al/).in_each_of_first(2)
        }.to raise_error.with_message a_string_including 'expected some of the first 2 documents not to include {"fld"=>/al/}'
        expect {
          expect(@solr_resp).not_to include("fld" => /Val/i).in_each_of_first(2)
        }.to raise_error.with_message a_string_including 'expected some of the first 2 documents not to include {"fld"=>/Val/i}'
      end
      it "passes when doc in range doesn't meet criteria" do
        expect(@solr_resp).not_to include("fld" => "val").in_each_of_first(3)
        expect(@solr_resp).not_to include("fld2" => "val2").in_each_of_first(2)
      end
      it "passes when doc in range doesn't meet regex criteria" do
        expect(@solr_resp).not_to include("fld2" => /l2/).in_each_of_first(2)
        expect(@solr_resp).not_to include("fld" => /al/).in_each_of_first(3)
      end
    end
    it "should expect a Hash for the include" do
      expect {
        expect(@solr_resp).to include("111").in_each_of_first(1)
      }.to raise_error(ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method")
      expect {
        expect(@solr_resp).to include(["111", "222"]).in_each_of_first(1)
      }.to raise_error(ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method")
      expect {
        expect(@solr_resp).not_to include("111").in_each_of_first(1)
      }.to raise_error(ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method")
      expect {
        expect(@solr_resp).to include("fld" => "val").in_each_of_first(1)
      }.to_not raise_error
      expect {
        expect(@solr_resp).to include({"fld" => "val", "fld2" => "val2"}).in_each_of_first(1)
      }.to_not raise_error
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