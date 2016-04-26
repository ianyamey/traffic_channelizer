require 'spec_helper'

describe ChannelGrouping do
  it 'has a version number' do
    expect(ChannelGrouping::VERSION).not_to be nil
  end

  describe '.identify' do
    subject do
      ChannelGrouping.identify(
        source_url: source_url,
        destination_url: destination_url
      )
    end

    let(:url) { 'http://example.com?utm_source=some_source' }
    let(:source_url) { 'http://external.site' }
    let(:destination_url) do
      "http://example.com/foo?utm_source=some-source&utm_medium=#{utm_medium}"
    end
    let(:source) { instance_double(ChannelGrouping::Source, direct?: false, search_engine?: false) }

    before do
      allow(ChannelGrouping::Source)
        .to receive(:new)
        .with(source_url)
        .and_return(source)
    end

    describe 'Organic Search' do
      context 'when the medium exactly matches organic' do
        let(:utm_medium) { 'organic' }

        it 'returns Organic' do
          expect(subject).to eq 'Organic'
        end
      end

      context 'when the source is a search engine' do
        let(:destination_url) { 'http://example.com/foo' }

        let(:source) { instance_double(ChannelGrouping::Source, search_engine?: true, direct?: false) }

        it 'returns Organic' do
          expect(subject).to eq 'Organic'
        end
      end
    end

    # Direct
      # ChannelGrouping::Source exactly matches Direct 
      # AND
      # Medium exactly matches (not set)
      # OR
      # Medium exactly matches (none)
    context 'when the source is direct' do
      let(:source) { instance_double(ChannelGrouping::Source, direct?: true, search_engine?: false) }

      context 'and the medium is not set' do
        let(:destination_url) { 'http://example.com/foo' }

        it 'returns Direct' do
          expect(subject).to eq 'Direct'
        end
      end

      context 'and the medium is none' do
        let(:utm_medium) { 'none' }

        it 'returns Direct' do
          expect(subject).to eq 'Direct'
        end
      end

      context 'and the medium is set' do
        let(:utm_medium) { 'some_medium' }

        it 'does not return Direct' do
          expect(subject).not_to eq 'Direct'
        end
      end
    end

    context 'when source is not is a not direct' do

    end

    # Organic Search
      # Medium exactly matches organic
    # Social
      # Social Source Referral exactly matches Yes
      # OR
      # Medium matches regex ^(social|social-network|social-media|sm|social network|social media)$

    context 'when the medium exactly matches email' do
      let(:utm_medium) { 'email' }

      it 'returns Email' do
        expect(subject).to eq 'Email'
      end
    end

    context 'when the medium exactly matches affiliate' do
      let(:utm_medium) { 'affiliate' }

      it 'returns Affiliates' do
        expect(subject).to eq 'Affiliates'
      end
    end

    context 'when the medium exactly matches referral' do
      let(:utm_medium) { 'referral' }

      it 'returns Referral' do
        expect(subject).to eq 'Referral'
      end
    end

    describe 'Paid Search' do
      # Medium matches regex ^(cpc|ppc|paidsearch)$
      # AND
      # Ad Distribution Network does not exactly match Content
      %w(cpc ppc paidsearch).each do |paid_search_medium|
        context "when the medium exactly matches #{paid_search_medium}" do
          let(:utm_medium) { paid_search_medium }

          it 'returns Paid Search' do
            expect(subject).to eq 'Paid Search'
          end

          context 'when the Ad Distribution Network does not match Content' do
            # TODO Determine how Google categorizes the Ad Distribution Network as 'Content'
            xit 'returns Paid Search'
          end
        end
      end

    end

    describe 'Other Advertising' do
      # Medium matches regex ^(cpv|cpa|cpp)$
      %w(cpv cpa cpp).each do |other_advertising_medium|
        context "when the medium exactly matches #{other_advertising_medium}" do
          let(:utm_medium) { other_advertising_medium }

          it 'returns Other Advertising' do
            expect(subject).to eq 'Other Advertising'
          end
        end
      end
    end

    describe 'Display' do
      # Medium matches regex ^(display|cpm|banner)$
      # OR
      # Ad Distribution Network exactly matches Content
      context 'when the Ad Distribution Network matches Content' do
        # TODO Determine how Google categorizes the Ad Distribution Network as 'Content'
        xit 'returns Display'
      end

      %w(display cpm banner).each do |other_advertising_medium|
        context "when the medium exactly matches #{other_advertising_medium}" do
          let(:utm_medium) { other_advertising_medium }

          it 'returns Display' do
            expect(subject).to eq 'Display'
          end
        end
      end
    end

    describe 'Other' do
      context 'when no other rules match' do
        let(:utm_medium) { 'some-medium' }

        it 'returns Other' do
          expect(subject).to eq 'Other'
        end
      end
    end
  end
end
