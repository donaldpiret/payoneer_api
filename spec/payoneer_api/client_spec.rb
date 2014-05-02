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

  describe '#payee_signup_url', vcr: true do
    it 'returns a url to the registration page' do
      response = client.payee_signup_url('1')
      expect(URI.parse(response).host).to eq('payouts.sandbox.payoneer.com')
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
        date_of_birth: Date.parse('1984-04-01'),
        address: '115 Amoy street',
        city: 'Singapore',
        county_code: 'SG',
        zip_code: '069935',
        phone: '+123456789',
        email: 'donald@roomorama.com'
      }}

      it 'returns a url to the prefilled registration page' do
        response = client.payee_prefilled_signup_url('1', params)
        expect(URI.parse(response).host).to eq('payouts.sandbox.payoneer.com')
      end

      it 'includes a token parameter in this url' do
        response = client.payee_prefilled_signup_url('1', params)
        expect(CGI.parse(URI.parse(response).query)).to have_key('token')
      end
    end
  end
end