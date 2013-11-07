require File.dirname(__FILE__) + '/dummy_class'

class DummyAssociation
  include Soulless.model
  
  attribute :saved, Boolean, default: false
  
  has_one :spouse do
    attribute :name, String
  end
  
  has_many :friends do
    attribute :name, String
  end
  
  has_one :dummy_clone, DummyClass
  
  has_many :dummy_clones, DummyClass
  
  private
  def persist!
    self.saved = true
  end
end