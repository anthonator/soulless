class DummySoullessInheritance
  include Soulless.model

  inherit_from(::DummyClass, { exclude: :email })

  private
  def persist!
    self.saved = true
  end
end

# This is a hack for now. For some reason Travis can't see dummy_class.rb.
class DummyClass
  include Soulless.model

  attribute :name, String, default: 'Anthony'
  attribute :email, String
  attribute :saved, Boolean, default: false

  validates :name, presence: true

  private
  def persist!
    self.saved = true
  end
end
