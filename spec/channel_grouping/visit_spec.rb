require 'spec_helper'

module ChannelGrouping
  describe Visit do
    subject do
      Visit.new(
        referrer_url: referrer_url,
        landing_page_url: landing_page_url
      )
    end

    let(:referrer_url) { 'http://external.site' }
    let(:referrer) do
      instance_double(
        ChannelGrouping::Referrer,
        source: referrer_source,
        medium: referrer_medium,
        term: referrer_term,
        domain: referrer_domain
      )
    end
    let(:referrer_source) { double(:referrer_source) }
    let(:referrer_medium) { double(:referrer_medium) }
    let(:referrer_term) { double(:referrer_term) }
    let(:referrer_domain) { double(:referrer_domain) }

    let(:landing_page_url) { double(:landing_page_url) }
    let(:landing_page) do
      instance_double(
        ChannelGrouping::LandingPage,
        utm_source: landing_page_source,
        utm_medium: landing_page_medium,
        utm_term: landing_page_term,
        utm_campaign: landing_page_campaign,
        utm_content: landing_page_content,
        domain: landing_page_domain
      )
    end
    let(:landing_page_source) { double(:landing_page_source) }
    let(:landing_page_medium) { double(:landing_page_medium) }
    let(:landing_page_term) { double(:landing_page_term) }
    let(:landing_page_campaign) { double(:landing_page_term) }
    let(:landing_page_content) { double(:landing_page_content) }
    let(:landing_page_domain) { double(:landing_page_domain) }

    before do
      allow(Referrer)
        .to receive(:new)
        .with(referrer_url)
        .and_return(referrer)

      allow(LandingPage)
        .to receive(:new)
        .with(landing_page_url)
        .and_return(landing_page)
    end

    describe '#attribution_data' do
      let(:channel_group) { double(:channel_group) }

      before do
        allow(ChannelGroup)
          .to receive(:identify)
          .with(medium: landing_page_medium, source: landing_page_source)
          .and_return(channel_group)
      end

      it 'collects the marketing attribution data for the visit' do
        expect(subject.attribution_data).to eq(
          referrer_domain: referrer_domain,
          landing_page_domain: landing_page_domain,
          medium: landing_page_medium,
          source: landing_page_source,
          term: landing_page_term,
          campaign: landing_page_campaign,
          content: landing_page_content,
          channel_group: channel_group
        )
      end
    end

    describe '#source' do
      context 'when the landing_page has a utm_source' do
        let(:landing_page_source) { 'some-utm-source' }

        it 'returns the utm_source' do
          expect(subject.source).to eq 'some-utm-source'
        end
      end

      context 'when the landing_page does not have utm_source' do
        let(:landing_page_source) { nil }

        context 'and the referrer has a source' do
          let(:referrer_source) { 'some-referrer-source' }

          it 'returns the referrer source' do
            expect(subject.source).to eq 'some-referrer-source'
          end
        end

        context 'and the referrer does not have a source' do
          let(:referrer_source) { nil }

          context 'and the referrer and landing page have the same domain' do
            let(:referrer_domain) { 'some-domain.com' }
            let(:landing_page_domain) { 'some-domain.com' }

            it 'returns "(internal)"' do
              expect(subject.source).to eq '(internal)'
            end
          end

          context 'and the referrer and landing page have different domains' do
            let(:referrer_domain) { 'some-referrer-domain.com' }
            let(:landing_page_domain) { 'some-landing-page-domain.com' }

            it 'returns "(direct)"' do
              expect(subject.source).to eq '(direct)'
            end
          end
        end
      end
    end

    describe '#medium' do
      context 'when the landing_page has a utm_medium' do
        let(:landing_page_medium) { 'some-utm-medium' }

        it 'returns the utm_medium' do
          expect(subject.medium).to eq 'some-utm-medium'
        end
      end

      context 'when the landing_page does not have utm_medium' do
        let(:landing_page_medium) { nil }

        context 'and the referrer has a medium' do
          let(:referrer_medium) { 'some-referrer-medium' }

          it 'returns the referrer medium' do
            expect(subject.medium).to eq 'some-referrer-medium'
          end
        end

        context 'and the referrer does not have a medium' do
          let(:referrer_medium) { nil }

          it 'returns "(none)"' do
            expect(subject.medium).to eq '(none)'
          end
        end
      end
    end

    describe '#term' do
      context 'when the landing_page has a utm_term' do
        let(:landing_page_term) { 'some-utm-term' }

        it 'returns the utm_term' do
          expect(subject.term).to eq 'some-utm-term'
        end
      end

      context 'when the landing_page does not have utm_term' do
        let(:landing_page_term) { nil }

        context 'and the referrer has a term' do
          let(:referrer_term) { 'some-referrer-term' }

          it 'returns the referrer term' do
            expect(subject.term).to eq 'some-referrer-term'
          end
        end

        context 'and the referrer does not have a term' do
          let(:referrer_term) { nil }

          it 'returns nil' do
            expect(subject.term).to be nil
          end
        end
      end
    end

    describe '#channel_group' do
      let(:landing_page_medium) { double(:landing_page_medium) }
      let(:landing_page_source) { double(:landing_page_medium) }
      let(:computed_channel_group) { 'Other Advertising' }

      before do
        expect(ChannelGroup)
          .to receive(:identify)
          .with(medium: landing_page_medium, source: landing_page_source)
          .and_return(computed_channel_group)
      end

      it 'calculates the ChannelGroup from the medium and source' do
        expect(subject.channel_group).to eq 'Other Advertising'
      end
    end
  end
end
