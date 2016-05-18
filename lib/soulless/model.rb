module Soulless
  class Model
    extend ActiveModel::Callbacks
    extend ActiveModel::Naming
    extend ActiveModel::Translation

    extend Soulless::Inheritance

    include ActiveModel::AttributeMethods
    include ActiveModel::Dirty
    include ActiveModel::Serialization
    include ActiveModel::Validations

    include Soulless::Dirty
    include Soulless::Validations

    include Virtus.model

    prepend Soulless::Attributes
    prepend Soulless::Callbacks

    def i18n_scope
      :soulless
    end

    def persisted?
      false
    end
  end
end
