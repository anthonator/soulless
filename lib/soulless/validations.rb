require 'soulless/validations/associated_validator'
require 'soulless/validations/uniqueness_validator'

module Soulless
  module Validations
    def self.included(base)
      base.send(:extend, ClassMethods)
    end
  end
end