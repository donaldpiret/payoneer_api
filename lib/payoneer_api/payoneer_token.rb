module PayoneerApi
  class PayoneerToken < PayoneerApi::Base
    attr_reader :token

    def initialize(attrs = {})
      super
      raise PayoneerException, attrs unless token
    end

    def uri
      URI.parse(token)
    end
  end
end