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
      
      match_for_should do |solr_resp|
        if @facet_val
          solr_resp.has_facet_field_with_value?(expected_facet_field_name, @facet_val)
        else
          solr_resp.has_facet_field?(expected_facet_field_name)
        end
      end
      
      match_for_should_not do |solr_resp|
        # we should fail if we are looking for a specific facet value but the facet field isn't present in the response
        @has_field = solr_resp.has_facet_field?(expected_facet_field_name)
        if @facet_val
          if @has_field
            !solr_resp.has_facet_field_with_value?(expected_facet_field_name, @facet_val)
          else
            false
          end
        else
          !@has_field
        end
      end

      failure_message_for_should do |solr_resp|
        if @facet_val
          "expected facet field #{expected_facet_field_name} with value #{@facet_val} in Solr response: #{solr_resp}"
        else
          "expected facet field #{expected_facet_field_name} with values in Solr response: #{solr_resp}"
        end
      end
    
      failure_message_for_should_not do |solr_resp|
        if @facet_val
          if @has_field
            "expected facet field #{expected_facet_field_name} not to have value #{@facet_val} in Solr response: #{solr_resp}"
          else
            "expected facet field #{expected_facet_field_name} in Solr response: #{solr_resp}"
          end
        else
          "expected no #{expected_facet_field_name} facet field in Solr response: #{solr_resp}"
        end
      end 
      
      chain :with_value do |val|
        @facet_val = val
      end
      
      diffable
    }
  end
  
  # Determine if the receiver (a Solr response object) has the same number of total documents as the expected RSpecSolr::SolrResponseHash
  # NOTE:  this is about the TOTAL number of Solr documents matching the queries, not solely the number of docs in THESE responses
  RSpec::Matchers.define :have_facet_field, &have_facet_field_body  
  
end