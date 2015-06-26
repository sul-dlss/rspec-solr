require 'spec_helper'
require 'rspec-solr'

describe RSpecSolr do
  context "shouldn't break RSpec #have matcher" do
    it 'for Array' do
      expect([1, 2, 3]).to have(3).items
      expect([1, 2, 3]).not_to have(4).items
      expect([1, 2, 3]).to have_at_least(2).items
      expect([1, 2, 3]).to have_at_least(1).item
      expect([1, 2, 3]).to have_at_most(5).items
    end

    it 'for Hash' do
      expect(k1: 'v1', k2: 'v2', k3: 'v3').to have_exactly(3).items
      expect(k1: 'v1', k2: 'v2', k3: 'v3').not_to have(4).items
      expect(k1: 'v1', k2: 'v2', k3: 'v3').to have_at_least(2).items
      expect(k1: 'v1', k2: 'v2', k3: 'v3').to have_at_most(5).items
    end

    it 'for String' do
      expect('this string').to have(11).characters
      expect('this string').not_to have(12).characters
    end

    it 'passes args to target' do
      target = double('target')
      expect(target).to receive(:items).with('arg1', 'arg2').and_return([1, 2, 3])
      expect(target).to have(3).items('arg1', 'arg2')
    end
    it 'passes block to target' do
      target = double('target')
      block = -> { 5 }
      expect(target).to receive(:items).with('arg1', 'arg2', block).and_return([1, 2, 3])
      expect(target).to have(3).items('arg1', 'arg2', block)
    end
  end

  # fixtures at end of this file

  context 'should have(n).documents' do
    it "pluralizes 'documents'" do
      expect(@solr_resp_1_doc).to have(1).document
    end

    it 'passes if target response has n documents' do
      expect(@solr_resp_5_docs).to have(5).documents
      expect(@solr_resp_no_docs).to have(0).documents
    end

    it 'converts :no to 0' do
      expect(@solr_resp_no_docs).to have(:no).documents
    end

    it 'converts a String argument to Integer' do
      expect(@solr_resp_5_docs).to have('5').documents
    end

    it 'fails if target response has < n documents' do
      expect do
        expect(@solr_resp_5_docs).to have(6).documents
      end.to raise_error.with_message 'expected 6 documents, got 5'
      expect do
        expect(@solr_resp_no_docs).to have(1).document
      end.to raise_error.with_message 'expected 1 document, got 0'
    end

    it 'fails if target response has > n documents' do
      expect do
        expect(@solr_resp_5_docs).to have(4).documents
      end.to raise_error.with_message 'expected 4 documents, got 5'
      expect do
        expect(@solr_resp_1_doc).to have(0).documents
      end.to raise_error.with_message 'expected 0 documents, got 1'
    end
  end

  context 'should_not have(n).documents' do
    it 'passes if target response has < n documents' do
      expect(@solr_resp_5_docs).not_to have(6).documents
      expect(@solr_resp_1_doc).not_to have(2).documents
      expect(@solr_resp_no_docs).not_to have(1).document
    end

    it 'passes if target response has > n documents' do
      expect(@solr_resp_5_docs).not_to have(4).documents
      expect(@solr_resp_1_doc).not_to have(0).documents
      expect(@solr_resp_no_docs).not_to have(-1).documents
    end

    it 'fails if target response has n documents' do
      expect do
        expect(@solr_resp_5_docs).not_to have(5).documents
      end.to raise_error.with_message 'expected target not to have 5 documents, got 5'
    end
  end

  context 'should have_exactly(n).documents' do
    it 'passes if target response has n documents' do
      expect(@solr_resp_5_docs).to have_exactly(5).documents
      expect(@solr_resp_no_docs).to have_exactly(0).documents
    end
    it 'converts :no to 0' do
      expect(@solr_resp_no_docs).to have_exactly(:no).documents
    end
    it 'fails if target response has < n documents' do
      expect do
        expect(@solr_resp_5_docs).to have_exactly(6).documents
      end.to raise_error.with_message 'expected 6 documents, got 5'
      expect do
        expect(@solr_resp_no_docs).to have_exactly(1).document
      end.to raise_error.with_message 'expected 1 document, got 0'
    end

    it 'fails if target response has > n documents' do
      expect do
        expect(@solr_resp_5_docs).to have_exactly(4).documents
      end.to raise_error.with_message 'expected 4 documents, got 5'
      expect do
        expect(@solr_resp_1_doc).to have_exactly(0).documents
      end.to raise_error.with_message 'expected 0 documents, got 1'
    end
  end

  context 'should have_at_least(n).documents' do
    it 'passes if target response has n documents' do
      expect(@solr_resp_5_docs).to have_at_least(5).documents
      expect(@solr_resp_1_doc).to have_at_least(1).document
      expect(@solr_resp_no_docs).to have_at_least(0).documents
    end

    it 'passes if target response has > n documents' do
      expect(@solr_resp_5_docs).to have_at_least(4).documents
      expect(@solr_resp_1_doc).to have_at_least(0).documents
    end

    it 'fails if target response has < n documents' do
      expect do
        expect(@solr_resp_5_docs).to have_at_least(6).documents
      end.to raise_error.with_message 'expected at least 6 documents, got 5'
      expect do
        expect(@solr_resp_no_docs).to have_at_least(1).document
      end.to raise_error.with_message 'expected at least 1 document, got 0'
    end

    it 'provides educational negative failure messages' do
      # given
      my_matcher = have_at_least(6).documents
      # when
      my_matcher.matches?(@solr_resp_5_docs)
      # then
      expect(my_matcher.failure_message_for_should_not).to eq <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  expect(actual).not_to have_at_least(6).documents
We recommend that you use this instead:
  expect(actual).to have_at_most(5).documents
EOF
    end
  end

  context 'should have_at_most(n).documents' do
    it 'passes if target response has n documents' do
      expect(@solr_resp_5_docs).to have_at_most(5).documents
      expect(@solr_resp_1_doc).to have_at_most(1).document
      expect(@solr_resp_no_docs).to have_at_most(0).documents
    end

    it 'passes if target response has < n documents' do
      expect(@solr_resp_5_docs).to have_at_most(6).documents
      expect(@solr_resp_no_docs).to have_at_most(1).document
    end

    it 'fails if target response has > n documents' do
      expect do
        expect(@solr_resp_5_docs).to have_at_most(4).documents
      end.to raise_error.with_message 'expected at most 4 documents, got 5'
      expect do
        expect(@solr_resp_1_doc).to have_at_most(0).documents
      end.to raise_error.with_message 'expected at most 0 documents, got 1'
    end

    it 'provides educational negative failure messages' do
      # given
      my_matcher = have_at_most(4).documents
      # when
      my_matcher.matches?(@solr_resp_5_docs)
      # then
      expect(my_matcher.failure_message_for_should_not).to eq <<-EOF
Isn't life confusing enough?
Instead of having to figure out the meaning of this:
  expect(actual).not_to have_at_most(4).documents
We recommend that you use this instead:
  expect(actual).to have_at_least(5).documents
EOF
    end
  end

  it 'should pass according to total Solr docs matching the query, not the number of docs in THIS response' do
    solr_resp = RSpecSolr::SolrResponseHash.new('response' =>
                          { 'numFound' => 3,
                            'start' => 0,
                            'rows' => 1,
                            'docs' => [{ 'id' => '111' }]
                          })
    expect(solr_resp).to have(3).documents
    expect(solr_resp).not_to have(1).document
    solr_resp = RSpecSolr::SolrResponseHash.new('response' =>
                          { 'numFound' => 3,
                            'start' => 0,
                            'rows' => 0
                          })
    expect(solr_resp).to have(3).documents
  end

  before(:all) do
    @solr_resp_1_doc = RSpecSolr::SolrResponseHash.new('response' =>
                          { 'numFound' => 1,
                            'start' => 0,
                            'docs' => [{ 'id' => '111' }]
                          })

    @solr_resp_5_docs = RSpecSolr::SolrResponseHash.new('response' =>
                          { 'numFound' => 5,
                            'start' => 0,
                            'docs' =>
                              [{ 'id' => '111' },
                               { 'id' => '222' },
                               { 'id' => '333' },
                               { 'id' => '444' },
                               { 'id' => '555' }
                              ]
                          })

    @solr_resp_no_docs = RSpecSolr::SolrResponseHash.new('response' =>
                          { 'numFound' => 0,
                            'start' => 0,
                            'docs' => []
                          })
  end
end
