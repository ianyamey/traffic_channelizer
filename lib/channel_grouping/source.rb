require 'referer-parser'
require 'addressable/uri'

module ChannelGrouping
  class Source
    CONFIG_FILENAME = 'sources.yml'

    attr_reader :url

    def self.parser
      @parser ||= RefererParser::Parser.new
    end

    def initialize(url)
      @url = url
    end

    def search_engine?
      referrer_data[:medium] == 'search'
    end

    def social_network?
      referrer_data[:medium] == 'social'
    end

    def direct?
      return true if url.to_s == ''

      false
    end

    def host
      raw_host = parsed_url.host
      raw_host.gsub(/^www\./, '') if raw_host
    end

    private

    def referrer_data
      @referrer_data ||= self.class.parser.parse(url)
    rescue RefererParser::InvalidUriError
      {}
    end

    def parsed_url
      @parsed_url ||= Addressable::URI.parse(url)
    end
  end
end
