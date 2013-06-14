require 'bundler/setup'
require 'mail-xoauth'
require 'minitest/autorun'
require 'faraday'
require 'faraday_middleware'

config_klass = Class.new do
  attr_accessor :email
  attr_accessor :access_token, :refresh_token
  attr_accessor :oauth_key, :oauth_secret

  def initialize(hash = {})
    hash.each_pair do |name, value|
      send "#{name}=", value
    end
  end
end

root = File.expand_path "../../", __FILE__
Config = config_klass.new YAML.load_file "#{root}/config.yml"

class MiniTest::Unit::TestCase
  def access_token!
    auth.refresh_token! Config.refresh_token
    auth.access_token
  end

  private
  def auth
    @auth ||= Oauth.new Config.oauth_key, Config.oauth_secret
  end

  # Handle Authentication for the Google Data API. For more information
  # @see http://code.google.com/apis/gdata/docs/auth/overview.html
  class Oauth
    END_POINT = 'https://accounts.google.com/o/oauth2'.freeze

    attr_reader :access_token, :refresh_token

    def initialize(client_id, client_secret, redirect_uri = nil)
      @auth_ok  = false
      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
    end

    def authorize_code!(code)
      response = request :code => code,
        :client_id => client_id, :client_secret => client_secret,
        :redirect_uri => redirect_uri,
        :grant_type => 'authorization_code'

      @access_token   = response['access_token']
      @refresh_token  = response['refresh_token']
      @auth_ok = true
    end

    # This method is for subsequent initialization if a user has already granted access to
    # the application. It will fetch a new access_token from a refresh_token.
    def refresh_token!(refresh_token)
      @refresh_token = refresh_token

      response = request :refresh_token => refresh_token,
        :client_id => client_id, :client_secret => client_secret,
        :grant_type => 'refresh_token'

      @access_token   = response['access_token']
      @auth_ok = true
    end

    # Return the HTTP headers appropriate for this authentication type. This method
    # is used in Google:HTTP.
    # @return [Hash]
    def http_headers
      {'Authorization' => "Bearer #{@access_token}"}
    end

    private
    def client_id
      @client_id
    end

    def client_secret
      @client_secret
    end

    def redirect_uri
      @redirect_uri
    end

    # Send a request to the Token uri
    # @param [String] body The body to POST
    # @return [Net::HTTPResponse]
    def request(params)
      conn = Faraday.new do |builder|
        builder.request :url_encoded

        builder.use FaradayMiddleware::ParseJson
        builder.response :raise_error

        builder.adapter :net_http
      end

      response = conn.post "#{END_POINT}/token", params

      response.body
    end
  end
end
