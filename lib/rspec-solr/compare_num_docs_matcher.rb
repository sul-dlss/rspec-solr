# Custom RSpec Matchers for Solr responses
module RSpecSolr::Matchers
  
  # Determine if the receiver has the same number of Solr docs as the expected
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  def have_the_same_number_of_results_as
    # Placeholder method for documentation purposes; 
    # the actual method is defined using RSpec's matcher DSL
  end

  # Determine if the receiver has fewer Solr docs than the expected
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  def have_fewer_results_than
    # Placeholder method for documentation purposes; 
    # the actual method is defined using RSpec's matcher DSL
  end

  # Determine if the receiver has more Solr docs than the expected
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  def have_more_results_than
    # Placeholder method for documentation purposes; 
    # the actual method is defined using RSpec's matcher DSL
  end

  # Determine if the receiver (a Solr response object) has the same number of total documents as the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_the_same_number_of_results_as do | expected_solr_resp_hash |
    match do |actual_solr_resp_hash|
      actual_solr_resp_hash.size == expected_solr_resp_hash.size
    end

    failure_message_for_should do |actual_solr_resp_hash|
      "expected #{actual_solr_resp_hash.size} documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
    end
    
    failure_message_for_should_not do |actual_solr_resp_hash|
      "expected (not #{actual_solr_resp_hash.size}) documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
    end 
      
    diffable
  end
  
  # Determine if the receiver (a Solr response object) has fewer total documents than the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_fewer_results_than do | expected_solr_resp_hash |
    match do |actual_solr_resp_hash|
      actual_solr_resp_hash.size < expected_solr_resp_hash.size
    end

    failure_message_for_should do |actual_solr_resp_hash|
      "expected more than #{actual_solr_resp_hash.size} documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
    end
    
    failure_message_for_should_not do |actual_solr_resp_hash|
      "expected #{actual_solr_resp_hash.size} or fewer documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
    end 
      
    diffable
  end

  # Determine if the receiver (a Solr response object) has more total documents than the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_more_results_than do | expected_solr_resp_hash |
    match do |actual_solr_resp_hash|
      actual_solr_resp_hash.size > expected_solr_resp_hash.size
    end

    failure_message_for_should do |actual_solr_resp_hash|
      "expected fewer than #{actual_solr_resp_hash.size} documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
    end
    
    failure_message_for_should_not do |actual_solr_resp_hash|
      "expected #{actual_solr_resp_hash.size} or more documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
    end 
      
    diffable
  end

end