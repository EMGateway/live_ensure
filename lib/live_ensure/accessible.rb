require 'active_support/concern'

module Accessible
  extend ActiveSupport::Concern
  
  module ClassMethods
    def accessible(*vars)
      vars.each do |var|
        define_method(var.to_s, proc{ @hash["#{var}"] })
      end
    end
  end
end