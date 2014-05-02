module PayoneerApi
  class Request
    attr_accessor :client, :request_method, :options

    # @param client [PayoneerApi::Client]
    # @param request_method [String, Symbol]
    # @param options [Hash]
    # @return [PayoneerApi::Request]
    def initialize(client, request_method, options = {})
      @client = client
      @request_method = request_method.to_sym
      @options = options
    end

    # @return [Hash]
    def perform
      PayoneerApi::Response.new(@client.send("#{@request_method.to_s}_api_call".to_sym, @options)).body
    end

    # @param klass [Class]
    # @param request [PayoneerApi::Request]
    # @return [Object]
    def perform_with_object(klass)
      klass.new(perform)
    end
  end
end