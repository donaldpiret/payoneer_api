require 'spec_helper'
describe PayoneerApi::Payee do
  let(:response_hash) {
    {"GetPayeeDetails"=>
      {"Payee"=>
        {"FirstName"=>"Test",
          "LastName"=>"Test",
          "Email"=>"test@roomorama.com",
          "Address1"=>"Test Address",
          "Address2"=>"Test Address2",
          "City"=>"New York",
          "State"=>"NY",
          "Zip"=>"10018",
          "Country"=>"US",
          "Phone"=>"6594576031",
          "Mobile"=>nil,
          "PayOutMethod"=>"Prepaid Card",
          "Cards"=>
            {"Card"=>
              {"CardID"=>"0000000000000000",
                "ActivationStatus"=>"Not\n        Issued, Pending Approval",
                "CardStatus"=>"InActive"}},
          "RegDate"=>"5/4/2014 11:09:24 PM"}}}
  }

  it 'correctly initializes from a payoneer response' do
    payee = PayoneerApi::Payee.new(response_hash)
    expect(payee.first_name).to eq('Test')
  end
end