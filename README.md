# ChannelGrouping

Groups traffic into channels, similar to the groupings in Google Analytics

Given a source_url and destination_url, this gem will determine the traffic's channel
(eg Social, Direct, Organic Search, Paid Search). 

The categorizations are based on Google Analytics' [default channel definitions](https://support.google.com/analytics/answer/3297892)


## Limitations

1. Display and Paid Search groupings do not take into account the Ad Distribution Network
2. The list of Social Networks and Search Engines may differ from Google's lists.
  - See `sources.yml` and https://support.google.com/analytics/answer/2795821

## Usage

```Ruby
ChannelGrouping.identify(source_url: 'https://www.google.com?s=some-query', destination_url: 'https://your-site.com')
#=> 'Organic Search'
```

```Ruby
ChannelGrouping.identify(source_url: 'https://www.some-site.com', destination_url: 'https://your-site.com?utm_medium=cpc')
#=> 'Paid Search'
```

```Ruby
ChannelGrouping.identify(source_url: nil, destination_url: 'https://your-site.com')
#=> 'Direct'
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'channel_grouping'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install channel_grouping

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release` to create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

1. Fork it ( https://github.com/[my-github-username]/channel_grouping/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
