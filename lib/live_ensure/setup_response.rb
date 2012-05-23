require 'live_ensure/accessible'
require 'live_ensure/response'
require 'live_ensure'
require 'live_ensure/errors'

module LiveEnsure
  class SetupResponse < Response
    accessible :launch_url, :token, :code, :base_url
    
    def parse_response
      raise InvalidResponse unless vars.size > 0
      
      parse_response_code
    end
    
    def parse_response_code
      response_code = vars[0].split(':')
      
      @hash['code'] = response_code[0].to_i
      
      case @hash['code']
      when 0
        raise AuthSessionError
      when 1
        @hash['base_url'] = LiveEnsure::HOST
        @hash['launch_url'] = "#{HOST}/launcher?sessionToken=#{response_code[1]}"
        @hash['token'] = response_code[1]
      when 2
        raise ServiceDown
      when 4
        @hash['base_url'] = @vars[1]
        @hash['launch_url'] = "#{@vars[1]}/launcher?sessionToken=#{response_code[1]}"
        @hash['token'] = response_code[1]
      end
    end
    
    def vars
      @vars ||= @response.split("\n")
    end
  end
end