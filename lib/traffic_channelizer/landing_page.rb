require 'addressable/uri'

module TrafficChannelizer
  class LandingPage
    attr_reader :url

    def initialize(url)
      @url = url
    end

    %w(utm_source utm_medium utm_campaign utm_term utm_content).each do |utm_param|
      define_method utm_param do
        query_params[utm_param] unless query_params[utm_param] == ''
      end
    end

    def domain
      domain_without_www
    end

    private

    def domain_without_www
      return unless uri.host
      uri.host.gsub(/^www\./, '')
    end

    def uri
      @uri ||= Addressable::URI.parse(url.to_s)
    rescue
      nil
    end

    def query_params
      @query_params ||= (uri && uri.query_values) || {}
    end
  end
end
