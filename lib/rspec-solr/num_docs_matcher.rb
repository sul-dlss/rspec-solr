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
  
  # NAOMI_MUST_COMMENT_THIS_METHOD
  def comparators
    @comparators ||= {
      :exactly => "", 
      :at_least => "at least ",
      :at_most => "at most "
    }
  end

  # Define .have(n).documents
  # Determine if the receiver (a Solr response object) has the expected number of documents
  rspec_namespace.define :have do |num_docs|
    @num_expected = case num_docs
            when :no then 0
            when String then num_docs.to_i
            else num_docs
          end

    match do |solr_resp|
      @num_actual = solr_resp["response"]["docs"].size
      @num_actual == @num_expected
    end
    
    chain :documents do
    end 
    
    chain :document do
    end 

    failure_message_for_should do |solr_resp|
      if @num_expected == 1
        "expected #{@num_expected} document; got #{@num_actual}"
      else
        "expected #{@num_expected} documents; got #{@num_actual}"
      end
    end

    failure_message_for_should_not do |solr_resp|
      if @num_expected == 1
        "expected not to have #{@num_expected} document; got #{@num_actual}"
      else
        "expected not to have #{@num_expected} documents; got #{@num_actual}"
      end
    end
    
  end # define :have(n).documents

end