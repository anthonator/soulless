class DummyClass
  include Soulless.model

  attribute :name, String, default: 'Anthony'
  attribute :email, String
  attribute :validation_callback, Boolean
  attribute :save_callback, Boolean
  attribute :saved, Boolean, default: false

  validates :name, presence: true

  before_validation lambda { self.validation_callback = true }

  before_save lambda { self.save_callback = true }

  private
  def persist!
    self.saved = true
  end
end
