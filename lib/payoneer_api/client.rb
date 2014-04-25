module PayoneerApi
  class Client
    SANDBOX_API_URL = 'https://api.sandbox.payoneer.com/Payouts/HttpApi/API.aspx?'
    PRODUCTION_API_URL = 'https://api.payoneer.com/payouts/HttpAPI/API.aspx?'
    API_PORT = '443'

    def self.new_payee_link(partner_id, username, password, member_name)
      payoneer_api = self.new(partner_id, username, password)
      payoneer_api.payee_signup_url(member_name)
    end

    def self.transfer_funds(partner_id, username, password, options)
      payoneer_api = self.new(partner_id, username, password)
      payoneer_api.transfer_funds(options)
    end

    def initialize(partner_id, username, password)
      @partner_id, @username, @password = partner_id, username, password
    end

    def payee_signup_url(member_name)
      result = get_api_call(payee_link_args(payee_id: member_name))
      api_result(result)
    end

    def payee_prefilled_signup_url(member_name, attributes = {})
      result = post_api_call(payee_prefill_args(attributes.merge(payee_id: member_name)))
      api_result(result)
    end

    def transfer_funds(options)
      result = get_api_call(transfer_funds_args(options))
      api_result(result)
    end

    private

    def api_result(body)
      if is_xml? body
        raise PayoneerException, api_error_description(body)
      else
        body
      end
    end

    def is_xml?(body)
      Nokogiri::XML(body).errors.empty?
    end

    def api_error_description(body)
      body_hash = Hash.from_xml(body)
      body_hash['PayoneerResponse']['Description']
    end

    def get_api_call(args_hash)
      uri = URI.parse(api_url)
      uri.query = URI.encode_www_form(args_hash)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(uri.request_uri)
      http.request(request).body
    end

    def post_api_call(args_hash)
      uri = URI.parse(api_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(args_hash)
      http.request(request).body
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
        mname: 'GetToken',
        p1: @username,
        p2: @password,
        p3: @partner_id,
        p4: args[:payee_id],
        Xml: prefill_xml_data(args)
      }
    end

    def prefill_xml_data(args)
      builder = Nokogiri::XML::Builder.new(encoding: 'UTF-8') do |xml|
        xml.PayoneerDetails do
          xml.Details do
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
            xml.RegMode args[:registration_mode] if args[:registration_mode]
            xml.HoldApproval args[:hold_approval] if args[:hold_approval]
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
      builder.to_xml
    end

    def transfer_funds_args(options)
      {
        mname: 'PerformPayoutPayment',
        p1: options[:username],
        p2: options[:password],
        p3: options[:partner_id],
        p4: options[:program_id],
        p5: options[:internal_payment_id],
        p6: options[:internal_payee_id],
        p7: options[:amount],
        p8: options[:description],
        p9: options[:date]
      }
    end

    def api_url
      Rails.env.production? ? PRODUCTION_API_URL : SANDBOX_API_URL
    end
  end
end