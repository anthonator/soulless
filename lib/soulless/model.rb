module Soulless
  class Model
    extend ActiveModel::Callbacks
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    extend Soulless::Inheritance
    extend Soulless::Serialization

    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::SecurePassword
    include ActiveModel::Serialization
    include ActiveModel::Validations

    include Soulless::Dirty
    include Soulless::Validations

    include Virtus.model

    prepend Soulless::Attributes
    prepend Soulless::Callbacks

    def initialize(params = {})
      super

      apply_changes
    end

    def i18n_scope
      :soulless
    end

    def persisted?
      false
    end

    def ==(o)
      self.to_h == o.to_h
    end
  end
end
