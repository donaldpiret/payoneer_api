require 'payoneer_api/utils'
require 'payoneer_api/payee'

module PayoneerApi
  module API
    module Payees
      extend ActiveSupport::Concern
      include PayoneerApi::Utils

      module ClassMethods
        def payee_signup_url(member_name, options = {})
          new(options).payee_signup_url(member_name)
        end

        def payee_prefilled_signup_url(member_name, options = {})
          attributes = options.slice!(:partner_id, :username, :password)
          new(options).payee_prefilled_signup_url(member_name, attributes)
        end

        def payee_details(payee_id, options = {})
          new(options).payee_details(payee_id)
        end
      end

      def payee_signup_url(payee_id, attributes = {})
        perform_with_object :get,
          payee_signup_args(attributes.merge(payee_id: payee_id)),
          PayoneerApi::PayoneerToken
      end

      def payee_prefilled_signup_url(payee_id, attributes = {})
        perform_with_object :post,
          payee_prefilled_signup_args(attributes.merge(payee_id: payee_id)),
          PayoneerApi::PayoneerToken
      end

      def payee_details(payee_id)
        perform_with_object :get,
          payee_request_args('GetPayeeDetails', payee_id),
          PayoneerApi::Payee
      end

      protected

      def payee_request_args(method_name, member_name)
        request_args(method_name).merge(p4: member_name)
      end

      def payee_signup_args(args)
        payee_request_args('GetToken', args[:payee_id]).merge(
          p5: args[:session_id],
          p6: args[:redirect_url],
          p8: args[:redirect_time],
          p9: bool_to_string(args[:test_card]),
          p10: 'True',
          p11: payout_methods_list(args[:payout_methods]),
          p12: args[:registration_mode],
          p13: bool_to_string(args[:hold_approval])
        ).delete_blank
      end

      def payee_prefilled_signup_args(args)
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
              xml.PayoutMethodList payout_methods_list(args[:payout_methods]) if args[:payout_methods]
              xml.regMode args[:registration_mode] if args[:registration_mode]
              xml.holdApproval bool_to_string(args[:hold_approval]) if args[:hold_approval]
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
        payee_request_args('GetTokenXML', args[:payee_id]).merge(xml: builder.to_xml)
      end
    end
  end
end