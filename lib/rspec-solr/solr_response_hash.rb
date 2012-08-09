require 'delegate'
# # NAOMI_MUST_COMMENT_THIS_MODULE
class RSpecSolr
  # # NAOMI_MUST_COMMENT_THIS_CLASS
  class SolrResponseHash < DelegateClass(Hash)
    # @param Hash a Solr response 
#    def initialize(solr_resp_as_hash)
#      @orig_solr_resp = solr_resp_as_hash
#    end
    
    # NAOMI_MUST_COMMENT_THIS_METHOD
    def size
      self["response"]["docs"].size
    end


  end
end
