module PayoneerApi
  class Client
    SANDBOX_API_URL = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
    PRODUCTION_API_URL = 'https://api.payoneer.com/payouts/HttpAPI/API.aspx?'
    API_PORT = '443'

    def self.new_payee_link(member_name, options = {})
      new(options).payee_signup_url(member_name)
    end

    def initialize(options = {})
      @partner_id, @username, @password = options[:partner_id], options[:username], options[:password]
      @partner_id ||= ENV['PAYONEER_PARTNER_ID']
      @username ||= ENV['PAYONEER_USERNAME']
      @password ||= ENV['PAYONEER_PASSWORD']
      @environment = options[:environment]
      if @environment.nil? && defined?(Rails)
        Rails.env.production? ? 'production' : 'sandbox'
      end
      @environment ||= 'sandbox'
    end

    def payee_signup_url(member_name)
      response = get_api_call(payee_link_args(payee_id: member_name))
      api_result(response)
    end

    def payee_prefilled_signup_url(member_name, attributes = {})
      response = post_api_call(payee_prefill_args(attributes.merge(payee_id: member_name)))
      xml_api_result(response)
    end

    private

    def api_result(response)
      if response.code == '200'
        return response.body
      else
        raise PayoneerException, api_error_description(response)
      end
    end

    def xml_api_result(response)
      if response.code == '200'
        result = Nokogiri::XML.parse(response.body)
        token = result.css('PayoneerToken Token').first
        return token.text if token
      end
      raise PayoneerException, api_error_description(response)
    end

    def api_error_description(response)
      return nil unless response and response.body
      body_hash = Nokogiri::XML.parse(response.body)
      if body_hash['PayoneerResponse']
        return body_hash['PayoneerResponse']['Description']
      else
        return body_hash.to_s
      end
    end

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

    def payee_link_args(args)
      {
        mname: 'GetToken',
        p1: @username,
        p2: @password,
        p3: @partner_id,
        p4: args[:payee_id],
        p5: args[:session_id],
      }.delete_if { |_, value| value.nil? || value.empty? }
    end

    def payee_prefill_args(args)
      {
        mname: 'GetTokenXML',
        p1: @username,
        p2: @password,
        p3: @partner_id,
        p4: args[:payee_id],
        xml: prefill_xml_data(args)
      }
    end

    def prefill_xml_data(args)
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.PayoneerDetails do
          xml.Details do
            xml.userName @username
            xml.password @password
            xml.prid @partner_id
            xml.apuid args[:payee_id]
            xml.sessionid args[:session_id] if args[:session_id]
            xml.redirect args[:redirect_url] if args[:redirect_url]
            xml.redirectTime args[:redirect_time] if args[:redirect_time]
            xml.cardType args[:card_type] if args[:card_type]
            xml.BlockType args[:block_type] if args[:block_type]
            xml.PayoutMethodList (args[:payout_methods].is_a?(Array) ?
              args[:payout_methods].join(',') :
              args[:payout_methods]) if args[:payout_methods]
            xml.regMode args[:registration_mode] if args[:registration_mode]
            xml.holdApproval args[:hold_approval] if args[:hold_approval]
          end
          xml.PersonalDetails do
            xml.firstName args[:first_name] if args[:first_name]
            xml.lastName args[:last_name] if args[:last_name]
            xml.dateOfBirth args[:date_of_birth] if args[:date_of_birth]
            xml.address1 args[:address].is_a?(Array) ? args[:address].first : args[:address]
            xml.address2 args[:address].last if args[:address].is_a?(Array)
            xml.city args[:city] if args[:city]
            xml.country args[:country_code] if args[:country_code]
            xml.state args[:state_code] if args[:state_code]
            xml.zipCode args[:zip_code] if args[:zip_code]
            xml.mobile args[:mobile_phone] if args[:mobile_phone]
            xml.phone args[:phone] if args[:phone]
            xml.email args[:email] if args[:email]
          end
        end
      end
      builder.to_xml#.tap { |x| puts x.inspect }
    end

    def api_url
      @environment.to_s == 'production' ? PRODUCTION_API_URL : SANDBOX_API_URL
    end
  end
end