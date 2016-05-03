require 'channel_grouping/version'
require 'channel_grouping/referrer'
require 'channel_grouping/landing_page'
require 'channel_grouping/channel_group'
require 'channel_grouping/visit'

module ChannelGrouping
  def self.parse(referrer_url:, landing_page_url:)
    Visit.new(
      referrer_url: referrer_url,
      landing_page_url: landing_page_url
    ).attribution_data
  end
end
