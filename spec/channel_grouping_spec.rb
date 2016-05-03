require 'spec_helper'

describe ChannelGrouping do
  it 'has a version number' do
    expect(ChannelGrouping::VERSION).not_to be nil
  end

  describe '.parse' do
    subject do
      ChannelGrouping.parse(
        referrer_url: referrer_url,
        landing_page_url: landing_page_url
      )
    end

    context 'when there is no referrer_url' do
      let(:referrer_url) { nil }
      let(:landing_page_url) { 'http://www.my-site.com/' }

      it 'groups the visit as Direct' do
        expect(subject).to include(
          channel_group: 'Direct',
          source: '(direct)',
          medium: '(none)'
        )
      end
    end

    context 'when there is a referrer_url' do
      let(:referrer_url) { 'http://www.some-site.com/some/path' }

      context 'and the landing_page_url has utm parameters' do
        let(:landing_page_url) do
          'http://www.my-site.com/?utm_source=s&utm_medium=m&utm_term=t&utm_content=co&utm_campaign=ca'
        end

        it 'returns a hash of computed marketing attribution data' do
          expect(subject).to eq(
            referrer_domain: 'some-site.com',
            landing_page_domain: 'my-site.com',
            medium: 'm',
            source: 's',
            term: 't',
            campaign: 'ca',
            content: 'co',
            channel_group: 'Other'
          )
        end
      end

      context 'and the landing_page_url does not have any utm parameters' do
        let(:landing_page_url) { 'http://www.my-site.com/' }

        it 'returns a hash of computed marketing attribution data' do
          expect(subject).to eq(
            referrer_domain: 'some-site.com',
            landing_page_domain: 'my-site.com',
            medium: '(none)',
            source: 'some-site.com',
            term: nil,
            campaign: nil,
            content: nil,
            channel_group: 'Referral'
          )
        end
      end

      describe 'Default referrer parser test cases' do
        let(:landing_page_url) { 'http://www.my-site.com/' }

        before do
          ChannelGrouping::Referrer.parser = RefererParser::Parser.new
        end

        {
          'http://www.facebook.com/' => { channel_group: 'Social' },
          'http://tumblr.com/' => { channel_group: 'Social' },
          'http://www.google.com/' => { channel_group: 'Organic Search', medium: 'search', term: nil },
          'http://www.google.com/?q=abc' => { channel_group: 'Organic Search', medium: 'search', term: 'abc' },
          'http://www.nytimes.com/' => { channel_group: 'Referral', medium: '(none)', source: 'nytimes.com' },
          'http://www.my-site.com/' => { channel_group: 'Internal', medium: '(none)', source: '(internal)' },
          'http://subdomain.my-site.com/' => { channel_group: 'Referral', medium: '(none)', source: 'subdomain.my-site.com' },
          '' => { channel_group: 'Direct', medium: '(none)', source: '(direct)' }
        }.each do |referrer_url, attribution_data|
          context "when the referrer_url is #{referrer_url}" do
            let(:referrer_url) { referrer_url }

            it "groups the traffic as #{attribution_data[:channel_group]}" do
              expect(subject).to include attribution_data
            end
          end
        end
      end
    end
  end
end
