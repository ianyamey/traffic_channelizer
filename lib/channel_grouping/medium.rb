require 'uri'
require 'cgi'

module ChannelGrouping
  class Medium
    attr_reader :url

    def self.from_url(url)
      query_string = URI(url).query

      return unless query_string

      CGI::parse(query_string)['utm_medium'].first
    end
  end
end
