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

  end
end
