class DummyModelInheritance
  include Soulless.model
  
  inherit_from(DummyModel, { use_database_default: [:name], exclude: :email, include_timestamps: true })
  
  private
  def persist!
    self.saved = true
  end
end