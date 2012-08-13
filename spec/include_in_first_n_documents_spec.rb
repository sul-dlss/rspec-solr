require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "#include().in_first(n)" do
    context "should include().in_first(n)" do
      it "passes when include arg is String and doc meets criteria" do
        @solr_resp_5_docs.should include("222").in_first(3)
        @solr_resp_5_docs.should include("111").in_first(1)
        @solr_resp_5_docs.should include("222").in_first(2)
      end
      it "fails when include arg is String but doc comes too late" do
        lambda {
          @solr_resp_5_docs.should include("222").in_first(1)
        }.should fail
      end
      it "passes when include arg is Hash and doc meets criteria" do
        @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"]).in_first(4)
      end
      it "fails when include arg is Hash but doc comes too late" do
        lambda {
          @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"]).in_first(2)
        }.should fail
      end
      it "passes when include arg is Array and all docs meet criteria" do
        @solr_resp_5_docs.should include(["111", "222"]).in_first(2)
        @solr_resp_5_docs.should include(["333", {"fld2"=>"val2"}]).in_first(4)
      end
      it "fails when include arg is Array but at least one doc comes too late" do
        lambda {
          @solr_resp_5_docs.should include(["111", "444"]).in_first(2)
        }.should fail
        lambda {
          @solr_resp_5_docs.should include(["333", {"fld2"=>"val2"}]).in_first(2)
        }.should fail
      end
      it "fails when there is no matching result" do
        lambda {        
          @solr_resp_5_docs.should include("666").in_first(6)
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("fld"=>"not there").in_first(3)
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("666", "777").in_first(6)
        }.should fail
      end
    end # should include().in_first(n)

    context "should_NOT include().in_first(n)" do
      it "fails when include arg is String and doc meets criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("222").in_first(2)
        }.should fail
      end
      it "passes when include arg is String but doc comes too late" do
        @solr_resp_5_docs.should_not include("222").in_first(1)
      end
      it "fails when include arg is Hash and doc meets criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"]).in_first(4)
        }.should fail
      end
      it "passes when include arg is Hash but doc comes too late" do
        @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"]).in_first(2)
      end
      it "fails when include arg is Array and all docs meet criteria" do
        lambda {
          @solr_resp_5_docs.should_not include(["111", "222"]).in_first(2)
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include(["333", {"fld2"=>"val2"}]).in_first(4)
        }.should fail
      end
      it "passes when include arg is Array but at least one doc comes too late" do
        @solr_resp_5_docs.should_not include(["111", "444"]).in_first(2)
        @solr_resp_5_docs.should_not include(["333", {"fld2"=>"val2"}]).in_first(2)
      end
      it "passes when there is no matching result" do
        @solr_resp_5_docs.should_not include("666").in_first(6)
        @solr_resp_5_docs.should_not include("fld"=>"not there").in_first(3)
        @solr_resp_5_docs.should_not include("666", "777").in_first(6)
      end      
    end # should_NOT include().in_first(n)    
  end # include().in_first(n)
  
  context "#include().in_first (no n set) implies n=1" do
    context "should #include().in_first" do
      it "passes when matching document is first" do
        @solr_resp_5_docs.should include("111").in_first
      end
      it "fails when matching document is not first" do
        lambda {
          @solr_resp_5_docs.should include("fld"=>["val1", "val2", "val3"]).in_first
        }.should fail
      end
    end
    context "should_NOT include().in_first" do
      it "fails when matching document is first" do
        lambda {
          @solr_resp_5_docs.should_not include("111").in_first
        }.should fail
      end
      it "passes when matching document is not first" do
        @solr_resp_5_docs.should_not include("fld"=>["val1", "val2", "val3"]).in_first
      end
    end
  end # include().in_first (no n set)
  
  context "#include().in_first(n).any_chained.names" do
    context "should #include().in_first(n).any_chained.names" do
      it "passes when document(s) meet criteria" do
        @solr_resp_5_docs.should include("222").in_first(2).results
        @solr_resp_5_docs.should include("222").in_first(2).documents
        @solr_resp_5_docs.should include("222").in_first(2).solr.documents
        @solr_resp_5_docs.should include("fld2"=>"val2").in_first.solr.document
      end
      it "fails when document(s) don't meet criteria" do
        lambda {
          @solr_resp_5_docs.should include("fld"=>["val1", "val2", "val3"]).in_first.result
        }.should fail
      end
    end
    context "should_NOT #include().in_first(n).any_chained.names" do
      it "fails when document(s) meet criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("222").in_first(2).solr.documents
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include("fld2"=>"val2").in_first.solr.document
        }.should fail
      end
      it "passes when document(s) don't meet criteria" do
        @solr_resp_5_docs.should_not include("fld"=>["val1", "val2", "val3"]).in_first.result
      end
    end
  end # include().in_first().any_chained_names
  
  context "#include().as_first" do
    context "should include().as_first" do
      it "passes when the first document meets the criteria" do
        @solr_resp_5_docs.should include("111").as_first
        @solr_resp_5_docs.should include("fld"=>"val").as_first
        @solr_resp_5_docs.should include("fld"=>"val", "fld2"=>"val2").as_first
      end
      it "fails when a document meets the criteria but is not the first" do
        lambda {
          @solr_resp_5_docs.should include("222").as_first
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"]).as_first
        }.should fail
      end
      it "fails when there is no matching result" do
        lambda {
          @solr_resp_5_docs.should include("96").as_first
        }.should fail
      end    
    end
    context "should_NOT include().as_first" do
      it "fails when the first document meets the criteria" do
        lambda {
          @solr_resp_5_docs.should_not include("111").as_first
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include("fld"=>"val").as_first
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include("fld"=>"val", "fld2"=>"val2").as_first
        }.should fail
      end
      it "passes when a document meets the criteria but is not the first" do
        @solr_resp_5_docs.should_not include("222").as_first.document
        @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"]).as_first
      end
      it "passes when there is no matching result" do
        @solr_resp_5_docs.should_not include("96").as_first
      end    
    end
  end
  
  
  context "#include().as_first().any_chained.names" do
    context "should #include().as_first(n).any_chained.names" do
      it "passes when document(s) meet criteria" do
        @solr_resp_5_docs.should include(["111", "222"]).as_first(2).results
        @solr_resp_5_docs.should include(["111", "222"]).as_first(2).solr.documents
        @solr_resp_5_docs.should include("fld2"=>"val2").as_first.solr.document
      end
      it "fails when document(s) don't meet criteria" do
        lambda {
          @solr_resp_5_docs.should include("fld"=>["val1", "val2", "val3"]).as_first.result
        }.should fail
      end
    end
    context "should_NOT #include().as_first(n).any_chained.names" do
      it "fails when document(s) meet criteria" do
        lambda {
          @solr_resp_5_docs.should_not include(["111", "222"]).as_first(2).solr.documents
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include("fld2"=>"val2").as_first.solr.document
        }.should fail
      end
      it "passes when document(s) don't meet criteria" do
        @solr_resp_5_docs.should_not include("fld"=>["val1", "val2", "val3"]).as_first.result
      end
    end
  end # include().as_first().any_chained_names

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