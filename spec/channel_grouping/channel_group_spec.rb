require 'spec_helper'

module ChannelGrouping
  describe ChannelGroup do
    describe '.identify' do
      subject do
        ChannelGroup.identify(source: source, medium: medium)
      end

      let(:source) { nil }
      let(:medium) { nil }

      context 'when the medium matches "email"' do
        let(:medium) { 'email' }

        it 'returns Email' do
          expect(subject).to eq 'Email'
        end
      end

      context 'when the medium matches "affiliate"' do
        let(:medium) { 'affiliate' }

        it 'returns Affiliates' do
          expect(subject).to eq 'Affiliates'
        end
      end

      context 'when the medium matches "referral"' do
        let(:medium) { 'referral' }

        it 'returns Referral' do
          expect(subject).to eq 'Referral'
        end
      end

      context 'when the medium matches "organic"' do
        let(:medium) { 'organic' }

        it 'returns Organic Search' do
          expect(subject).to eq 'Organic Search'
        end
      end

      context 'when the medium matches "search"' do
        let(:medium) { 'search' }

        it 'returns Organic Search' do
          expect(subject).to eq 'Organic Search'
        end
      end

      %w(social social-network social-media sm).each do |paid_search_medium|
        context "when the medium matches \"#{paid_search_medium}\"" do
          let(:medium) { paid_search_medium }

          it 'returns Social' do
            expect(subject).to eq 'Social'
          end
        end
      end

      %w(cpc ppc paidsearch).each do |paid_search_medium|
        context "when the medium matches \"#{paid_search_medium}\"" do
          let(:medium) { paid_search_medium }

          it 'returns Paid Search' do
            expect(subject).to eq 'Paid Search'
          end
        end
      end

      %w(cpv cpa cpp).each do |other_advertising_medium|
        context "when the medium matches \"#{other_advertising_medium}\"" do
          let(:medium) { other_advertising_medium }

          it 'returns Other Advertising' do
            expect(subject).to eq 'Other Advertising'
          end
        end
      end

      %w(display cpm banner).each do |other_advertising_medium|
        context "when the medium matches \"#{other_advertising_medium}\"" do
          let(:medium) { other_advertising_medium }

          it 'returns Display' do
            expect(subject).to eq 'Display'
          end
        end
      end

      context 'when the medium is a case insensitive match' do
        let(:medium) { 'Display' }

        it 'returns Display' do
          expect(subject).to eq 'Display'
        end
      end

      context 'when the source is "(direct)"' do
        let(:source) { '(direct)' }

        context 'and the medium is "(none)"' do
          let(:medium) { '(none)' }

          it 'returns Direct' do
            expect(subject).to eq 'Direct'
          end
        end

        context 'and the medium is set' do
          let(:medium) { 'some_medium' }

          it 'returns Other' do
            expect(subject).to eq 'Other'
          end
        end
      end

      context 'when the source is "(internal)"' do
        let(:source) { '(internal)' }

        context 'and the medium is "(none)"' do
          let(:medium) { '(none)' }

          it 'returns Internal' do
            expect(subject).to eq 'Internal'
          end
        end

        context 'and the medium is set' do
          let(:medium) { 'some_medium' }

          it 'returns Other' do
            expect(subject).to eq 'Other'
          end
        end
      end

      context 'when the source is not "(direct)" or "(internal)"' do
        let(:source) { 'some-referrer-domain.com' }

        context 'and the medium is "(none)"' do
          let(:medium) { '(none)' }

          it 'returns Referral' do
            expect(subject).to eq 'Referral'
          end
        end

        context 'and the medium is set' do
          let(:medium) { 'some-medium' }

          it 'returns Other' do
            expect(subject).to eq 'Other'
          end
        end
      end
    end
  end
end
