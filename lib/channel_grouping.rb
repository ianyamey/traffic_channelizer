require 'channel_grouping/version'
require 'channel_grouping/source'
require 'channel_grouping/medium'

module ChannelGrouping
  def self.identify(source_url: , destination_url:)
    medium = Medium.from_url(destination_url)

    return 'Email' if medium == 'email'
    return 'Affiliates' if medium == 'affiliate'
    return 'Referral' if medium == 'referral'
    return 'Organic Search' if medium == 'organic'
    return 'Paid Search' if medium =~ /^(cpc|ppc|paidsearch)$/
    return 'Other Advertising' if medium =~ /^(cpv|cpa|cpp)$/
    return 'Display' if medium =~ /^(display|cpm|banner)$/
    return 'Social' if medium =~ /^(social|social-network|social-media|sm|social network|social media)$/

    source = Source.new(source_url)

    return 'Direct' if source.direct? && (medium == 'none' || medium.nil?)
    return 'Organic Search' if source.search_engine?
    return 'Social' if source.social_network?

    'Other'
  end
end
