require 'uri'
require 'cgi'

module ChannelGrouping
  class Source
    attr_reader :url

    def initialize(url)
      @url = url
    end

    def search_engine?
      self.class.search_engines.any? do |e| 
        host_matches?(e[:host]) &&
          contains_query_param?(e[:search_query_param_key])
      end
    end

    def social_network?
      self.class.social_networks.any? do |social_network_host|
        host_matches?(Regexp.new(social_network_host))
      end
    end

    def direct?
      uri.host.nil?
    end

    def self.social_networks
      @social_networks ||= config[:social_networks]
    end

    def self.search_engines
      @search_engines ||= config[:search_engines]
    end

    def self.config
      root = Pathname.new(File.expand_path("../..", __FILE__))
      YAML.load_file(root.join('sources.yaml'))
    end

    private

    def host_matches?(regexp)
      uri.host =~ regexp
    end

    def contains_query_param?(key)
      query_param_keys.include?(key)
    end

    def query_param_keys
      return [] if uri.query.nil?
      @query_param_keys ||= CGI::parse(uri.query).keys
    end

    def uri
      @uri ||= URI(url.to_s)
    end
  end
end
