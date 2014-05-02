module PayoneerApi
  class Base
    attr_reader :attrs

    # Initializes a new object
    #
    # @param attrs [Hash]
    # @return [PayoneerApi::Base]
    def initialize(attrs = {})
      @attrs = attrs.deep_find(self.class.to_s.demodulize) if attrs.is_a?(Hash)
      @attrs ||= attrs
      @attrs.each do |k, v|
        instance_variable_set("@#{k.to_s.underscore}", v) unless v.nil?
      end
    end
  end
end