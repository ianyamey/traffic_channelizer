require 'spec_helper'

module ChannelGrouping
  describe Medium do
    describe '.from_url' do
      context 'when the url contains a utm_medium' do
        let(:url) { 'http://example.com?utm_medium=some-medium' }

        it 'extracts the utm_medium' do
          expect(Medium.from_url(url)).to eq 'some-medium'
        end
      end

      context 'when the url does not contain a utm_medium' do
        let(:url) { 'http://example.com?foo=bar' }

        it "returns 'none'" do
          expect(Medium.from_url(url)).to eq 'none'
        end
      end

      context 'when there are no query params' do
        let(:url) { 'http://example.com' }

        it "returns 'none'" do
          expect(Medium.from_url(url)).to eq 'none'
        end
      end
    end
  end
end
