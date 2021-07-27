⚠️⚠️ This repository has been archived, and is no longer maintained ⚠️⚠️

# TrafficChannelizer

Given a referrer_url and destination landing_page_url, this gem will determine the 
marketing attribution for the visit (source, medium, campaign) and channel group 
(eg Social, Direct, Organic Search, Paid Search). 

The categorizations are based on Google Analytics' [default channel definitions](https://support.google.com/analytics/answer/3297892)

## Limitations

1. Display and Paid Search groupings do not take into account the Ad Distribution Network
2. The list of Social Networks and Search Engines may differ from Google's lists.

## Usage

```Ruby
TrafficChannelizer.analyze(referrer_url: 'https://www.google.com?s=some-query', landing_page_url: 'https://your-site.com')
=> {:referrer_domain=>"google.com", :landing_page_domain=>"your-site.com", :medium=>"search", :source=>"Google", :term=>nil, :campaign=>nil, :content=>nil, :channel_group=>"Organic Search"}

TrafficChannelizer.analyze(referrer_url: 'https://www.some-site.com', landing_page_url: 'https://your-site.com?utm_medium=cpc')
=> {:referrer_domain=>"some-site.com", :landing_page_domain=>"your-site.com", :medium=>"cpc", :source=>"some-site.com", :term=>nil, :campaign=>nil, :content=>nil, :channel_group=>"Paid Search"}

TrafficChannelizer.analyze(referrer_url: nil, landing_page_url: 'https://your-site.com')
=> {:referrer_domain=>nil, :landing_page_domain=>"your-site.com", :medium=>"(none)", :source=>"(direct)", :term=>nil, :campaign=>nil, :content=>nil, :channel_group=>"Direct"}
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'traffic_channelizer'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install traffic_channelizer

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/traffic_channelizer/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
