require 'payoneer_api/api/payees'

module PayoneerApi
  module API
    extend ActiveSupport::Concern

    include PayoneerApi::API::Payees
  end
end