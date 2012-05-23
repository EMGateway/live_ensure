require 'patron'

require 'live_ensure/accessible'
require 'live_ensure/configure'
require 'live_ensure/errors'
require 'live_ensure/session_status_response'
require 'live_ensure/setup_response'
require "live_ensure/version"

module LiveEnsure
  HOST = "https://app.liveensure.com/live-identity"
  
  include Configure
  
  class << self
  
    def request_launch(email)
      SetupResponse.new(get(start_url(email)))
    end
  
    def session_status(token, base_url)
      SessionStatusResponse.new(get(session_status_url(token), base_url))
    end
  
    def get(url, base_url = '')
      connection = Patron::Session.new
      connection.connect_timeout = 5
      connection.timeout = 10
      connection.base_url = base_url unless base_url.empty?
      response = connection.get(url)

      if response.status < 400
        response.body
      else
        raise ConnectionError, response.status
      end
    end
  
    def start_url(email)
      "#{HOST}/idr/sessionStart/3/#{email}/#{configuration.api_agent_id}/#{configuration.api_key}/#{configuration.api_password}"
    end
  
    def session_status_url(token)
      "/idr/sessionStatus/4/#{token}/#{configuration.api_key}/#{configuration.api_password}"
    end
  end
end
