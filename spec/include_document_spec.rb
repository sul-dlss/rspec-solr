require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  
  # fixtures below
  
  context "RSpecSolr::SolrResponseHash #include matcher" do
    
    context "should include('fldname'=>'fldval')" do

      it "passes if Solr document in response contains 'fldval' in named field" do
        expect(@solr_resp_5_docs).to include("id" => "111")
        expect(@solr_resp_5_docs).to include("fld" => "val")  # 2 docs match 
      end
      it "passes if single value expectation is expressed as an Array" do
        expect(@solr_resp_5_docs).to include("id" => ["111"])
      end
      it "fails if no Solr document in response has 'fldval' for the named field" do
        expect {
          expect(@solr_resp_5_docs).to include("id" => "not_there")
        }.to raise_error.with_message a_string_including '} to include {"id" => "not_there"}'
      end
      it "fails if no Solr document in response has the named field" do
        expect {
          expect(@solr_resp_5_docs).to include("not_there" => "anything")
        }.to raise_error.with_message a_string_including '} to include {"not_there" => "anything"}'
      end
    end # "should include('fldname'=>'fldval')"

    context "should_NOT include('fldname'=>'fldval')" do

      it "fails if Solr document in response contains 'fldval' in named field" do
        expect {
          expect(@solr_resp_5_docs).not_to include("id" => "111")
        }.to raise_error.with_message a_string_including 'not to include {"id" => "111"}'
        expect {
          expect(@solr_resp_5_docs).not_to include("fld" => "val") 
        }.to raise_error.with_message a_string_including 'not to include {"fld" => "val"}'
      end
      it "passes if no Solr document in response has 'fldval' for the named field" do
          expect(@solr_resp_5_docs).not_to include({"id" => "not_there"})
      end
      it "passes if no Solr document in response has the named field" do
          expect(@solr_resp_5_docs).not_to include({"not_there" => "anything"})
      end
      it "passes if single field value is expressed as Array" do
        expect(@solr_resp_5_docs).not_to include({"id" => ["not_there"]})
      end
    end # "should_not include('fldname'=>'fldval')"

    context "should include('fld1'=>'val1', 'fld2'=>'val2')" do

      it "passes if all pairs are included in a Solr document in the response" do
        expect(@solr_resp_5_docs).to include("id" => "111", "fld" => "val")
        expect(@solr_resp_5_docs).to include("id" => "333", "fld" => "val")
      end
      it "fails if only part of expectation is met" do
        expect {
          expect(@solr_resp_5_docs).to include("id" => "111", "fld" => "not_there")
        }.to raise_error.with_message a_string_including '} to include {"id" => "111", "fld" => "not_there"}'
        expect {
          expect(@solr_resp_5_docs).to include("id" => "111", "not_there" => "whatever")
        }.to raise_error.with_message a_string_including '} to include {"id" => "111", "not_there" => "whatever"}'
        expect {
          expect(@solr_resp_5_docs).to include("id" => "222", "fld" => "val")
        }.to raise_error.with_message a_string_including '} to include {"id" => "222", "fld" => "val"}'
      end
      it "fails if no part of expectation is met" do
        expect {
          expect(@solr_resp_5_docs).to include("id" => "not_there", "not_there" => "anything")
        }.to raise_error.with_message a_string_including '} to include {"id" => "not_there", "not_there" => "anything"}'
      end
    end # should include('fld1'=>'val1', 'fld2'=>'val2')

    context "should_NOT include('fld1'=>'val1', 'fld2'=>'val2')" do

      it "fails if a Solr document in the response contains all the key/value pairs" do
        expect {
          expect(@solr_resp_5_docs).not_to include("id" => "333", "fld" => "val")
        }.to raise_error.with_message a_string_including 'not to include {"id" => "333", "fld" => "val"}'
      end
      it "passes if a Solr document in the response contains all the key/value pairs among others" do
        expect {
          expect(@solr_resp_5_docs).not_to include("id" => "111", "fld" => "val")
          }.to raise_error.with_message a_string_including 'not to include {"id" => "111", "fld" => "val"}'
      end
      it "passes if part of the expectation is not met" do
        expect(@solr_resp_5_docs).not_to include("id" => "111", "fld" => "not_there")
        expect(@solr_resp_5_docs).not_to include("id" => "111", "not_there" => "whatever")
        expect(@solr_resp_5_docs).not_to include("id" => "222", "fld" => "val")
      end
      it "passes if no part of the expectatio is met" do
        expect(@solr_resp_5_docs).not_to include("id" => "not_there", "not_there" => "anything")
      end
    end # should_not include('fld1'=>'val1', 'fld2'=>'val2')    
    
    context "multi-valued fields and expectations" do
      
      context "should include(doc_exp)" do
        it "passes if all the expected values match all the values in a Solr document in the response" do
          expect(@solr_resp_5_docs).to include("fld" => ["val1", "val2", "val3"])
          expect(@solr_resp_5_docs).to include("fld" => ["val1", "val2", "val3"], "id" => "444")
        end
        it "passes if all the expected values match some of the values in a Solr document in the response" do
          expect(@solr_resp_5_docs).to include("fld" => ["val1", "val2"])
          expect(@solr_resp_5_docs).to include("fld" => "val1")
          expect(@solr_resp_5_docs).to include("fld" => ["val1", "val2"], "id" => "444")
        end
        it "fails if none of the expected values match the values in a Solr document in the response" do
          expect {
            expect(@solr_resp_5_docs).to include("fld" => ["not_there", "also_not_there"])
            }.to raise_error.with_message a_string_including '} to include {"fld" => ["not_there", "also_not_there"]}'
        end
        it "fails if only some of the expected values match the values in a Solr document in the response" do
          expect {
            expect(@solr_resp_5_docs).to include("fld" => ["val1", "val2", "not_there"])
            }.to raise_error.with_message a_string_including '} to include {"fld" => ["val1", "val2", "not_there"]}'
        end
      end # should
      
      context "should_NOT include(doc_exp)" do
        it "fails if all the expected values match all the values in a Solr document in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include("fld" => ["val1", "val2", "val3"])
          }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2", "val3"]}'
          expect {
            expect(@solr_resp_5_docs).not_to include("fld" => ["val1", "val2", "val3"], "id" => "444")
            }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2", "val3"], "id" => "444"}'
        end
        it "fails if all the expected values match some of the values in a Solr document in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include("fld" => ["val1", "val2"])
          }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2"]}'
          expect {
            expect(@solr_resp_5_docs).not_to include("fld" => "val1")
            }.to raise_error.with_message a_string_including 'not to include {"fld" => "val1"}'
          expect {
            expect(@solr_resp_5_docs).not_to include("fld" => ["val1", "val2"], "id" => "444")
            }.to raise_error.with_message a_string_including 'not to include {"fld" => ["val1", "val2"], "id" => "444"}'
        end
        it "passes if none of the expected values match the values in a Solr document in the response" do
          expect(@solr_resp_5_docs).not_to include("fld" => ["not_there", "also_not_there"])
          expect(@solr_resp_5_docs).not_to include("fld" => ["not_there", "also_not_there"], "id" => "444")
        end
        it "passes if only some of the expected values match the values in a Solr document in the response" do
          expect(@solr_resp_5_docs).not_to include("fld" => ["val1", "val2", "not_there"])
          expect(@solr_resp_5_docs).not_to include("fld" => ["val1", "val2", "not_there"], "id" => "444")
        end
      end # should_not    
  
    end # multi-valued fields in docs
    
    
    context "single String argument" do
      
      context "should include(single_string_arg)" do
        it "passes if string matches default id_field of Solr document in the response" do
          expect(@solr_resp_5_docs).to include('111')
        end
        it "passes if string matches non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect(my_srh).to include('val2')
        end
        it "fails if string does not match default id_field of Solr document in the response" do
          expect {
            expect(@solr_resp_5_docs).to include('666')
            }.to raise_error.with_message a_string_including '} to include "666"'
        end
        it "fails if string doesn't match non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            expect(my_srh).to include('val')
          }.to raise_error.with_message a_string_including '} to include "val"'
        end    
      end # should

      context "should_NOT include(single_string_arg)" do
        it "fails if string matches default id_field of Solr document in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include('111')
          }.to raise_error.with_message a_string_including 'not to include "111"'
        end
        it "fails if string matches non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            expect(my_srh).not_to include('val2')
          }.to raise_error.with_message a_string_including 'not to include "val2"'
        end
        it "passes if string does not match default id_field of Solr document in the response" do
          expect(@solr_resp_5_docs).not_to include('666')
        end
        it "fails if string doesn't match non-default id_field in the SolrResponseHash object" do
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect(my_srh).not_to include('val')
        end    
      end # should_not
      
    end # single String arg

    context "Array argument" do
      
      context "should include(Array_of_Strings)" do
        it "passes if all Strings in Array match all Solr documents' id_field in the response" do
          expect(@solr_resp_5_docs).to include(["111", "222", "333", "444", "555"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect(my_srh).to include(["val2"])
        end
        it "passes if all Strings in Array match some Solr documents' id_field in the response" do
          expect(@solr_resp_5_docs).to include(["111", "222", "333"])
          expect(@solr_resp_5_docs).to include(["111"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld'
          expect(my_srh).to include(["val"])
        end
        it "fails if no Strings in Array match Solr documents' id_field in the response" do
          expect {
            expect(@solr_resp_5_docs).to include(["888", "899"])
          }.to raise_error.with_message a_string_including '} to include ["888", "899"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            expect(my_srh).to include(["val8", "val9"])
          }.to raise_error.with_message a_string_including '} to include ["val8", "val9"]'
        end
        it "fails if only some Strings in Array match Solr documents' id_field in the response" do
          expect {
            expect(@solr_resp_5_docs).to include(["111", "222", "999"])
          }.to raise_error.with_message a_string_including '} to include ["111", "222", "999"]'
          expect {
            expect(@solr_resp_5_docs).to include(["666", "555"])
          }.to raise_error.with_message a_string_including '} to include ["666", "555"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            expect(my_srh).to include(["val2", "val9"])
          }.to raise_error.with_message a_string_including '} to include ["val2", "val9"]'
        end
      end # should include(Array_of_Strings)
      
      context "should_NOT include(Array_of_Strings)" do
        it "fails if all Strings in Array match all Solr documents' id_field in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include(["111", "222", "333", "444", "555"])
          }.to raise_error.with_message a_string_including 'not to include ["111", "222", "333", "444", "555"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect {
            expect(my_srh).not_to include(["val2"])
          }.to raise_error.with_message a_string_including 'not to include ["val2"]'
        end
        it "fails if all Strings in Array match some Solr documents' id_field in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include(["111", "222", "333"])
          }.to raise_error.with_message a_string_including 'not to include ["111", "222", "333"]'
          expect {
            expect(@solr_resp_5_docs).not_to include(["111"])
          }.to raise_error.with_message a_string_including 'not to include ["111"]'
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld'
          expect {
            expect(my_srh).not_to include(["val"])
          }.to raise_error.with_message a_string_including 'not to include ["val"]'
        end
        it "passes if no Strings in Array match Solr documents' id_field in the response" do
          expect(@solr_resp_5_docs).not_to include(["888", "899"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect(my_srh).not_to include(["val8", "val9"])
        end
        it "passes if only some Strings in Array match Solr documents' id_field in the response" do
          expect(@solr_resp_5_docs).not_to include(["111", "222", "999"])
          expect(@solr_resp_5_docs).not_to include(["666", "555"])
          my_srh = @solr_resp_5_docs.clone
          my_srh.id_field='fld2'
          expect(my_srh).not_to include(["val2", "val9"])
        end
      end # should_not include(Array_of_Strings)
      
      context "should include(Array_of_Hashes)" do
        it "passes if all Hashes in Array match all Solr documents in the response" do
          expect(@solr_resp_5_docs).to include([{"id"=>"111", "fld"=>/val/, "fld2"=>"val2"}, 
                                            {"id"=>"222"}, 
                                            {"id"=>"333", "fld"=>"val"}, 
                                            {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                            {"id"=>"555"}])
          expect(@solr_resp_5_docs).to include([{"id"=>"111"}, {"id"=>"222"}, {"id"=>"333"}, {"id"=>"444"}, {"id"=>"555"}])
        end
        it "passes if all Hashes in Array match some Solr documents in the response" do
          expect(@solr_resp_5_docs).to include([{"id"=>"333", "fld"=>"val"}, {"id"=>"111", "fld2"=>"val2"}])
          expect(@solr_resp_5_docs).to include([{"fld"=>"val"}])
        end
        it "fails if no Hashes in Array match Solr documents in the response" do
          expect {
            expect(@solr_resp_5_docs).to include([{"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
          }.to raise_error.with_message a_string_including '} to include [{"foo" => "bar"}, {"bar" => "food", "mmm" => "food"}]'
        end
        it "fails if only some Hashes in Array match Solr documents in the response" do
          expect {
            expect(@solr_resp_5_docs).to include([{"id"=>"222"}, {"id"=>"333", "fld"=>"val"}, {"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
          }.to raise_error.with_message a_string_including '} to include [{"id" => "222"},'
        end
      end # should include(Array_of_Hashes)

      context "should_NOT include(Array_of_Hashes)" do
        it "fails if all Hashes in Array match all Solr documents in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include([{"id"=>"111", "fld"=>"val", "fld2"=>"val2"}, 
                                            {"id"=>"222"}, 
                                            {"id"=>"333", "fld"=>"val"}, 
                                            {"id"=>"444", "fld"=>["val1", "val2", "val3"]}, 
                                            {"id"=>"555"}])
          }.to raise_error.with_message a_string_including 'not to include [{"id" => "111",'
          expect {
            expect(@solr_resp_5_docs).not_to include([{"id"=>"111"}, {"id"=>"222"}, {"id"=>"333"}, {"id"=>"444"}, {"id"=>"555"}])
          }.to raise_error.with_message a_string_including 'not to include [{"id" => "111"},'
        end
        it "fails if all Hashes in Array match some Solr documents in the response" do
          expect {
            expect(@solr_resp_5_docs).not_to include([{"id"=>"333", "fld"=>"val"}, {"id"=>"111", "fld2"=>"val2"}])
          }.to raise_error.with_message a_string_including 'not to include [{"id" => "333",'
          expect {
            expect(@solr_resp_5_docs).not_to include([{"fld"=>"val"}])
          }.to raise_error.with_message a_string_including ' not to include [{"fld" => "val"}]'
        end
        it "passes if no Hashes in Array match Solr documents in the response" do
          expect(@solr_resp_5_docs).not_to include([{"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
        end
        it "passes if only some Hashes in Array match Solr documents in the response" do
          expect(@solr_resp_5_docs).not_to include([{"id"=>"222"}, {"id"=>"333", "fld"=>"val"}, {"foo"=>"bar"}, {"bar"=>"food", "mmm"=>"food"}])
        end
        
      end # should_not include(Array_of_Hashes)

      context "mixed Array of Strings and Hashes" do
        it "passes if all elements of Array pass" do
          expect(@solr_resp_5_docs).to include([ "222", {"id"=>"111", "fld"=>"val"}, "555"  ])
        end
        it "fails if any element of Array fails" do
          expect {
            expect(@solr_resp_5_docs).to include([ "not_there", {"id"=>"111", "fld"=>"val"}, "555"  ])
          }.to raise_error.with_message a_string_including '} to include ['
          expect {
            expect(@solr_resp_5_docs).to include([ "222", {"id"=>"111", "not"=>"there"}, "555"  ])
          }.to raise_error.with_message a_string_including '} to include ['
        end
      end
      
      it "should allow #have_documents as alternative to #include" do
        expect(@solr_resp_5_docs).to have_documents(["111", "222", "333"])
      end
      
    end # Array argument

    
    context "regex value" do

      context "should include('fld' => /regex/)" do
        it "passes if Solr document in response matches regex in named field" do
          expect(@solr_resp_5_docs).to include("id" => /\d{3}/)
          expect(@solr_resp_5_docs).to include("fld" => /^va/)  # 2 docs match 
          expect(@solr_resp_5_docs).to include("fld" => /Va/i)  # 2 docs match 
        end
        it "passes if single value expectation is expressed as an Array" do
          expect(@solr_resp_5_docs).to include("id" => [/111/])
        end
        it "fails if no Solr document in response has 'fldval' for the named field" do
          expect {
            expect(@solr_resp_5_docs).to include("id" => /not there/)
          }.to raise_error.with_message a_string_including '} to include {"id" => /not there/}'
        end
        it "fails if no Solr document in response has the named field" do
          expect {
            expect(@solr_resp_5_docs).to include("not_there" => /anything/)
            }.to raise_error.with_message a_string_including '} to include {"not_there" => /anything/}'
        end
      end # should include('fld' => /regex/)

      context "should_NOT include('fld' => /regex/)" do
        it "fails if Solr document in response matches regex in named field" do
          expect {
            expect(@solr_resp_5_docs).not_to include("id" => /\d{3}/)
          }.to raise_error.with_message a_string_including 'not to include {"id" => /\d{3}/}'
          expect {
            expect(@solr_resp_5_docs).not_to include("fld" => /^va/) 
          }.to raise_error.with_message a_string_including 'not to include {"fld" => /^va/}'
        end
        it "passes if no Solr document in response has 'fldval' for the named field" do
            expect(@solr_resp_5_docs).not_to include({"id" => /not there/})
        end
        it "passes if no Solr document in response has the named field" do
            expect(@solr_resp_5_docs).not_to include({"not_there" => /anything/})
        end
        it "passes if single field value is expressed as Array" do
          expect(@solr_resp_5_docs).not_to include({"id" => [/not there/]})
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
        expect("abc").to include("a")
        expect("abc").not_to include("d")
      end

      it "for Array" do
        expect([1,2,3]).to include(3)
        expect([1,2,3]).to include(2,3)
        expect([1,2,3]).not_to include(4)
        expect {
          expect([1,2,3]).to include(1,666)
        }.to raise_error a_string_including 'to include 1 and 666'
        expect {
          expect([1,2,3]).not_to include(1,666)
        }.to raise_error a_string_including 'to include 1 and 666'
      end

      it "for Hash" do
        expect({:key => 'value'}).to include(:key)
        expect({:key => 'value'}).not_to include(:key2)
        expect {
          expect({:key => 'value'}).to include(:key, :other)
        }.to raise_error a_string_including 'to include :key and :other'
        expect {
          expect({:key => 'value'}).not_to include(:key, :other)
        }.to raise_error a_string_including 'to include :key and :other'
        expect({'key' => 'value'}).to include('key')
        expect({'key' => 'value'}).not_to include('key2')
      end
    end # context shouldn't break RSpec #include matcher
    
  end # context RSpecSolr::SolrResponseHash #include matcher
  
end