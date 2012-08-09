require 'delegate'

class RSpecSolr
  
  # Subclass Hash so we can use RSpec matchers for number of documents:
  #   my_solr_resp_hash.should have(3).documents
  #   my_solr_resp_hash.should have_at_least(3).documents
  class SolrResponseHash < DelegateClass(Hash)

    
    # NOTE:  this is about the total number of Solr documents matching query
    # override Hash size method so we can use RSpec matchers for number of documents:
    #   my_solr_resp_hash.should have(3).documents
    #   my_solr_resp_hash.should have_at_least(3).documents
    def size
      # NOT:  self["response"]["docs"].size  # number of Solr docs returned in THIS response
      self["response"]["numFound"]  # total number of Solr docs matching query
    end
    
    # @param expected_doc [Hash] key-val pairs indicating what should be matched in a document in the response
    # @example Expected Doc Hash
    #   {"id" => "666"}
    #   {"subject" => ["warm fuzzies", "fluffy"]}
    #   {"title" => "warm fuzzies", "subject" => ["puppies"]}
    # @return true if this Solr Response contains a document hash which contains all the key-val pairs in the expected_doc
    def has_document?(expected_doc)
      if (expected_doc.is_a?(Hash))
        # we are happy if any doc meets all of our expectations
        docs.any? { |doc| 
          expected_doc.all? { | exp_fname, exp_vals |
            doc.include?(exp_fname) && 
              # exp_vals can be a String or an Array
              # if it's an Array, then all expected values must be present
              Array(exp_vals).all? { | exp_val |
                # a doc's fld values can be a String or an Array
                Array(doc[exp_fname]).include?(exp_val)
            }
          }
        }
      end
    end
    
    # way to access the Array of Hashes representing the Solr documents in the response
    def docs
      @docs ||= self["response"]["docs"]
    end

  end
end
