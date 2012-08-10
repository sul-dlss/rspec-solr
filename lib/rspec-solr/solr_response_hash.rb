require 'delegate'

class RSpecSolr
  
  # Subclass Hash so we can use RSpec matchers for number of documents:
  #   my_solr_resp_hash.should have(3).documents
  #   my_solr_resp_hash.should have_at_least(3).documents
  # NOTE:  to use has_document?(String) to match documents, set the id_field attribute (defaults to 'id')
  class SolrResponseHash < DelegateClass(Hash)
    
    # unique id field for Solr documents; defaults to 'id', can be changed with .id_field='foo'
    attr_accessor :id_field
    
    # id_field attribute defaults to 'id' 
    def id_field
      @id_field ||= 'id'
    end
    
    # NOTE:  this is about the TOTAL number of Solr documents matching query, not the number of docs in THIS response
    # override Hash size method so we can use RSpec matchers for number of documents:
    #   my_solr_resp_hash.should have(3).documents
    #   my_solr_resp_hash.should have_at_least(3).documents
    def size
      self["response"]["numFound"]  # total number of Solr docs matching query
      # NOT:  self["response"]["docs"].size  # number of Solr docs returned in THIS response
    end
    
    # @param expected_doc [Hash] key-val pairs indicating what should be matched in a document in the response
    # @example Expected Doc Hash
    #   {"id" => "666"}
    #   {"subject" => ["warm fuzzies", "fluffy"]}
    #   {"title" => "warm fuzzies", "subject" => ["puppies"]}
    # @example Expected Doc String 
    #   "666"  implies  {'id' => '666'}  when id_field is 'id'
    # @return true if this Solr Response contains a document hash which contains all the key-val pairs in the expected_doc
    def has_document?(expected_doc)
      if expected_doc.is_a?(Hash)
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
      elsif expected_doc.is_a?(String)
        has_document?({self.id_field => expected_doc})
      end
    end
    
    # access the Array of Hashes representing the Solr documents in the response
    def docs
      @docs ||= self["response"]["docs"]
    end

  end
end
