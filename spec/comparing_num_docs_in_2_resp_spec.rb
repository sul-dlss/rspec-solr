require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do

  # fixtures below

  context "should have_the_same_number_of_results_as()" do
    it "passes if both results have same total number of documents" do
      expect(@solr_resp_1_doc).to have_the_same_number_of_results_as(@solr_resp_1_doc)
      expect(@solr_resp_3_docs).to have_the_same_number_of_results_as(@solr_resp_3_docs)
      expect(@solr_resp_many_docs).to have_the_same_number_of_results_as(@solr_resp_many_docs2)
    end
    it "passes if neither search matches any documents" do
      expect(@solr_resp_no_docs).to have_the_same_number_of_results_as(@solr_resp_no_docs)
    end
    it "fails if the first response has more total results" do
      expect {
        expect(@solr_resp_not3_docs).to have_the_same_number_of_results_as(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected 8 documents in Solr response {'
    end
    it "fails if the first response has fewer total results" do
      expect {
        expect(@solr_resp_3_docs).to have_the_same_number_of_results_as(@solr_resp_not3_docs)
      }.to raise_error.with_message a_string_including 'expected 3 documents in Solr response {'
    end
    it "fails if only one response has results" do
      expect {
        expect(@solr_resp_no_docs).to have_the_same_number_of_results_as(@solr_resp_not3_docs)
      }.to raise_error.with_message a_string_including 'expected 0 documents in Solr response {'
      expect {
        expect(@solr_resp_3_docs).to have_the_same_number_of_results_as(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected 3 documents in Solr response {'
    end
  end # should have_the_same_number_of_results_as()

  context "should_NOT have_the_same_number_of_results_as()" do
    it "fails if both results have same total number of documents" do
      expect {
        expect(@solr_resp_1_doc).not_to have_the_same_number_of_results_as(@solr_resp_1_doc)
      }.to raise_error.with_message a_string_including 'expected (not 1) documents in Solr response {'
      expect {
        expect(@solr_resp_3_docs).not_to have_the_same_number_of_results_as(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected (not 3) documents in Solr response {'
      expect {
        expect(@solr_resp_many_docs).not_to have_the_same_number_of_results_as(@solr_resp_many_docs2)
      }.to raise_error.with_message a_string_including 'expected (not 1019) documents in Solr response {'
    end
    it "fails if neither search matches any documents" do
      expect {
        expect(@solr_resp_no_docs).not_to have_the_same_number_of_results_as(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected (not 0) documents in Solr response {'
    end
    it "passes if the first response has more total results" do
      expect(@solr_resp_not3_docs).not_to have_the_same_number_of_results_as(@solr_resp_3_docs)
    end
    it "passes if the first response has fewer total results" do
      expect(@solr_resp_3_docs).not_to have_the_same_number_of_results_as(@solr_resp_not3_docs)
    end
    it "passes if only one response has results" do
      expect(@solr_resp_no_docs).not_to have_the_same_number_of_results_as(@solr_resp_not3_docs)
      expect(@solr_resp_3_docs).not_to have_the_same_number_of_results_as(@solr_resp_no_docs)
    end
  end # should_NOT have_the_same_number_of_results_as()


  context "should have_fewer_results_than()" do
    it "passes if first response has no results and second doc has results" do
      expect(@solr_resp_no_docs).to have_fewer_results_than(@solr_resp_1_doc)
      expect(@solr_resp_no_docs).to have_fewer_results_than(@solr_resp_many_docs)
    end
    it "passes if first response has a smaller number of total results" do
      expect(@solr_resp_1_doc).to have_fewer_results_than(@solr_resp_3_docs)
      expect(@solr_resp_3_docs).to have_fewer_results_than(@solr_resp_not3_docs)
      expect(@solr_resp_3_docs).to have_fewer_results_than(@solr_resp_many_docs)
    end
    it "fails if responses have same number of total results" do
      expect {
        expect(@solr_resp_3_docs).to have_fewer_results_than(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected more than 3 documents in Solr response {'
      expect {
        expect(@solr_resp_many_docs).to have_fewer_results_than(@solr_resp_many_docs2)
      }.to raise_error.with_message a_string_including 'expected more than 1019 documents in Solr response {'
      expect {
        expect(@solr_resp_no_docs).to have_fewer_results_than(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected more than 0 documents in Solr response {'
    end
    it "fails if first response has more total results" do
      expect {
        expect(@solr_resp_3_docs).to have_fewer_results_than(@solr_resp_1_doc)
      }.to raise_error.with_message a_string_including 'expected more than 3 documents in Solr response {'
      expect {
        expect(@solr_resp_not3_docs).to have_fewer_results_than(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected more than 8 documents in Solr response {'
      expect {
        expect(@solr_resp_not3_docs).to have_fewer_results_than(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected more than 8 documents in Solr response {'
    end
  end # should have_fewer_results_than()

  context "should_NOT have_fewer_results_than()" do
    it "fails if first response has no results and second doc has results" do
      expect {
        expect(@solr_resp_no_docs).not_to have_fewer_results_than(@solr_resp_1_doc)
      }.to raise_error.with_message a_string_including 'expected 0 or fewer documents in Solr response {'
      expect {
        expect(@solr_resp_no_docs).not_to have_fewer_results_than(@solr_resp_many_docs)
      }.to raise_error.with_message a_string_including 'expected 0 or fewer documents in Solr response {'
    end
    it "fails if first response has a smaller number of total results" do
      expect {
        expect(@solr_resp_1_doc).not_to have_fewer_results_than(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected 1 or fewer documents in Solr response {'
      expect {
        expect(@solr_resp_3_docs).not_to have_fewer_results_than(@solr_resp_not3_docs)
      }.to raise_error.with_message a_string_including 'expected 3 or fewer documents in Solr response {'
      expect {
        expect(@solr_resp_3_docs).not_to have_fewer_results_than(@solr_resp_many_docs)
      }.to raise_error.with_message a_string_including 'expected 3 or fewer documents in Solr response {'
    end
    it "passes if responses have same number of total results" do
      expect(@solr_resp_3_docs).not_to have_fewer_results_than(@solr_resp_3_docs)
      expect(@solr_resp_many_docs).not_to have_fewer_results_than(@solr_resp_many_docs2)
      expect(@solr_resp_no_docs).not_to have_fewer_results_than(@solr_resp_no_docs)
    end
    it "passes if first response has more total results" do
      expect(@solr_resp_3_docs).not_to have_fewer_results_than(@solr_resp_1_doc)
      expect(@solr_resp_not3_docs).not_to have_fewer_results_than(@solr_resp_3_docs)
      expect(@solr_resp_not3_docs).not_to have_fewer_results_than(@solr_resp_no_docs)
    end
  end # should_NOT have_fewer_results_than()

  
  context "should have_more_results_than()" do
    it "passes if first response has results and second response does not" do
      expect(@solr_resp_1_doc).to have_more_results_than(@solr_resp_no_docs)
      expect(@solr_resp_many_docs).to have_more_results_than(@solr_resp_no_docs)
    end
    it "passes if first response has a larger number of total results" do
      expect(@solr_resp_3_docs).to have_more_results_than(@solr_resp_1_doc)
      expect(@solr_resp_not3_docs).to have_more_results_than(@solr_resp_3_docs)
      expect(@solr_resp_many_docs).to have_more_results_than(@solr_resp_not3_docs)
    end
    it "fails if responses have same number of total results" do
      expect {
        expect(@solr_resp_3_docs).to have_more_results_than(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected fewer than 3 documents in Solr response {'
      expect {
        expect(@solr_resp_many_docs).to have_more_results_than(@solr_resp_many_docs2)
      }.to raise_error.with_message a_string_including 'expected fewer than 1019 documents in Solr response {'
      expect {
        expect(@solr_resp_no_docs).to have_more_results_than(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected fewer than 0 documents in Solr response {'
    end
    it "fails if first response has fewer total results" do
      expect {
        expect(@solr_resp_1_doc).to have_more_results_than(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected fewer than 1 documents in Solr response {'
      expect {
        expect(@solr_resp_3_docs).to have_more_results_than(@solr_resp_not3_docs)
      }.to raise_error.with_message a_string_including 'expected fewer than 3 documents in Solr response {'
      expect {
        expect(@solr_resp_3_docs).to have_more_results_than(@solr_resp_many_docs)
      }.to raise_error.with_message a_string_including 'expected fewer than 3 documents in Solr response {'
    end
  end # should have_more_results_than()

  context "should_NOT have_more_results_than()" do
    it "fails if first response has results and second response does not" do
      expect {
        expect(@solr_resp_1_doc).not_to have_more_results_than(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected 1 or more documents in Solr response {'
      expect {
        expect(@solr_resp_many_docs).not_to have_more_results_than(@solr_resp_no_docs)
      }.to raise_error.with_message a_string_including 'expected 1019 or more documents in Solr response {'
    end
    it "fails if first response has a larger number of total results" do
      expect {
        expect(@solr_resp_3_docs).not_to have_more_results_than(@solr_resp_1_doc)
      }.to raise_error.with_message a_string_including 'expected 3 or more documents in Solr response {'
      expect {
        expect(@solr_resp_not3_docs).not_to have_more_results_than(@solr_resp_3_docs)
      }.to raise_error.with_message a_string_including 'expected 8 or more documents in Solr response {'
      expect {
        expect(@solr_resp_many_docs).not_to have_more_results_than(@solr_resp_not3_docs)
      }.to raise_error.with_message a_string_including 'expected 1019 or more documents in Solr response {'
    end
    it "passes if responses have same number of total results" do
      expect(@solr_resp_3_docs).not_to have_more_results_than(@solr_resp_3_docs)
      expect(@solr_resp_many_docs).not_to have_more_results_than(@solr_resp_many_docs2)
      expect(@solr_resp_no_docs).not_to have_more_results_than(@solr_resp_no_docs)
    end
    it "passes if first response has fewer total results" do
      expect(@solr_resp_1_doc).not_to have_more_results_than(@solr_resp_3_docs)
      expect(@solr_resp_3_docs).not_to have_more_results_than(@solr_resp_not3_docs)
      expect(@solr_resp_3_docs).not_to have_more_results_than(@solr_resp_many_docs)
    end
  end # should_NOT have_more_results_than()


  context "the word documents should be interchangeable with results" do
    it "have_the_same_number_of_documents_as" do
      expect(@solr_resp_1_doc).to have_the_same_number_of_documents_as(@solr_resp_1_doc)
      expect(@solr_resp_not3_docs).not_to have_the_same_number_of_documents_as(@solr_resp_3_docs)
    end
    it "have_fewer_results_than" do
      expect(@solr_resp_3_docs).to have_fewer_results_than(@solr_resp_not3_docs)
      expect(@solr_resp_many_docs).not_to have_fewer_results_than(@solr_resp_many_docs2)
    end
    it "have_more_results_than" do
      expect(@solr_resp_not3_docs).to have_more_results_than(@solr_resp_3_docs)
      expect(@solr_resp_1_doc).not_to have_more_documents_than(@solr_resp_3_docs)
    end
  end


  before(:all) do
    @solr_resp_1_doc = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 1, 
                            "start" => 0, 
                            "docs" => [ {"id"=>"111"} ]
                          }
                        })

    @solr_resp_3_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 3, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333"}, 
                              ]
                          }
                        })

    @solr_resp_not3_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 8, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333"}, 
                              ]
                          }
                        })

    @solr_resp_many_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 1019, 
                            "start" => 0, 
                            "docs" => 
                              [ {"id"=>"111"}, 
                                {"id"=>"222"}, 
                                {"id"=>"333"}, 
                              ]
                          }
                        })

    @solr_resp_many_docs2 = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 1019, 
                            "start" => 10, 
                            "docs" => 
                              [ {"id"=>"777"}, 
                                {"id"=>"888"}, 
                                {"id"=>"999"}, 
                              ]
                          }
                        })

    @solr_resp_no_docs = RSpecSolr::SolrResponseHash.new({ "response" =>
                          { "numFound" => 0, 
                            "start" => 0, 
                            "docs" => [] 
                          }
                        }) 
  end

end