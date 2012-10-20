# overriding and adding to RSpec::Matchers::Builtin::Include
# so we can use RSpec include matcher for document in Solr response
module RSpec
  module Matchers
    module BuiltIn
      class Include 
        
        # chain method for .should include().in_first(n)
        #  sets @max_doc_position for use in perform_match method
        # @return self - "each method must return self in order to chain methods together"
        def in_first(num=1)
          @max_doc_position = num
          self
        end
        
        alias_method :as_first, :in_first
        
        # chain method for .should include().before()
        #  sets @before_expected for use in perform_match method
        # @return self - "each method must return self in order to chain methods together"
        def before(expected)
          # get first doc position by calling has_document ???
          @before_expected = expected
          self
        end    

        # override failure message for improved readability
        def failure_message_for_should
          assert_ivars :@actual, :@expected
# FIXME: DRY up these messages across cases and across should and should_not
          if @before_expected
            "expected #{@actual.inspect} to #{name_to_sentence} #{doc_label_str(@expected)}#{expected_to_sentence} before #{doc_label_str(@before_expected)} matching #{@before_expected.inspect}"
          elsif @max_doc_position
            "expected #{@actual.inspect} to #{name_to_sentence} #{doc_label_str(@expected)}#{expected_to_sentence} in first #{@max_doc_position.to_s} results"
          else
            super
          end
        end
        
        # override failure message for improved readability
        def failure_message_for_should_not
          assert_ivars :@actual, :@expected
          if @before_expected
            "expected #{@actual.inspect} not to #{name_to_sentence} #{doc_label_str(@expected)}#{expected_to_sentence} before #{doc_label_str(@before_expected)} matching #{@before_expected.inspect}"
          elsif @max_doc_position
            "expected #{@actual.inspect} not to #{name_to_sentence} #{doc_label_str(@expected)}#{expected_to_sentence} in first #{@max_doc_position.to_s} results"
          else
            super
          end
        end
        

private        
        # overriding method so we can use RSpec include matcher for document in Solr response
        #   my_solr_resp_hash.should include({"id" => "666"})
        def perform_match(predicate, hash_predicate, actuals, expecteds)
          expecteds.send(predicate) do |expected|
            if comparing_doc_to_solr_resp_hash?(actuals, expected)
              if @before_expected
                before_ix = actuals.get_first_doc_index(@before_expected)
                if before_ix
                  @max_doc_position = before_ix + 1
                else
                  # make the desired result impossible
                  @max_doc_position = -1
                end
              end
              actuals.has_document?(expected, @max_doc_position)
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
        
        def method_missing(method, *args, &block)
          if (method =~ /documents?/ || method =~ /results?/)
            @collection_name = method
            @args = args
            @block = block
            self
          else
            super.method_missing
          end
        end
        
        # @return [String] 'documents' or 'document' as indicated by expectation
        def doc_label_str(expectations)
# FIXME: must be a better way to do pluralize and inflection fun            
          if expectations.is_a?(Array) && 
              (expectations.size > 1 || (expectations.first.is_a?(Array) && expectations.first.size > 1))
            docs = "documents"
          else
            docs = "document"
          end
        end
        
      end # class Include
    end # module BuiltIn
  end
end