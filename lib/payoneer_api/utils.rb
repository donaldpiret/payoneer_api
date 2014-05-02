module PayoneerApi
  module Utils
    # Turn a ruby boolean into an XML 'True'/'False' string
    #
    # @param boolean [Boolean] A boolean or nil.
    # @return [nil, String]
    def bool_to_string(boolean)
      return nil if boolean.nil?
      boolean ? 'True' : 'False'
    end

    def payout_methods_list(payout_methods)
      payout_methods.is_a?(Array) ?
        payout_methods.join(',') :
        payout_methods.to_s
    end

    # @param request_method [Symbol]
    # @param options [Hash]
    def perform(request_method, options)
      request = PayoneerApi::Request.new(self, request_method, options)
      request.perform
    end

    # @param request_method [Symbol]
    # @param options [Hash]
    # @param klass [Class]
    def perform_with_object(request_method, options, klass)
      request = PayoneerApi::Request.new(self, request_method, options)
      request.perform_with_object(klass)
    end
  end
end