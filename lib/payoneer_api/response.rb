module PayoneerApi
  class Response
    def initialize(response)
      @response = response
      raise PayoneerException, api_error_description if @response.code != '200'
      check_for_errors
    end

    def body
      xml?(@response.body) ? Hash.from_xml(@response.body) : @response.body
    end

    def xml_body
      @xml_body ||= Nokogiri::XML.parse(@response.body)
    end

    def xml?(text)
      !Nokogiri::XML.parse(text).errors.any?
    end

    private

    def api_error_description
      return unless @response and @response.body
      result = xml_body
      error_message = result.css('PayoneerResponse Description').first
      return error_message.text if error_message
      result.to_s
    end

    def check_for_errors
      if (result = xml_body.css('PayoneerResponse Result').first) && result.text == 'A00B556F'
        raise PayoneerException, api_error_description
      end
    end
  end
end