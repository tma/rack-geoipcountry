# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "rack/geoipcountry/version"

Gem::Specification.new do |s|
  s.name        = "rack-geoipcountry"
  s.version     = Rack::GeoIPCountry::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Karol Hosiawa", "Thomas Maurer"]
  s.email       = ["tma@freshbit.ch"]
  s.homepage    = "http://coderack.org/users/hosiawak/middlewares/36-geoip-country"
  s.summary     = %q{Rack middleware for Geo IP country lookup}
  s.description = %q{Rack::GeoIPCountry uses the geoip gem and the GeoIP database to lookup the country of a request by its IP address}
  s.license     = 'MIT'
  
  s.rubyforge_project = "rack-geoipcountry"

  s.add_dependency 'geoip'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
