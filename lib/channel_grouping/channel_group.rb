module ChannelGrouping
  class ChannelGroup
    def self.identify(source:, medium:)
      return 'Email' if medium =~ /^email$/i
      return 'Affiliates' if medium =~ /^affiliate$/i
      return 'Referral' if medium =~ /^referral$/i
      return 'Organic Search' if medium =~ /^(organic|search)$/i
      return 'Paid Search' if medium =~ /^(cpc|ppc|paidsearch)$/i
      return 'Other Advertising' if medium =~ /^(cpv|cpa|cpp)$/i
      return 'Display' if medium =~ /^(display|cpm|banner)$/i
      return 'Social' if medium =~ /^(social|social-network|social-media|sm|social network|social media)$/i
      return 'Other' unless medium == '(none)'
      return 'Direct' if source == '(direct)'
      return 'Internal' if source == '(internal)'
      'Referral'
    end
  end
end
