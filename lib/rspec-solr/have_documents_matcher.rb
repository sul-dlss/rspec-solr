
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
  
  # Define .have_documents
  # Determine if the receiver (a Solr response object) has at least one document
  rspec_namespace.define :have_documents do 
    match do |solr_resp|
      solr_resp["response"]["docs"].size > 0
    end

    failure_message_for_should do |solr_resp|
      "expected documents in Solr response #{solr_resp["response"]}"
    end
    
    failure_message_for_should_not do |solr_resp|
      "did not expect documents, but Solr response had #{solr_resp["response"]["docs"]}"
    end 
  end
  
end