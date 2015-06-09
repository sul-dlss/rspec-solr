require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
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
        expect {
          @solr_resp_5_docs.should include("id" => "not_there")
        }.to raise_error.with_message a_string_including '} to include {"id" => "not_there"}'
      end
      it "fails if no Solr document in response has the named field" do
        expect {
          @solr_resp_5_docs.should include("not_there" => "anything")
        }.to raise_error.with_message a_string_including '} to include {"not_there" => "anything"}'
      end
    end # "should include('fldname'=>'fldval')"

    context "should_NOT include('fldname'=>'fldval')" do

      it "fails if Solr document in response contains 'fldval' in named field" do
        expect {
          @solr_resp_5_docs.should_not include("id" => "111")
        }.to raise_error.with_message a_string_including 'not to include {"id" => "111"}'
        expect {
          @solr_resp_5_docs.should_not include("fld" => "val") 
        }.to raise_error.with_message a_string_including 'not to include {"fld" => "val"}'
      end
      it "passes if no Solr document in response has 'fldval' for the named field" do
          @solr_resp_5_docs.should_not include({"id" => "not_there"})
      end
      it "passes if no Solr document in response has the named field" do
          @solr_resp_5_docs.should_not include({"not_there" => "anything"})
      end
      it "passes if single field value is expressed as Array" do
        @solr_resp_5_docs.should_not include({"id" => ["not_there"]})
      end
    end # "should_not include('fldname'=>'fldval')"

    context "should include('fld1'=>'val1', 'fld2'=>'val2')" do

      it "passes if all pairs are included in a Solr document in the response" do
        @solr_resp_5_docs.should include("id" => "111", "fld" => "val")
        @solr_resp_5_docs.should include("id" => "333", "fld" => "val")
      end
      it "fails if only part of expectation is met" do
        expect {
          @solr_resp_5_docs.should include("id" => "111", "fld" => "not_there")
        }.to raise_error.with_message a_string_including '} to include {"id" => "111", "fld" => "not_there"}'
        expect {
          @solr_resp_5_docs.should include("id" => "111", "not_there" => "whatever")
        }.to raise_error.with_message a_string_including '} to include {"id" => "111", "not_there" => "whatever"}'
        expect {
          @solr_resp_5_docs.should include("id" => "222", "fld" => "val")
        }.to raise_error.with_message a_string_including '} to include {"id" => "222", "fld" => "val"}'
      end
      it "fails if no part of expectation is met" do
        expect {
          @solr_resp_5_docs.should include("id" => "not_there", "not_there" => "anything")
        }.to raise_error.with_message a_string_including '} to include {"id" => "not_there", "not_there" => "anything"}'
      end
    end # should include('fld1'=>'val1', 'fld2'=>'val2')

    context "should_NOT include('fld1'=>'val1', 'fld2'=>'val2')" do

      it "fails if a Solr document in the response contains all the key/value pairs" do
        expect {
          @solr_resp_5_docs.should_not include("id" => "333", "fld" => "val")
        }.to raise_error.with_message a_string_including 'not to include {"id" => "333", "fld" => "val"}'
      end
      it "passes if a Solr document in the response contains all the key/value pairs among others" do
        expect {
          @solr_resp_5_docs.should_not include("id" => "111", "fld" => "val")
          }.to raise_error.with_message a_string_including 'not to include {"id" => "111", "fld" => "val"}'
      end
      it "passes if part of the expectation is not met" do
        @solr_resp_5_docs.should_not include("id" => "111", "fld" => "not_there")
        @solr_resp_5_docs.should_not include("id" => "111", "not_there" => "whatever")
        @solr_resp_5_docs.should_not include("id" => "222", "fld" => "val")
      end
      it "passes if no part of the expectatio is met" do
        @solr_resp_5_docs.should_not include("id" => "not_there", "not_there" => "anything")
      end
    end # should_not include('fld1'=>'val1', 'fld2'=>'val2')    
    
    context "multi-valued fields and expectations" do
      
      context "should include(doc_exp)" do
        it "passes if all the expected values match all the values in a Solr document in the response" do
          @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"])
          @solr_resp_5_docs.should include("fld" => ["val1", "val2", "val3"], "id" => "444")
        end
        it "passes if all the expected values match some of the values in a Solr document in the response" do
          @solr_resp_5_docs.should include("fld" => ["val1", "val2"])
          @solr_resp_5_docs.should include("fld" => "val1")
          @solr_resp_5_docs.should include("fld" => ["val1", "val2"], "id" => "444")
        end
        it "fails if none of the expected values match the values in a Solr document in the response" do
          expect {
            @solr_resp_5_docs.should include("fld" => ["not_there", "also_not_there"])
            }.to raise_error.with_message a_string_including '} to include {"fld" => ["not_there", "also_not_there"]}'
        end
        it "fails if only some of the expected values match the values in a Solr document in the response" do
          expect {
            @solr_resp_5_docs.should include("fld" => ["val1", "val2", "not_there"])
            }.to raise_error.with_message a_string_including '} to include {"fld" => ["val1", "val2", "not_there"]}'
        end
      end # should
      
      context "should_NOT include(doc_exp)" do
        it "fails if all the expected values match all the values in a Solr document in the response" do
          expect {
            @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"])
          }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2", "val3"]}'
          expect {
            @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "val3"], "id" => "444")
            }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2", "val3"], "id" => "444"}'
        end
        it "fails if all the expected values match some of the values in a Solr document in the response" do
          expect {
            @solr_resp_5_docs.should_not include("fld" => ["val1", "val2"])
          }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2"]}'
          expect {
            @solr_resp_5_docs.should_not include("fld" => "val1")
            }.to raise_error.with_message a_string_including 'not to include {"fld" => "val1"}'
          expect {
            @solr_resp_5_docs.should_not include("fld" => ["val1", "val2"], "id" => "444")
            }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2"], "id" => "444"}'
        end
        it "passes if none of the expected values match the values in a Solr document in the response" do
          @solr_resp_5_docs.should_not include("fld" => ["not_there", "also_not_there"])
          @solr_resp_5_docs.should_not include("fld" => ["not_there", "also_not_there"], "id" => "444")
        end
        it "passes if only some of the expected values match the values in a Solr document in the response" do
          @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "not_there"])
          @solr_resp_5_docs.should_not include("fld" => ["val1", "val2", "not_there"], "id" => "444")
        end
      end # should_not    
  
    end # multi-valued fields in docs
    
    
    context "single String argument" do
      
      context "should include(single_string_arg)" do
        it "passes if string matches default id_field of Solr document in the response" do
          @solr_resp_5_docs.should include('111')
        end
        it "passes if string matches non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          my_srh.should include('val2')
        end
        it "fails if string does not match default id_field of Solr document in the response" do
          expect {
            @solr_resp_5_docs.should include('666')
            }.to raise_error.with_message a_string_including '} to include "666"'
        end
        it "fails if string doesn't match non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            my_srh.should include('val')
          }.to raise_error.with_message a_string_including '} to include "val"'
        end    
      end # should

      context "should_NOT include(single_string_arg)" do
        it "fails if string matches default id_field of Solr document in the response" do
          expect {
            @solr_resp_5_docs.should_not include('111')
          }.to raise_error.with_message a_string_including 'not to include "111"'
        end
        it "fails if string matches non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            my_srh.should_not include('val2')
          }.to raise_error.with_message a_string_including 'not to include "val2"'
        end
        it "passes if string does not match default id_field of Solr document in the response" do
          @solr_resp_5_docs.should_not include('666')
        end
        it "fails if string doesn't match non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          my_srh.should_not include('val')
        end    
      end # should_not
      
    end # single String arg

    context "Array argument" do
      
      context "should include(Array_of_Strings)" do
        it "passes if all Strings in Array match all Solr documents' id_field in the response" do
          @solr_resp_5_docs.should include(["111", "222", "333", "444", "555"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          my_srh.should include(["val2"])
        end
        it "passes if all Strings in Array match some Solr documents' id_field in the response" do
          @solr_resp_5_docs.should include(["111", "222", "333"])
          @solr_resp_5_docs.should include(["111"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld'
          my_srh.should include(["val"])
        end
        it "fails if no Strings in Array match Solr documents' id_field in the response" do
          expect {
            @solr_resp_5_docs.should include(["888", "899"])
          }.to raise_error.with_message a_string_including '} to include ["888", "899"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            my_srh.should include(["val8", "val9"])
          }.to raise_error.with_message a_string_including '} to include ["val8", "val9"]'
        end
        it "fails if only some Strings in Array match Solr documents' id_field in the response" do
          expect {
            @solr_resp_5_docs.should include(["111", "222", "999"])
          }.to raise_error.with_message a_string_including '} to include ["111", "222", "999"]'
          expect {
            @solr_resp_5_docs.should include(["666", "555"])
          }.to raise_error.with_message a_string_including '} to include ["666", "555"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            my_srh.should include(["val2", "val9"])
          }.to raise_error.with_message a_string_including '} to include ["val2", "val9"]'
        end
      end # should include(Array_of_Strings)
      
      context "should_NOT include(Array_of_Strings)" do
        it "fails if all Strings in Array match all Solr documents' id_field in the response" do
          expect {
            @solr_resp_5_docs.should_not include(["111", "222", "333", "444", "555"])
          }.to raise_error.with_message a_string_including 'not to include ["111", "222", "333", "444", "555"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            my_srh.should_not include(["val2"])
          }.to raise_error.with_message a_string_including 'not to include ["val2"]'
        end
        it "fails if all Strings in Array match some Solr documents' id_field in the response" do
          expect {
            @solr_resp_5_docs.should_not include(["111", "222", "333"])
          }.to raise_error.with_message a_string_including 'not to include ["111", "222", "333"]'
          expect {
            @solr_resp_5_docs.should_not include(["111"])
          }.to raise_error.with_message a_string_including 'not to include ["111"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld'
          expect {
            my_srh.should_not include(["val"])
          }.to raise_error.with_message a_string_including 'not to include ["val"]'
        end
        it "passes if no Strings in Array match Solr documents' id_field in the response" do
          @solr_resp_5_docs.should_not include(["888", "899"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          my_srh.should_not include(["val8", "val9"])
        end
        it "passes if only some Strings in Array match Solr documents' id_field in the response" do
          @solr_resp_5_docs.should_not include(["111", "222", "999"])
          @solr_resp_5_docs.should_not include(["666", "555"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          my_srh.should_not include(["val2", "val9"])
        end
      end # should_not include(Array_of_Strings)
      
      context "should include(Array_of_Hashes)" do
        it "passes if all Hashes in Array match all Solr documents in the response" do
          @solr_resp_5_docs.should include([{"id"=>"111", "fld"=>/val/, "fld2"=>"val2"}, 
                                            {"id"=>"222"}, 
                                            {"id"=>"333", "fld"=>"val"}, 
                                            {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                            {"id"=>"555"}])
          @solr_resp_5_docs.should include([{"id"=>"111"}, {"id"=>"222"}, {"id"=>"333"}, {"id"=>"444"}, {"id"=>"555"}])
        end
        it "passes if all Hashes in Array match some Solr documents in the response" do
          @solr_resp_5_docs.should include([{"id"=>"333", "fld"=>"val"}, {"id"=>"111", "fld2"=>"val2"}])
          @solr_resp_5_docs.should include([{"fld"=>"val"}])
        end
        it "fails if no Hashes in Array match Solr documents in the response" do
          expect {
            @solr_resp_5_docs.should include([{"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
          }.to raise_error.with_message a_string_including '} to include [{"foo" => "bar"}, {"bar" => "food", "mmm" => "food"}]'
        end
        it "fails if only some Hashes in Array match Solr documents in the response" do
          expect {
            @solr_resp_5_docs.should include([{"id"=>"222"}, {"id"=>"333", "fld"=>"val"}, {"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
          }.to raise_error.with_message a_string_including '} to include [{"id" => "222"},'
        end
      end # should include(Array_of_Hashes)

      context "should_NOT include(Array_of_Hashes)" do
        it "fails if all Hashes in Array match all Solr documents in the response" do
          expect {
            @solr_resp_5_docs.should_not include([{"id"=>"111", "fld"=>"val", "fld2"=>"val2"}, 
                                            {"id"=>"222"}, 
                                            {"id"=>"333", "fld"=>"val"}, 
                                            {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                            {"id"=>"555"}])
          }.to raise_error.with_message a_string_including 'not to include [{"id" => "111",'
          expect {
            @solr_resp_5_docs.should_not include([{"id"=>"111"}, {"id"=>"222"}, {"id"=>"333"}, {"id"=>"444"}, {"id"=>"555"}])
          }.to raise_error.with_message a_string_including 'not to include [{"id" => "111"},'
        end
        it "fails if all Hashes in Array match some Solr documents in the response" do
          expect {
            @solr_resp_5_docs.should_not include([{"id"=>"333", "fld"=>"val"}, {"id"=>"111", "fld2"=>"val2"}])
          }.to raise_error.with_message a_string_including 'not to include [{"id" => "333",'
          expect {
            @solr_resp_5_docs.should_not include([{"fld"=>"val"}])
          }.to raise_error.with_message a_string_including ' not to include [{"fld" => "val"}]'
        end
        it "passes if no Hashes in Array match Solr documents in the response" do
          @solr_resp_5_docs.should_not include([{"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
        end
        it "passes if only some Hashes in Array match Solr documents in the response" do
          @solr_resp_5_docs.should_not include([{"id"=>"222"}, {"id"=>"333", "fld"=>"val"}, {"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
        end
        
      end # should_not include(Array_of_Hashes)

      context "mixed Array of Strings and Hashes" do
        it "passes if all elements of Array pass" do
          @solr_resp_5_docs.should include([ "222", {"id"=>"111", "fld"=>"val"}, "555"  ])
        end
        it "fails if any element of Array fails" do
          expect {
            @solr_resp_5_docs.should include([ "not_there", {"id"=>"111", "fld"=>"val"}, "555"  ])
          }.to raise_error.with_message a_string_including '} to include ['
          expect {
            @solr_resp_5_docs.should include([ "222", {"id"=>"111", "not"=>"there"}, "555"  ])
          }.to raise_error.with_message a_string_including '} to include ['
        end
      end
      
      it "should allow #have_documents as alternative to #include" do
        @solr_resp_5_docs.should have_documents(["111", "222", "333"])
      end
      
    end # Array argument

    
    context "regex value" do

      context "should include('fld' => /regex/)" do
        it "passes if Solr document in response matches regex in named field" do
          @solr_resp_5_docs.should include("id" => /\d{3}/)
          @solr_resp_5_docs.should include("fld" => /^va/)  # 2 docs match 
          @solr_resp_5_docs.should include("fld" => /Va/i)  # 2 docs match 
        end
        it "passes if single value expectation is expressed as an Array" do
          @solr_resp_5_docs.should include("id" => [/111/])
        end
        it "fails if no Solr document in response has 'fldval' for the named field" do
          expect {
            @solr_resp_5_docs.should include("id" => /not there/)
          }.to raise_error.with_message a_string_including '} to include {"id" => /not there/}'
        end
        it "fails if no Solr document in response has the named field" do
          expect {
            @solr_resp_5_docs.should include("not_there" => /anything/)
            }.to raise_error.with_message a_string_including '} to include {"not_there" => /anything/}'
        end
      end # should include('fld' => /regex/)

      context "should_NOT include('fld' => /regex/)" do
        it "fails if Solr document in response matches regex in named field" do
          expect {
            @solr_resp_5_docs.should_not include("id" => /\d{3}/)
          }.to raise_error.with_message a_string_including 'not to include {"id" => /\d{3}/}'
          expect {
            @solr_resp_5_docs.should_not include("fld" => /^va/) 
          }.to raise_error.with_message a_string_including 'not to include {"fld" => /^va/}'
        end
        it "passes if no Solr document in response has 'fldval' for the named field" do
            @solr_resp_5_docs.should_not include({"id" => /not there/})
        end
        it "passes if no Solr document in response has the named field" do
            @solr_resp_5_docs.should_not include({"not_there" => /anything/})
        end
        it "passes if single field value is expressed as Array" do
          @solr_resp_5_docs.should_not include({"id" => [/not there/]})
        end

      end # should_NOT include('fld' => /regex/)

    end # regex value


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
        expect {
          [1,2,3].should include(1,666)
        }.to raise_error a_string_including 'to include 1 and 666'
        expect {
          [1,2,3].should_not include(1,666)
        }.to raise_error a_string_including 'to include 1 and 666'
      end

      it "for Hash" do
        {:key => 'value'}.should include(:key)
        {:key => 'value'}.should_not include(:key2)
        expect {
          {:key => 'value'}.should include(:key, :other)
        }.to raise_error a_string_including 'to include :key and :other'
        expect {
          {:key => 'value'}.should_not include(:key, :other)
        }.to raise_error a_string_including 'to include :key and :other'
        {'key' => 'value'}.should include('key')
        {'key' => 'value'}.should_not include('key2')
      end
    end # context shouldn't break RSpec #include matcher
    
  end # context RSpecSolr::SolrResponseHash #include matcher
  
end