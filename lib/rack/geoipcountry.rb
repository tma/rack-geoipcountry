require 'geoip'

module Rack
  # Rack::GeoIPCountry uses the geoip gem and the GeoIP database to lookup the country of a request by its IP address
  # The database can be downloaded from:
  # http://geolite.maxmind.com/download/geoip/database/GeoLiteCountry/GeoIP.dat.gz
  #
  # Usage:
  # use Rack::GeoIPCountry, :db => "path/to/GeoIP.dat"
  #
  # By default all requests are looked up and the X_GEOIP_* headers are added to the request
  # The headers can then be read in the application
  # The country name is added to the request header as X_GEOIP_COUNTRY, eg:
  # X_GEOIP_COUNTRY: United Kingdom
  #
  # The full set of GEOIP request headers is below:
  # X_GEOIP_COUNTRY_ID - The GeoIP country-ID as an integer, if not found set to 0
  # X_GEOIP_COUNTRY_CODE - The ISO3166-1 two-character country code, if not found set to --
  # X_GEOIP_COUNTRY_CODE3 - The ISO3166-2 three-character country code, if not found set to --
  # X_GEOIP_COUNTRY - The ISO3166 English-language name of the country, if not found set to N/A
  # X_GEOIP_CONTINENT - The two-character continent code, if not found set to --
  #
  #
  # You can use the included Mapping class to trigger lookup only for certain requests by specifying matching path prefix in options, eg:
  # use Rack::GeoIPCountry::Mapping, :prefix => '/video_tracking'
  # The above will lookup IP addresses only for requests matching /video_tracking etc.
  #
  # MIT License - Karol Hosiawa ( http://twitter.com/hosiawak )
  class GeoIPCountry
    def initialize(app, options = {})
      options[:db] ||= 'GeoIP.dat'
      @db = GeoIP.new(options[:db])
      @app = app
    end

    def call(env)
      res = @db.country(env['REMOTE_ADDR'])
      env['X_GEOIP_COUNTRY_ID'] = res[2]
      env['X_GEOIP_COUNTRY_CODE'] = res[3]
      env['X_GEOIP_COUNTRY_CODE3'] = res[4]
      env['X_GEOIP_COUNTRY'] = res[5]
      env['X_GEOIP_CONTINENT'] = res[6]
      @app.call(env)
    end

    class Mapping
      def initialize(app, options = {})
        @app, @prefix = app, /^#{options.delete(:prefix)}/
        @geoip_country = GeoIPCountry.new(app, options)
      end

      def call(env)
        if env['PATH_INFO'] =~ @prefix
          @geoip_country.call(env)
        else
          @app.call(env)
        end
      end
    end
  end
end
