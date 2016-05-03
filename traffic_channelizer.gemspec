# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'traffic_channelizer/version'

Gem::Specification.new do |spec|
  spec.name          = 'traffic_channelizer'
  spec.version       = TrafficChannelizer::VERSION
  spec.authors       = ['Ian Yamey']
  spec.email         = ['ian@policygenius.com']

  spec.summary       = 'Analyzes website visits to determine the source, medium, campaign and channel grouping, similar to the classifications used by Google Analytics'
  spec.description   = "Given a referrer_url and destination landing_page_url, this gem will determine the traffic's " \
                       'source, medium, campaign, term, content and channel (eg Social, Direct, Organic Search, Paid Search). The categorization is ' \
                       "based on Google Analytics' default channel definitions (see https://support.google.com/analytics/answer/3297892)"
  spec.homepage      = 'https://github.com/ianyamey/traffic_channelizer'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rack'
  spec.add_dependency 'referer-parser'
  spec.add_dependency 'addressable'
  spec.add_development_dependency 'rspec', '~> 3.2'
  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'pry'
end
