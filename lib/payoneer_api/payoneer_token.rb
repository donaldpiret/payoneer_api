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

    def to_s
      uri.to_s
    end
  end
end