require 'channel_grouping/version'
require 'channel_grouping/source'
require 'channel_grouping/medium'

module ChannelGrouping
  def self.identify(source_url: , destination_url:)
    medium = Medium.from_url(destination_url)

    return 'Email' if medium == 'email'
    return 'Affiliates' if medium == 'affiliate'
    return 'Referral' if medium == 'referral'
    return 'Paid Search' if medium =~ /^(cpc|ppc|paidsearch)$/
    return 'Other Advertising' if medium =~ /^(cpv|cpa|cpp)$/
    return 'Display' if medium =~ /^(display|cpm|banner)$/

    source = Source.new(source_url)

    return 'Direct' if source.direct? && medium == 'none'
    return 'Organic' if source.search_engine? || medium == 'organic'

    'Other'
  end
end
