require 'payoneer_api/utils'
require 'payoneer_api/api'

module PayoneerApi
  class Client
    include PayoneerApi::Utils
    include PayoneerApi::API

    SANDBOX_API_URL = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
    PRODUCTION_API_URL = 'https://api.payoneer.com/payouts/HttpAPI/API.aspx?'
    API_PORT = '443'

    def initialize(options = {})
      @partner_id, @username, @password = options[:partner_id], options[:username], options[:password]
      @partner_id ||= ENV['PAYONEER_PARTNER_ID']
      @username ||= ENV['PAYONEER_USERNAME']
      @password ||= ENV['PAYONEER_PASSWORD']
      @environment = options[:environment]
      @environment ||= ENV['PAYONEER_ENVIRONMENT']
      if @environment.nil? && defined?(Rails)
        Rails.env.production? ? 'production' : 'sandbox'
      end
      @environment ||= 'sandbox'
    end

    private

    def get_api_call(args_hash)
      uri = URI.parse(api_url)
      uri.query = URI.encode_www_form(args_hash)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request)
    end

    def post_api_call(args_hash)
      uri = URI.parse(api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(args_hash)
      http.request(request)
    end

    def request_args(method_name)
      {
        mname: method_name.to_s.camelize,
        p1: @username,
        p2: @password,
        p3: @partner_id,
      }
    end

    def api_url
      sandbox? ? SANDBOX_API_URL : PRODUCTION_API_URL
    end

    def sandbox?
      return true unless @environment
      @environment.to_s != 'production'
    end
  end
end