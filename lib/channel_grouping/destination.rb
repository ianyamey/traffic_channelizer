require 'uri'
require 'rack/utils'

module ChannelGrouping
  class Destination
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def medium
      m = params['utm_medium']
      m == '' ? nil : m
    end

    def host
      uri.host
    end

    private

    def uri
      @uri ||= URI(url.to_s)
    end

    def params
      Rack::Utils.parse_nested_query(uri.query)
    end
  end
end
