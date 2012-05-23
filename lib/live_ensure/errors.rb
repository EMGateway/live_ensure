module LiveEnsure
  class ServiceDown < StandardError; end
  class InvalidResponse < StandardError; end
  class AuthSessionError < StandardError; end
  class ConnectionError < StandardError; end
end