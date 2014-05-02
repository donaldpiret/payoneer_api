require 'spec_helper'
describe PayoneerApi::Client do
  let(:client) {
    PayoneerApi::Client.new(
      partner_id: ENV['PAYONEER_ID'],
      username: ENV['PAYONEER_USERNAME'],
      password: ENV['PAYONEER_PASSWORD'],
      environment: 'sandbox'
    )
  }

  describe '.new_payee_signup_url', vcr: true do
    it 'returns a url to the registration page (implicit credentials through environment variables)' do
      response = PayoneerApi::Client.new_payee_signup_url('1')
      expect(response).to be_a(PayoneerApi::PayoneerToken)
      expect(response.uri.host).to eq('payouts.sandbox.payoneer.com')
    end
  end

  describe '.new_payee_prefilled_signup_url', vcr: true do
    it 'returns a url to the prefilled registration page' do
      response = PayoneerApi::Client.new_payee_prefilled_signup_url('1', {})
      expect(response).to be_a(PayoneerApi::PayoneerToken)
      expect(response.uri.host).to eq('payouts.sandbox.payoneer.com')
    end
  end
end