# overriding RSpec::Matchers::Builtin::Include.perform_match method 
# so we can use RSpec include matcher for document in Solr response
module RSpec
  module Matchers
    module BuiltIn
      class Include 
        
        # overriding method so we can use RSpec include matcher for document in Solr response
        #   my_solr_resp_hash.should include({"id" => "666"})
        def perform_match(predicate, hash_predicate, actuals, expecteds)
          expecteds.send(predicate) do |expected|
            if comparing_doc_to_solr_resp_hash?(actuals, expected)
              actuals.has_document?(expected)
            elsif comparing_hash_values?(actuals, expected)
              expected.send(hash_predicate) {|k,v| actuals[k] == v}
            elsif comparing_hash_keys?(actuals, expected)
              actuals.has_key?(expected)
            else
              actuals.include?(expected)
            end
          end
        end
        
        # is actual param a SolrResponseHash? 
        def comparing_doc_to_solr_resp_hash?(actual, expected)
          actual.is_a?(RSpecSolr::SolrResponseHash)
        end
        
      end # class Include
    end # module BuiltIn
  end
end