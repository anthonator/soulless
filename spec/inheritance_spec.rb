describe 'Soulless::Inheritance' do
  before(:each) do
    @model      = SoullessInheritanceModel.new
    @attributes = SoullessInheritanceModel.attribute_set.get(@model)
  end

  it 'should inherit the name attribute' do
    expect(@attributes.keys).to include(:name)
  end

  it 'should inheirt the default value for the name attribute' do
    expect(@model.name).to eq('Anthony')
  end

  it 'should not inherit excluded attributes' do
    expect(@attributes.keys).to_not include(:email)
  end

  it 'should validate presence on the name attribute' do
    @model.name = nil

    @model.valid?

    expect(@model.errors[:name]).to include('can\'t be blank')
  end
end
