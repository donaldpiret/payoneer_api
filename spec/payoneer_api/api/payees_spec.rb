require 'spec_helper'

describe PayoneerApi::API::Payees do
  let(:client) { PayoneerApi::Client.new }

  describe '#payee_signup_url', vcr: true do
    it 'returns payoneer token' do
      response = client.payee_signup_url('1')
      expect(response).to be_a(PayoneerApi::PayoneerToken)
    end

    it 'allows you to us the to_s method on that object to obtain the registration url' do
      response = client.payee_signup_url('1')
      expect(response.to_s).to match(/payouts\.sandbox\.payoneer\.com/)
    end

    it 'allows you to use the uri method to get the URI object directly' do
      response = client.payee_signup_url('1')
      expect(response.uri.host).to eq('payouts.sandbox.payoneer.com')
    end
  end

  describe '#payee_prefilled_signup_url', vcr: true do
    context 'with incorrect login credentials' do
      it 'returns a parsed error notification' do
        client = PayoneerApi::Client.new(
          partner_id: 'bogus',
          username: 'bogus',
          password: 'bogus',
          environment: 'sandbox'
        )
        expect {
          client.payee_prefilled_signup_url('1', {})
        }.to raise_error(PayoneerApi::PayoneerException,
          'Unauthorized Access or invalid parameters, please check your IP address and parameters.')
      end
    end

    context 'with all correct params passed in' do
      let(:params) {{
        redirect_url: 'http://test.com/redirect',
        redirect_time: 10,
        payout_methods: 'PrepaidCard',
        first_name: 'Donald',
        last_name: 'Piret',
        date_of_birth: '04011984',
        address: '115 Amoy street',
        city: 'Singapore',
        county_code: 'SG',
        zip_code: '069935',
        phone: '+123456789',
        email: 'donald@roomorama.com'
      }}

      it 'returns a url to the prefilled registration page' do
        response = client.payee_prefilled_signup_url('1', params)
        expect(response).to be_a(PayoneerApi::PayoneerToken)
        expect(response.uri.host).to eq('payouts.sandbox.payoneer.com')
      end

      it 'includes a token parameter in this url' do
        response = client.payee_prefilled_signup_url('1', params)
        expect(CGI.parse(response.uri.query)).to have_key('token')
      end
    end
  end

  # describe '#payee_details', vcr: true do
  #   it 'returns an instance of a Payee object' do
  #     response = client.payee_details('1')
  #     puts response.inspect
  #     expect(response).to be_a(PayoneerApi::Payee)
  #   end
  # end
end