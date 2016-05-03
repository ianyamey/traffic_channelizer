require 'spec_helper'

module ChannelGrouping
  describe Referrer do
    before { parser.clear! }

    describe '#medium' do
      context 'when the url matches one of the parser rules' do
        let(:url) { 'http://some-site.com' }

        before do
          parser.add_referer('some-medium', 'some-source', 'some-site.com')
        end

        it 'returns the medium from the parser' do
          expect(Referrer.new(url).medium).to eq 'some-medium'
        end
      end

      context 'when the url does not match any of the parser rules' do
        let(:url) { 'http://www.some-unmatched-site.com' }

        it 'returns (none)' do
          expect(Referrer.new(url).medium).to be nil
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns (none)' do
          expect(Referrer.new(url).medium).to be nil
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns (none)' do
          expect(Referrer.new(url).medium).to be nil
        end
      end
    end

    describe '#source' do
      context 'when the url matches one of the parser rules' do
        let(:url) { 'http://some-site.com' }

        before do
          parser.add_referer('some-medium', 'some-source', 'some-site.com')
        end

        it 'returns the source from the parser' do
          expect(Referrer.new(url).source).to eq 'some-source'
        end
      end

      context 'when the url does not match any of the parser rules' do
        let(:url) { 'http://www.some-unmatched-site.com' }

        it 'uses the domain for the source' do
          expect(Referrer.new(url).source).to eq 'some-unmatched-site.com'
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns nil' do
          expect(Referrer.new(url).source).to be nil
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns nil' do
          expect(Referrer.new(url).source).to be nil
        end
      end
    end

    describe '#domain' do
      context 'when the url is present' do
        let(:url) { 'http://some-site.com/some/path' }

        it 'returns the domain' do
          expect(Referrer.new(url).domain).to eq 'some-site.com'
        end
      end

      context 'when the url includes the www subdomain' do
        let(:url) { 'http://www.some-site.com/some/path' }

        it 'returns the domain without the www' do
          expect(Referrer.new(url).domain).to eq 'some-site.com'
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns nil' do
          expect(Referrer.new(url).domain).to be nil
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns nil' do
          expect(Referrer.new(url).domain).to be nil
        end
      end

      context 'when the url is invalid' do
        let(:url) { 'http|someinvalidurl?a|b' }

        it 'returns nil' do
          expect(Referrer.new(url).domain).to be nil
        end
      end
    end

    describe '#term' do
      context 'when the url matches one of the parser rules' do
        before do
          parser.add_referer('search', 'some-source', 'some-site.com', %w(query q))
        end

        context 'and it has a param that matches one the terms' do
          let(:url) { 'http://some-site.com/some/path?q=some-term' }

          it 'returns the term extracted from the query string' do
            expect(Referrer.new(url).term).to eq 'some-term'
          end
        end

        context 'and none of the params match any of the terms' do
          let(:url) { 'http://some-site.com?foo=bar' }

          it 'returns nil' do
            expect(Referrer.new(url).term).to be nil
          end
        end
      end

      context 'when the url does not match any of the parser rules' do
        let(:url) { 'http://www.some-unmatched-site.com?q=some-query' }

        it 'uses the domain for the source' do
          expect(Referrer.new(url).term).to be nil
        end
      end

      context 'when the url is a blank string' do
        let(:url) { '' }

        it 'returns nil' do
          expect(Referrer.new(url).term).to be nil
        end
      end

      context 'when the url is nil' do
        let(:url) { nil }

        it 'returns nil' do
          expect(Referrer.new(url).term).to be nil
        end
      end
    end

    def parser
      ChannelGrouping::Referrer.parser
    end
  end
end
