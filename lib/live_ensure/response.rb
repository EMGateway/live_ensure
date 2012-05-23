module LiveEnsure
  class Response

    include Accessible
    
    def initialize(response)
      @response = response
      @hash = {}
      parse_response
    end
  end
end