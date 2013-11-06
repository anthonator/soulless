class DummyClass
  include Soulless.model
  
  attribute :name, String, default: 'Anthony'
  attribute :email, String
  attribute :saved, Boolean, default: false
  
  has_one :spouse do
    attribute :name, String
  end
  
  has_one :dummy_clone, DummyClass do
    validates :email, presence: true
  end
  
  has_many :friends do
    attribute :name, String
  end
  
  has_many :dummy_clones, DummyClass

  validates :name, presence: true
  
  private
  def persist!
    self.saved = true
  end
end