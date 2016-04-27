require 'uri'
require 'cgi'

module ChannelGrouping
  class Medium
    attr_reader :url

    def self.from_url(url)
      query_string = URI(url).query

      return unless query_string

      medium = CGI::parse(query_string)['utm_medium'].first

      return if medium == ''

      medium
    end
  end
end
