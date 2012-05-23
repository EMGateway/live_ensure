require 'active_support/concern'

module LiveEnsure
  module Configure
    extend ActiveSupport::Concern

    module ClassMethods
      def configure
        yield configuration
      end

      def configuration
        @configuration ||= Configuration.new
      end

      class Configuration
        attr_accessor :api_key
        attr_accessor :api_password
        attr_accessor :api_agent_id
        attr_accessor :enabled
      end
    end
  end
end