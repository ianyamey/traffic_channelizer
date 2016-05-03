module TrafficChannelizer
  class Visit
    def initialize(referrer_url:, landing_page_url:)
      @referrer_url = referrer_url
      @landing_page_url = landing_page_url
    end

    def attribution_data
      {
        referrer_domain: referrer.domain,
        landing_page_domain: landing_page.domain,
        medium: medium,
        source: source,
        term: term,
        campaign: landing_page.utm_campaign,
        content: landing_page.utm_content,
        channel_group: channel_group
      }
    end

    def medium
      landing_page.utm_medium || referrer.medium || '(none)'
    end

    def source
      s = landing_page.utm_source
      s ||= '(internal)' if internal?
      s ||= referrer.source
      s ||= '(direct)'
      s
    end

    def term
      landing_page.utm_term || referrer.term
    end

    def channel_group
      ChannelGroup.identify(medium: medium, source: source)
    end

    private

    def internal?
      landing_page.domain == referrer.domain
    end

    def landing_page
      @landing_page ||= LandingPage.new(landing_page_url)
    end

    def referrer
      @referrer ||= Referrer.new(referrer_url)
    end

    attr_reader :referrer_url, :landing_page_url
  end
end
