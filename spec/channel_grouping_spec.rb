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
    let(:destination_url) { double(:destination_url) }
    let(:source) do
      instance_double(
        ChannelGrouping::Source,
        direct?: direct,
        search_engine?: search_engine,
        social_network?: social_network,
        host: source_host
      )
    end
    let(:destination) do
      instance_double(
        ChannelGrouping::Destination,
        medium: medium,
        host: destination_host
      )
    end
    let(:direct) { false }
    let(:search_engine) { false }
    let(:social_network) { false }
    let(:medium) { double(:medium) }
    let(:source_host) { double(:source_host) }
    let(:destination_host) { double(:source_host) }

    before do
      allow(ChannelGrouping::Source)
        .to receive(:new)
        .with(source_url)
        .and_return(source)

      allow(ChannelGrouping::Destination)
        .to receive(:new)
        .with(destination_url)
        .and_return(destination)
    end

    describe 'Organic Search' do
      context 'when the medium exactly matches organic' do
        let(:medium) { 'organic' }

        it 'returns Organic Search' do
          expect(subject).to eq 'Organic Search'
        end
      end

      context 'when the source is a search engine' do
        let(:search_engine) { true }
        let(:medium) { nil }

        it 'returns Organic Search' do
          expect(subject).to eq 'Organic Search'
        end
      end
    end

    describe 'Direct' do
      # ChannelGrouping::Source exactly matches Direct
      # AND
      # Medium exactly matches (not set)
      # OR
      # Medium exactly matches (none)
      context 'when the source is direct' do
        let(:direct) { true }

        context 'and the medium is not set' do
          let(:medium) { nil }

          it 'returns Direct' do
            expect(subject).to eq 'Direct'
          end
        end

        context 'and the medium is none' do
          let(:medium) { 'none' }

          it 'returns Direct' do
            expect(subject).to eq 'Direct'
          end
        end

        context 'and the medium is set' do
          let(:medium) { 'some_medium' }

          it 'does not return Direct' do
            expect(subject).not_to eq 'Direct'
          end
        end

        context 'when the source and destination domains match' do
          let(:source_host) { 'my-site.com' }
          let(:destination_host) { 'my-site.com' }

          it 'returns Direct' do
            expect(subject).to eq 'Direct'
          end
        end
      end

      context 'when source is not direct' do
        let(:direct) { false }

        context 'and the medium is set' do
          let(:medium) { 'some_medium' }

          it 'does not return Direct' do
            expect(subject).not_to eq 'Direct'
          end
        end
      end
    end

    describe 'Social' do
      context 'when the source is a social network' do
        let(:social_network) { true }
        let(:medium) { 'foo' }

        it 'returns Social' do
          expect(subject).to eq 'Social'
        end
      end

      context 'when the medium exactly matches organic' do
        let(:medium) { 'organic' }

        %w(social social-network social-media).each do |paid_search_medium|
          context "when the medium exactly matches #{paid_search_medium}" do
            let(:medium) { paid_search_medium }

            it 'returns Social' do
              expect(subject).to eq 'Social'
            end
          end
        end
      end
    end

    context 'when the medium exactly matches email' do
      let(:medium) { 'email' }

      it 'returns Email' do
        expect(subject).to eq 'Email'
      end
    end

    context 'when the medium exactly matches affiliate' do
      let(:medium) { 'affiliate' }

      it 'returns Affiliates' do
        expect(subject).to eq 'Affiliates'
      end
    end

    describe 'Referral' do
      context 'when the medium exactly matches referral' do
        let(:medium) { 'referral' }

        it 'returns Referral' do
          expect(subject).to eq 'Referral'
        end
      end

      context 'when there is a non-direct url referrer' do
        let(:source_host) { 'some-referrer-host' }
        let(:medium) { nil }
        let(:direct) { false }

        it 'returns Referral' do
          expect(subject).to eq 'Referral'
        end
      end
    end

    describe 'Paid Search' do
      # Medium matches regex ^(cpc|ppc|paidsearch)$
      # AND
      # Ad Distribution Network does not exactly match Content
      %w(cpc ppc paidsearch).each do |paid_search_medium|
        context "when the medium exactly matches #{paid_search_medium}" do
          let(:medium) { paid_search_medium }

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
          let(:medium) { other_advertising_medium }

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
          let(:medium) { other_advertising_medium }

          it 'returns Display' do
            expect(subject).to eq 'Display'
          end
        end
      end
    end

    describe 'Other' do
      context 'when there is a medium not matching any other rules' do
        let(:medium) { 'some-medium' }

        it 'returns Other' do
          expect(subject).to eq 'Other'
        end
      end
    end
  end
end
