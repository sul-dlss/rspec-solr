# Custom RSpec Matchers for Solr responses
module RSpecSolr::Matchers
  # @!method have_documents
  # Determine if the receiver (a Solr response object) has at least one document
  # NOTE:  this is about the TOTAL number of Solr documents matching the query, not solely the number of docs in THIS response
  RSpec::Matchers.define :have_documents do
    match do |solr_resp|
      solr_resp['response']['numFound'] > 0
    end

    failure_message do |solr_resp|
      "expected documents in Solr response #{solr_resp['response']}"
    end

    failure_message_when_negated do |solr_resp|
      "did not expect documents, but Solr response had #{solr_resp['response']['numFound']}"
    end
  end
end
