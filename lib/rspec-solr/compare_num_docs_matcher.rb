# Custom RSpec Matchers for Solr responses
module RSpecSolr::Matchers
  # this is the lambda used to determine if the receiver (a Solr response object) has the same number of total documents
  #  as the expected RSpecSolr::SolrResponseHash
  def self.same_number_of_results_body
    lambda do |expected_solr_resp_hash|
      match do |actual_solr_resp_hash|
        actual_solr_resp_hash.size == expected_solr_resp_hash.size
      end

      failure_message do |actual_solr_resp_hash|
        "expected #{actual_solr_resp_hash.size} documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
      end

      failure_message_when_negated do |actual_solr_resp_hash|
        "expected (not #{actual_solr_resp_hash.size}) documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
      end

      diffable
    end
  end

  # @!method have_the_same_number_of_results_as
  # Determine if the receiver (a Solr response object) has the same number of total documents as the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_the_same_number_of_results_as, &same_number_of_results_body

  # @!method have_the_same_number_of_documents_as
  # Determine if the receiver (a Solr response object) has the same number of total documents as the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_the_same_number_of_documents_as,  &same_number_of_results_body

  # this is the lambda used to determine if the receiver (a Solr response object) has fewer total documents
  #  than the expected RSpecSolr::SolrResponseHash
  def self.fewer_results_than_body
    lambda do |expected_solr_resp_hash|
      match do |actual_solr_resp_hash|
        actual_solr_resp_hash.size < expected_solr_resp_hash.size
      end

      failure_message do |actual_solr_resp_hash|
        "expected more than #{actual_solr_resp_hash.size} documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
      end

      failure_message_when_negated do |actual_solr_resp_hash|
        "expected #{actual_solr_resp_hash.size} or fewer documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
      end

      diffable
    end
  end

  # @!method have_fewer_results_than
  # Determine if the receiver (a Solr response object) has fewer total documents than the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_fewer_results_than, &fewer_results_than_body

  # @!method have_fewer_documents_than
  # Determine if the receiver (a Solr response object) has fewer total documents than the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_fewer_documents_than, &fewer_results_than_body

  # this is the lambda used to determine if the receiver (a Solr response object) has more total documents
  #  than the expected RSpecSolr::SolrResponseHash
  def self.more_results_than_body
    lambda do |expected_solr_resp_hash|
      match do |actual_solr_resp_hash|
        actual_solr_resp_hash.size > expected_solr_resp_hash.size
      end

      failure_message do |actual_solr_resp_hash|
        "expected fewer than #{actual_solr_resp_hash.size} documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
      end

      failure_message_when_negated do |actual_solr_resp_hash|
        "expected #{actual_solr_resp_hash.size} or more documents in Solr response #{expected_solr_resp_hash.num_docs_partial_output_str}"
      end

      diffable
    end
  end

  # @!method have_more_results_than
  # Determine if the receiver (a Solr response object) has more total documents than the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_more_results_than, &more_results_than_body

  # @!method have_more_documents_than
  # Determine if the receiver (a Solr response object) has more total documents than the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_more_documents_than, &more_results_than_body
end
