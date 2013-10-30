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