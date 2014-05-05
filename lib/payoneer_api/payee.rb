module PayoneerApi
  class Payee < PayoneerApi::Base
    attr_reader :first_name, :last_name, :address1, :address2, :city, :state, :zip, :country, :email, :phone,
      :mobile, :pay_out_method, :payee_status, :reg_date, :cards,
      :card_id, :card_activation_status, :card_ship_date, :card_status

    def initialize(attrs = {})
      super
      initialize_card_attrs if card?
    end

    def card?
      pay_out_method == 'Prepaid Card'
    end

    def direct_deposit?
      pay_out_method == 'Direct deposit'
    end

    def iach?
      pay_out_method == 'iACH'
    end

    private

    def initialize_card_attrs
      card_data = @attrs.fetch('Cards', {}).fetch('Card', {})
      @card_id = card_data['CardID']
      @card_activation_status = card_data['ActivationStatus']
      @card_ship_date = card_data['CardShipDate']
      @card_status = card_data['CardStatus']
    end
  end
end