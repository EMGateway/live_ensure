require 'live_ensure/accessible'
require 'live_ensure/response'
require 'live_ensure'
require 'live_ensure/errors'

module LiveEnsure
  class SessionStatusResponse < Response
    accessible :token, :message, :client, :session, :deviceHash, :knownDevice, :agent
    
    def parse_response
      @response_lines = @response.split("\n")
      parse_token
      parse_other
    end
    
    def parse_token
      split_line = @response_lines.shift.split(':')
      @hash['token'] = split_line[1]
    end
    
    def parse_other
      @response_lines.each do |line|
        key, val = line.split(':').map(&:strip)
        @hash[key] = val
      end
    end
    
    def valid?
      @hash['message'] == 'SUCCESS'
    end
    
    def failed?
      @hash['message'] == 'FAILED'
    end
    
    def undetermined?
      @hash['message'] == 'SESSION_UNDETERMINED'
    end
  end
end