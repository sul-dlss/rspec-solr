require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  # fixtures below
  context 'should have_facet_field()' do
    it 'passes if response has the facet field' do
      expect(@solr_resp_w_facets).to have_facet_field('ff1')
      expect(@solr_resp_w_facets).to have_facet_field('ff2')
    end
    it 'passes if response has facet field but no values' do
      expect(@solr_resp_w_facets).to have_facet_field('ff3')
    end
    it 'fails if response does not have the facet field' do
      expect do
        expect(@solr_resp_w_facets).to have_facet_field('ff4')
      end.to raise_error.with_message a_string_including 'expected facet field ff4 with values in Solr response: '
    end
  end

  context 'should_NOT have_facet_field()' do
    it 'fails if response has the facet field' do
      expect do
        expect(@solr_resp_w_facets).not_to have_facet_field('ff1')
      end.to raise_error.with_message a_string_including 'expected no ff1 facet field in Solr response: '
      expect do
        expect(@solr_resp_w_facets).not_to have_facet_field('ff2')
      end.to raise_error.with_message a_string_including 'expected no ff2 facet field in Solr response: '
    end
    it 'fails if response has facet field but no values' do
      expect do
        expect(@solr_resp_w_facets).not_to have_facet_field('ff3')
      end.to raise_error.with_message a_string_including 'expected no ff3 facet field in Solr response: '
    end
    it 'passes if response does not have the facet field' do
      expect(@solr_resp_w_facets).not_to have_facet_field('ff4')
    end
  end

  context 'should have_facet_field().with_value()' do
    it 'passes if response has the facet field with the value' do
      expect(@solr_resp_w_facets).to have_facet_field('ff1').with_value('val12')
    end
    it 'fails if response has the facet field without the value' do
      expect do
        expect(@solr_resp_w_facets).to have_facet_field('ff1').with_value('val22')
      end.to raise_error.with_message a_string_including 'expected facet field ff1 with value val22 in Solr response'
    end
    it 'fails if response has facet field but no values' do
      expect do
        expect(@solr_resp_w_facets).to have_facet_field('ff3').with_value('val')
      end.to raise_error.with_message a_string_including 'expected facet field ff3 with value val in Solr response'
    end
    it 'fails if response does not have the facet field' do
      expect do
        expect(@solr_resp_w_facets).to have_facet_field('ff4').with_value('val')
      end.to raise_error.with_message a_string_including 'expected facet field ff4 with value val in Solr response'
    end
  end
  context 'should_NOT have_facet_field().with_value()' do
    it 'fails if response has the facet field with the value' do
      expect do
        expect(@solr_resp_w_facets).not_to have_facet_field('ff1').with_value('val12')
      end.to raise_error.with_message a_string_including 'expected facet field ff1 not to have value val12 in Solr response'
    end
    it 'passes if response has the facet field without the value' do
      expect(@solr_resp_w_facets).not_to have_facet_field('ff1').with_value('val22')
    end
    it 'passes if response has facet field but no values' do
      expect(@solr_resp_w_facets).not_to have_facet_field('ff3').with_value('val')
    end
    it 'fails if response does not have the facet field' do
      expect do
        expect(@solr_resp_w_facets).not_to have_facet_field('ff4').with_value('val')
      end.to raise_error.with_message a_string_including 'expected facet field ff4 in Solr response'
    end
  end

  before(:all) do
    @solr_resp_w_facets = RSpecSolr::SolrResponseHash.new(
      'response' =>
        { 'numFound' => 5,
          'start' => 0,
          'docs' => [] },
      'facet_counts' =>
        { 'facet_queries' => {},
          'facet_fields' => {
            'ff1' => ['val11', 111, 'val12', 22, 'val13', 3],
            'ff2' => ['val21', 10, 'val22', 5, 'val23', 1],
            'ff3' => []
          },
          'facet_dates' => {},
          'facet_ranges' => {}
        })
  end
end
