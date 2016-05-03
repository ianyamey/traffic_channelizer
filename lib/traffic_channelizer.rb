require 'traffic_channelizer/version'
require 'traffic_channelizer/referrer'
require 'traffic_channelizer/landing_page'
require 'traffic_channelizer/channel_group'
require 'traffic_channelizer/visit'

module TrafficChannelizer
  def self.analyze(referrer_url:, landing_page_url:)
    Visit.new(
      referrer_url: referrer_url,
      landing_page_url: landing_page_url
    ).attribution_data
  end
end
