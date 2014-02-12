class DummySoullessInheritance
  include Soulless.model
  
  inherit_from(DummyClass, { exclude: :email })
  
  private
  def persist!
    self.saved = true
  end
end