module PayoneerApi
  class PayoneerResponse < PayoneerApi::Base
    attr_reader :status, :description, :version, :result
  end
end