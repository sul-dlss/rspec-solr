# overriding and adding to RSpec::Matchers::Builtin::Include
# so we can use RSpec include matcher for document in Solr response
module RSpec
  module Matchers
    module BuiltIn
      class Include
        # chain method for .should include().in_first(n)
        #  sets @max_doc_position for use in perform_match method
        # @return self - "each method must return self in order to chain methods together"
        def in_first(num = 1)
          @max_doc_position = num
          self
        end

        alias_method :as_first, :in_first

        # chain method for .should include().in_each_of_first(n)
        #  sets @min_for_last_matching_doc_ix for use in perform_match method
        # @return self - "each method must return self in order to chain methods together"
        def in_each_of_first(num = 1)
          @min_for_last_matching_doc_pos = num
          self
        end

        # chain method for .should include().before()
        #  sets @before_expected for use in perform_match method
        # @return self - "each method must return self in order to chain methods together"
        def before(expected)
          # get first doc position by calling has_document ???
          @before_expected = expected
          self
        end

        # override failure message for improved readability
        def failure_message
          assert_ivars :@actual, :@expecteds
          name_to_sentence = 'include'
          # FIXME: DRY up these messages across cases and across should and should_not
          if @before_expected
            "expected response to #{name_to_sentence} #{doc_label_str(@expecteds)}#{to_sentence(@expecteds)} before #{doc_label_str(@before_expected)} matching #{@before_expected.inspect}: #{@actual.inspect} "
          elsif @min_for_last_matching_doc_pos
            "expected each of the first #{@min_for_last_matching_doc_pos} documents to #{name_to_sentence}#{to_sentence(@expecteds)} in response: #{@actual.inspect}"
          elsif @max_doc_position
            "expected response to #{name_to_sentence} #{doc_label_str(@expecteds)}#{to_sentence(@expecteds)} in first #{@max_doc_position} results: #{@actual.inspect}"
          else
            super
          end
        end

        # override failure message for improved readability
        def failure_message_when_negated
          assert_ivars :@actual, :@expecteds
          name_to_sentence = 'include'
          if @before_expected
            "expected response not to #{name_to_sentence} #{doc_label_str(@expecteds)}#{to_sentence(@expecteds)} before #{doc_label_str(@before_expected)} matching #{@before_expected.inspect}: #{@actual.inspect} "
          elsif @min_for_last_matching_doc_pos
            "expected some of the first #{@min_for_last_matching_doc_pos} documents not to #{name_to_sentence}#{to_sentence(@expecteds)} in response: #{@actual.inspect}"
          elsif @max_doc_position
            "expected response not to #{name_to_sentence} #{doc_label_str(@expecteds)}#{to_sentence(@expecteds)} in first #{@max_doc_position} results: #{@actual.inspect}"
          else
            super
          end
        end

        private

        # overriding method so we can use RSpec include matcher for document in Solr response
        #   my_solr_resp_hash.should include({"id" => "666"})

        def excluded_from_actual
          return [] unless @actual.respond_to?(:include?)

          expecteds.each_with_object([]) do |expected_item, memo|
            if comparing_doc_to_solr_resp_hash?(expected_item)
              if @before_expected
                before_ix = actual.get_first_doc_index(@before_expected)
                if before_ix
                  @max_doc_position = before_ix + 1
                else
                  # make the desired result impossible
                  @max_doc_position = -1
                end
              end
              if @min_for_last_matching_doc_pos
                memo << expected_item unless yield actual.has_document?(expected_item, @min_for_last_matching_doc_pos, true)
              else
                memo << expected_item unless yield actual.has_document?(expected_item, @max_doc_position)
              end
            elsif comparing_hash_to_a_subset?(expected_item)
              expected_item.each do |(key, value)|
                memo << { key => value } unless yield actual_hash_includes?(key, value)
              end
            elsif comparing_hash_keys?(expected_item)
              memo << expected_item unless yield actual_hash_has_key?(expected_item)
            else
              memo << expected_item unless yield actual_collection_includes?(expected_item)
            end
          end
        end

        # is actual param a SolrResponseHash?
        def comparing_doc_to_solr_resp_hash?(expected_item)
          actual.is_a?(RSpecSolr::SolrResponseHash) && !expected_item.is_a?(RSpecSolr::SolrResponseHash)
        end

        def method_missing(method, *args, &block)
          if method =~ /documents?/ || method =~ /results?/
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
            'documents'
          else
            'document'
          end
        end

        def to_sentence(words = [])
          words = words.map(&:inspect)
          case words.length
          when 0
            ''
          when 1
            " #{words[0]}"
          when 2
            " #{words[0]} and #{words[1]}"
          else
            " #{words[0...-1].join(', ')}, and #{words[-1]}"
          end
        end
      end # class Include
    end # module BuiltIn
  end
end
