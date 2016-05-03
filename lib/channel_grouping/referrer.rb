require 'referer-parser'
require 'addressable/uri'

module ChannelGrouping
  class Referrer
    attr_reader :url

    def self.parser
      @parser ||= RefererParser::Parser.new
    end

    class << self
      attr_writer :parser
    end

    def initialize(url)
      @url = url
    end

    def medium
      referrer_data[:medium]
    end

    def source
      referrer_data[:source] || domain_without_www
    end

    def domain
      domain_without_www
    end

    def term
      referrer_data[:term]
    end

    private

    def domain_without_www
      return unless normalized_uri.host
      normalized_uri.host.gsub(/^www\./, '')
    end

    def normalized_uri
      @normalized_uri ||= Addressable::URI.parse(url.to_s).normalize
    rescue
      nil
    end

    def referrer_data
      @referrer_data ||= self.class.parser.parse(normalized_uri.to_s)
    rescue RefererParser::InvalidUriError
      {}
    end
  end
end
