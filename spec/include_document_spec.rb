require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
# FIXME:  YOU ARE HERE!!!   You are about to re-org this so it's more compact and clear  
  
  context "RSpecSolr::SolrResponseHash #include matcher" do
    
    context "should include('fldname'=>'fldval')" do

      it "passes if Solr document in response contains 'fldval' in named field" do
        @solr_resp_5_docs.should include("id" => "111")
        @solr_resp_5_docs.should include("fld" => "val")  # 2 docs match 
      end
      
      it "passes if single value expectation is expressed as an Array" do
        @solr_resp_5_docs.should include("id" => ["111"])
      end
      
      it "fails if no Solr document in response has 'fldval' for the named field" do
        lambda {
          @solr_resp_5_docs.should have_document("id" => "not_there")
        }.should fail
      end
      
      it "fails if no Solr document in response has the named field" do
        lambda {
          @solr_resp_5_docs.should have_document("not_there" => "anything")
        }.should fail
      end
    end # "should include('fldname'=>'fldval')"

    context "should_NOT include('fldname'=>'fldval')" do

      it "fails if Solr document in response contains 'fldval' in named field" do
        lambda {
          @solr_resp_5_docs.should_not include("id" => "111")
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include("id" => "111", "fld" => "val")
        }.should fail
        lambda {
          @solr_resp_5_docs.should_not include("fld" => "val") 
        }.should fail
      end
      
      it "passes if no Solr document in response has 'fldval' for the named field" do
          @solr_resp_5_docs.should_not have_document({"id" => "not_there"})
      end
      
      it "passes if no Solr document in response has the named field" do
          @solr_resp_5_docs.should_not have_document({"not_there" => "anything"})
      end
      
      it "passes if single field value is expressed as Array" do
        @solr_resp_5_docs.should_not have_document({"id" => ["not_there"]})
      end
    end # "should_not include('fldname'=>'fldval')"

    context "should include('fld1'=>'val1', 'fld2'=>'val2')" do

      it "passes if all pairs are included in a Solr document in the response" do
        @solr_resp_5_docs.should include("id" => "111", "fld" => "val")
        @solr_resp_5_docs.should include("id" => "333", "fld" => "val")
      end
      
      it "fails if only part of expectation is met" do
        lambda {
          @solr_resp_5_docs.should include("id" => "111", "fld" => "not_there")
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("id" => "111", "not_there" => "whatever")
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("id" => "222", "fld" => "val")
        }.should fail
      end
      
      it "fails if no part of expectation is met" do
        lambda {
          @solr_resp_5_docs.should include("id" => "not_there", "not_there" => "anything")
        }.should fail
      end
    end # should include('fld1'=>'val1', 'fld2'=>'val2')

    context "should_NOT include('fld1'=>'val1', 'fld2'=>'val2')" do

      it "fails if a Solr document in the response contains all the key/value pairs" do
        lambda {
          @solr_resp_5_docs.should_not include("id" => "333", "fld" => "val")
        }.should fail
      end
      
      it "passes if a Solr document in the response contains all the key/value pairs among others" do
        lambda {
          @solr_resp_5_docs.should_not include("id" => "111", "fld" => "val")
        }.should fail
      end
      
      it "fails if part of the expectation is met" do
        lambda {
          @solr_resp_5_docs.should include("id" => "111", "fld" => "not_there")
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("id" => "111", "not_there" => "whatever")
        }.should fail
        lambda {
          @solr_resp_5_docs.should include("id" => "222", "fld" => "val")
        }.should fail
      end
      
      it "passes if no part of the expectatio is met" do
        @solr_resp_5_docs.should_not include("id" => "not_there", "not_there" => "anything")
      end
    end # should_not include('fld1'=>'val1', 'fld2'=>'val2')
    
    
    context "multi-valued fields and expectations" do
      
      context "should include(doc_exp)" do
        it "passes if all the expected values match all the values in a Solr document in the response" do
          @solr_resp_5_docs.should have_document("fld" => ["val1", "val2", "val3"])
          @solr_resp_5_docs.should have_document("fld" => ["val1", "val2", "val3"], "id" => "444")
        end

        it "passes if all the expected values match some of the values in a Solr document in the response" do
          @solr_resp_5_docs.should have_document("fld" => ["val1", "val2"])
          @solr_resp_5_docs.should have_document("fld" => "val1")
          @solr_resp_5_docs.should have_document("fld" => ["val1", "val2"], "id" => "444")
        end

        it "fails if none of the expected values match the values in a Solr document in the response" do
          lambda {
            @solr_resp_5_docs.should have_document("fld" => ["not_there", "also_not_there"])
          }.should fail
        end

        it "fails if only some of the expected values match the values in a Solr document in the response" do
          lambda {
            @solr_resp_5_docs.should have_document("fld" => ["val1", "val2", "not_there"])
          }.should fail
        end
      end # should
      
      context "should_NOT include(doc_exp)" do
        it "fails if all the expected values match all the values in a Solr document in the response" do
          lambda {
            @solr_resp_5_docs.should_not have_document("fld" => ["val1", "val2", "val3"])
          }.should fail
          lambda {
            @solr_resp_5_docs.should_not have_document("fld" => ["val1", "val2", "val3"], "id" => "444")
          }.should fail
        end
        
        it "fails if all the expected values match some of the values in a Solr document in the response" do
          lambda {
            @solr_resp_5_docs.should_not have_document("fld" => ["val1", "val2"])
          }.should fail
          lambda {
            @solr_resp_5_docs.should_not have_document("fld" => "val1")
          }.should fail
          lambda {
            @solr_resp_5_docs.should_not have_document("fld" => ["val1", "val2"], "id" => "444")
          }.should fail
        end
        
        it "passes if none of the expected values match the values in a Solr document in the response" do
          @solr_resp_5_docs.should_not have_document("fld" => ["not_there", "also_not_there"])
          @solr_resp_5_docs.should_not have_document("fld" => ["not_there", "also_not_there"], "id" => "444")
        end
        
        it "passes if only some of the expected values match the values in a Solr document in the response" do
          @solr_resp_5_docs.should_not have_document("fld" => ["val1", "val2", "not_there"])
          @solr_resp_5_docs.should_not have_document("fld" => ["val1", "val2", "not_there"], "id" => "444")
        end
        
      end # should_not    
  
    end # multi-valued fields in docs
    
    
    context "should include(single_string_arg)" do
      it "does something" do
        pending "to be implemented"
      end
    end
    
    context "should include(:key => [val1, val2, val3])" do
      it "does something" do
        pending "to be implemented"
      end
    end
    
    context 'should include(:key => "/regex/")' do
      it "does something" do
        pending "to be implemented"
      end
    end


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


    context "shouldn't break RSpec #include matcher" do
      it "for String" do
        "abc".should include("a")
        "abc".should_not include("d")
      end

      it "for Array" do
        [1,2,3].should include(3)
        [1,2,3].should include(2,3)
        [1,2,3].should_not include(4)
        lambda {
          [1,2,3].should include(1,666)
        }.should fail
        lambda {
          [1,2,3].should_not include(1,666)
        }.should fail
      end

      it "for Hash" do
        {:key => 'value'}.should include(:key)
        {:key => 'value'}.should_not include(:key2)
        lambda {
          {:key => 'value'}.should include(:key, :other)
        }.should fail
        lambda {
          {:key => 'value'}.should_not include(:key, :other)
        }.should fail
        {'key' => 'value'}.should include('key')
        {'key' => 'value'}.should_not include('key2')
      end
    end # context shouldn't break RSpec #include matcher
    
  end # context RSpecSolr::SolrResponseHash #include matcher
  
end