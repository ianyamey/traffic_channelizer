require 'channel_grouping/version'
require 'channel_grouping/destination'
require 'channel_grouping/referrer'

module ChannelGrouping
  def self.identify(source_url: , destination_url:)
    destination = Destination.new(destination_url)
    source = Referrer.new(source_url)

    medium = destination.medium || source.medium

    return 'Email' if medium =~ /^email$/i
    return 'Affiliates' if medium =~ /^affiliate$/i
    return 'Referral' if medium =~ /^referral$/i
    return 'Organic Search' if medium =~ /^(organic|search)$/i
    return 'Paid Search' if medium =~ /^(cpc|ppc|paidsearch)$/i
    return 'Other Advertising' if medium =~ /^(cpv|cpa|cpp)$/i
    return 'Display' if medium =~ /^(display|cpm|banner)$/i
    return 'Social' if medium =~ /^(social|social-network|social-media|sm|social network|social media)$/i

    return 'Direct' if source.direct? && medium == '(none)'
    return 'Internal' if source.host == destination.host
    return 'Referral' if source.host && medium == '(none)'

    'Other'
  end
end
