# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'channel_grouping/version'

Gem::Specification.new do |spec|
  spec.name          = "channel_grouping"
  spec.version       = ChannelGrouping::VERSION
  spec.authors       = ["Ian Yamey"]
  spec.email         = ["ian@policygenius.com"]

  spec.summary       = 'Groups traffic into channels, similar to the groupings in Google Analytics'
  spec.description   = "Given a source_url and destination_url, this gem will determine the traffic's " \
                       "channel (eg Social, Direct, Organic Search, Paid Search). The categorization is " \
                       "based on Google Analytics' default channel definitions (see https://support.google.com/analytics/answer/3297892)"
  spec.homepage      = 'https://github.com/ianyamey/channel_grouping'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "rack"
  spec.add_dependency "referer-parser"
  spec.add_dependency "addressable"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "pry"
end
