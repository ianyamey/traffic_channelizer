require 'spec_helper'

module ChannelGrouping
  describe Source do
    describe '#direct?' do
      context 'when the url is present' do
        let(:url) { 'http://some-site.com' }

        it 'returns false' do
          expect(Source.new(url).direct?).to be false
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns true' do
          expect(Source.new(url).direct?).to be true
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns true' do
          expect(Source.new(url).direct?).to be true
        end
      end
    end

    describe '#search_engine?' do
      let(:url) { "http://#{host}/some-path?#{query_string}" }

      before do
        Source.search_engines << { host: /search-engine.com/, search_query_param_key: 'q' }
      end

      context 'when the source host matches a search engine' do
        let(:host) { 'www.search-engine.com' }

        context 'and the query string contain the search query parameter' do
          let(:query_string) { 'q=some_search_query' }

          it 'returns true' do
            expect(Source.new(url).search_engine?).to be true
          end
        end

        context 'and the query string does not contain the search query parameter' do
          let(:query_string) { 'foo=bar' }

          it 'returns false' do
            expect(Source.new(url).search_engine?).to be false
          end
        end

        context 'and the query string is nil' do
          let(:query_string) { nil }

          it 'returns false' do
            expect(Source.new(url).search_engine?).to be false
          end
        end
      end

      context 'when the source host does not match any search engine hosts' do
        let(:host) { 'www.not-a-search-engine.com' }
        let(:query_string) { nil }

        it 'returns false' do
          expect(Source.new(url).search_engine?).to be false
        end
      end
    end
  end
end
