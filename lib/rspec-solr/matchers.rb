
begin
  require 'rspec-expectations'
rescue LoadError
end

# Custom RSpec Matchers for Solr responses
module RSpecSolr::Matchers
  
  if defined?(::RSpec)
    rspec_namespace = ::RSpec::Matchers
  elsif defined?(::Spec)
    rspec_namespace = ::Spec::Matchers
  else
    raise NameError, "Cannot find Spec (rspec 1.x) or RSpec (rspec 2.x)"
  end
  
  # Determine if the receiver has solr documents
  def have_documents
    # Placeholder method for documentation purposes; 
    # the actual method is defined using RSpec's matcher DSL
  end
  
  # Determine if the receiver (a Solr response object) has at least
  #  one document
  rspec_namespace.define :have_documents do |document_matcher|
    match do |solr_resp|
      if !document_matcher
        solr_resp["response"]["docs"].size > 0
      else
        solr_resp.documents.any? { |doc| document_matcher.include? doc }
      end
    end

#    failure_message_for_should do |solr_resp|
#      "expected #{document_matcher.to_s} to be in #{solr_resp["response"]["docs"]}"
#    end
    
#    failure_message_for_should_not do |solr_response|
#      "did not expect #{document_matcher.to_s} to be in #{solr_resp["response"]["docs"]}"
#    end
    
  end

  def document finders = {}
    DocumentFinder.new finders
  end

  class DocumentFinder
    def initialize finders
      @finders = finders
    end

    def to_s
      @finders.to_s
    end

    def include? doc
      @finders.all? do |k, vals|
        Array(vals).any? do |v|
          doc[k] == v
        end
      end
    end
  end
  
end