# Custom RSpec Matchers for Solr responses
module RSpecSolr::Matchers
  
  # Determine if the receiver has the facet_field
  def have_facet_field
    # Placeholder method for documentation purposes; 
    # the actual method is defined using RSpec's matcher DSL
  end

  # this is the lambda used to determine if the receiver (a Solr response object) has non-empty values for the facet field
  #  as the expected RSpecSolr::SolrResponseHash
  def self.have_facet_field_body 
    lambda { |expected_facet_field_name|
      match do |solr_resp|
        solr_resp.has_facet_field?(expected_facet_field_name)
      end
      
      failure_message_for_should do |solr_resp|
        "expected facet field #{expected_facet_field_name} with values in Solr response: #{solr_resp}"
      end
    
      failure_message_for_should_not do |solr_resp|
        "expected no values for facet field #{expected_facet_field_name} in Solr response: #{solr_resp}"
      end 
      
      diffable
    }
  end
  
  # Determine if the receiver (a Solr response object) has the same number of total documents as the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_facet_field, &have_facet_field_body  
  
end