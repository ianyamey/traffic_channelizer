require 'channel_grouping/version'
require 'channel_grouping/source'
require 'channel_grouping/destination'

module ChannelGrouping
  def self.identify(source_url: , destination_url:)
    destination = Destination.new(destination_url)

    medium = destination.medium

    return 'Email' if medium =~ /^email$/i
    return 'Affiliates' if medium =~ /^affiliate$/i
    return 'Referral' if medium =~ /^referral$/i
    return 'Organic Search' if medium =~ /^organic$/i
    return 'Paid Search' if medium =~ /^(cpc|ppc|paidsearch)$/i
    return 'Other Advertising' if medium =~ /^(cpv|cpa|cpp)$/i
    return 'Display' if medium =~ /^(display|cpm|banner)$/i
    return 'Social' if medium =~ /^(social|social-network|social-media|sm|social network|social media)$/i

    source = Source.new(source_url)

    return 'Organic Search' if source.search_engine?
    return 'Social' if source.social_network?
    return 'Direct' if source.direct? && (medium == 'none' || medium.nil?)
    return 'Direct' if source.host == destination.host
    return 'Referral' if source.host && (medium == 'none' || medium.nil?)

    'Other'
  end
end
