module PayoneerApi
  class Payee < PayoneerApi::Base
    attr_reader :first_name, :last_name, :address1, :address2, :city, :state, :zip, :country, :email, :phone,
      :mobile, :pay_out_method, :cards, :payee_status, :reg_date

  end
end