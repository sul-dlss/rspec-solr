require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do

  # fixtures below
  context "should have_facet_field()" do
    it "passes if response has the facet field" do
      @solr_resp_w_facets.should have_facet_field('ff1')
      @solr_resp_w_facets.should have_facet_field('ff2')
    end
    it "fails if response does not have the facet field" do
      lambda {
        @solr_resp_w_facets.should have_facet_field('ff4')
      }.should fail_matching("expected facet field ff4 with values in Solr response: ")
    end
    it "fails if response has facet field but no values" do
      lambda {
        @solr_resp_w_facets.should have_facet_field('ff3')
      }.should fail_matching("expected facet field ff3 with values in Solr response: ")
    end
  end
  
  context "should_NOT have_facet_field()" do
    it "fails if response has the facet field" do
      lambda {
        @solr_resp_w_facets.should_not have_facet_field('ff1')
      }.should fail_matching("expected no values for facet field ff1 in Solr response: ")
      lambda {
        @solr_resp_w_facets.should_not have_facet_field('ff2')
      }.should fail_matching("expected no values for facet field ff2 in Solr response: ")
    end
    it "passes if response does not have the facet field" do
      @solr_resp_w_facets.should_not have_facet_field('ff4')
    end
    it "passes if response has facet field but no values" do
      @solr_resp_w_facets.should_not have_facet_field('ff3')
    end
  end

  
  before(:all) do
    @solr_resp_w_facets = RSpecSolr::SolrResponseHash.new(
                          { "response" =>
                            { "numFound" => 5, 
                              "start" => 0, 
                              "docs" => []},
                            "facet_counts" => 
                            { "facet_queries" => {},
                              "facet_fields" => {
                                'ff1' => ['val11', 111, 'val12', 22, 'val13', 3],
                                'ff2' => ['val21', 10, 'val22', 5, 'val23', 1],
                                'ff3' => []
                              },
                              'facet_dates'=>{},
                              'facet_ranges'=>{}
                            }
                          })
  end
  
end