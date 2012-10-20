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
      self["response"] ? self["response"]["numFound"] : 0  # total number of Solr docs matching query
      # NOT:  self["response"]["docs"].size  # number of Solr docs returned in THIS response
    end
    
    # @return true if THIS Solr Response contains document(s) as indicated by expected_doc
    # @param expected_doc what should be matched in a document in THIS response
    # @example expected_doc Hash implies ALL key/value pairs will be matched in a SINGLE Solr document
    #   {"id" => "666"}
    #   {"subject" => ["warm fuzzies", "fluffy"]}
    #   {"title" => "warm fuzzies", "subject" => ["puppies"]}
    # @example expected_doc String 
    #   "666"  implies  {'id' => '666'}  when id_field is 'id'
    # @example expected_doc Array
    #   ["1", "2", "3"]  implies we expect Solr docs with ids 1, 2, 3 included in this response
    #   [{"title" => "warm fuzzies"}, {"title" => "cool fuzzies"}]  implies we expect at least one Solr doc in this response matching each Hash in the Array
    #   [{"title" => /rm fuzz/}, {"title" => /^cool/}]  implies we expect at least one Solr doc in this response matching each Hash in the Array
    # @param [FixNum] max_doc_position maximum acceptable position (1-based) of document in results.  (e.g. if 2, it must be the 1st or 2nd doc in the results)
    def has_document?(expected_doc, max_doc_position = nil, all_must_match = nil)
      if expected_doc.is_a?(Hash)
        if all_must_match
          first_non_match = docs.find_index { |doc| 
            !doc_matches_all_criteria(doc, expected_doc)
          } >= max_doc_position
        else
          # we are happy if any doc meets all of our expectations
          docs.any? { |doc| 
            doc_matches_all_criteria(doc, expected_doc) &&
              # satisfy doc's position in the results
              (max_doc_position ? docs.find_index(doc) < max_doc_position : true)
          }
        end
      elsif expected_doc.is_a?(String)
        if all_must_match
          raise ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method"
        end
        has_document?({self.id_field => expected_doc}, max_doc_position)
      elsif expected_doc.is_a?(Array)
        if all_must_match
          raise ArgumentError, "in_each_of_first(n) requires a Hash argument to include() method"
        end
        expected_doc.all? { |exp| has_document?(exp, max_doc_position) }
      end   
    end

    # return true if the document contains all the key value pairs in the expectations_hash
    def doc_matches_all_criteria(doc, expectations_hash)
      expectations_hash.all? { | exp_fname, exp_vals |
        doc.include?(exp_fname) && 
          # exp_vals can be a String or an Array
          # if it's an Array, then all expected values must be present
          Array(exp_vals).all? { | exp_val |
            # a doc's fld values can be a String or an Array
            case exp_val
              when Regexp
                Array(doc[exp_fname]).any? { |val| val =~ exp_val }
              else
                Array(doc[exp_fname]).include?(exp_val)
            end
          }
      }
    end

    # @return the index of the first document that meets the expectations in THIS response
    # @param expected_doc what should be matched in a document in THIS response
    # @example expected_doc Hash implies ALL key/value pairs will be matched in a SINGLE Solr document
    #   {"id" => "666"}
    #   {"subject" => ["warm fuzzies", "fluffy"]}
    #   {"title" => "warm fuzzies", "subject" => ["puppies"]}
    # @example expected_doc String 
    #   "666"  implies  {'id' => '666'}  when id_field is 'id'
    # @example expected_doc Array
    #   ["1", "2", "3"]  implies we expect Solr docs with ids 1, 2, 3 included in this response
    #   [{"title" => "warm fuzzies"}, {"title" => "cool fuzzies"}]  implies we expect at least one Solr doc in this response matching each Hash in the Array
    def get_first_doc_index(expected_doc)
# FIXME:  DRY it up! -- very similar to has_document
      if expected_doc.is_a?(Hash)
        # we are happy if any doc meets all of our expectations
        docs.any? { |doc| 
          expected_doc.all? { | exp_fname, exp_vals |
            if (doc.include?(exp_fname) && 
                # exp_vals can be a String or an Array
                # if it's an Array, then all expected values must be present
                Array(exp_vals).all? { | exp_val |
                  # a doc's fld values can be a String or an Array
                  Array(doc[exp_fname]).include?(exp_val)
                }) 
              first_doc_index = get_min_index(first_doc_index, docs.find_index(doc))
              return first_doc_index
            end
          }
        }
      elsif expected_doc.is_a?(String)
        first_doc_index = get_min_index(first_doc_index, get_first_doc_index({self.id_field => expected_doc}))
      elsif expected_doc.is_a?(Array)
        expected_doc.all? { |exp| 
          ix = get_first_doc_index(exp)
          if ix
            first_doc_index = get_min_index(first_doc_index, ix)
          else
            return nil
          end
        }
      end  

      return first_doc_index
    end

    # @return String containing response header and numFound parts of hash for readable output for number of docs messages
    def num_docs_partial_output_str
      "{'responseHeader' => #{self['responseHeader'].inspect}, " + 
        (self['response'] ? "'response' => {'numFound' => #{self['response']['numFound']}, ...}" : "" ) + 
        " ... }"
    end

private
    
    # return the minimum of the two arguments.  If one of the arguments is nil, then return the other argument.
    # If both arguments are nil, return nil.
    def get_min_index(a, b)
      if a
        if b
          [a, b].min
        else # b is nil
          a
        end
      else # a is nil
        b
      end
    end

    # access the Array of Hashes representing the Solr documents in the response
    def docs
      @docs ||= self["response"]["docs"]
    end

  end
end
