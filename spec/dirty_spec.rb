describe Soulless::Dirty do
  before(:each) do
    @dummy_class = DummyClass.new
  end

  it 'should support dirty attributes' do
    expect(@dummy_class.respond_to?(:changed?)).to eq(true)
  end

  it 'should record attribute changes' do
    expect(@dummy_class.name_changed?).to eq(false)
    @dummy_class.name = 'Yaw'
    expect(@dummy_class.name_changed?).to eq(true)
  end

  it 'should correctly record changes to objects with initialized values' do
    @dummy_class = DummyClass.new(name: 'Biff')
    expect(@dummy_class.name_changed?).to eq(false)
    @dummy_class.name = 'Anthony'
    expect(@dummy_class.name_changed?).to eq(true)
  end

  it 'should record changes in a has_one association' do
    @dummy_association = DummyAssociation.new(spouse: { name: 'Megan' })
    expect(@dummy_association.spouse.name_changed?).to eq(false)
    @dummy_association.spouse.name = 'Megan Jr'
    expect(@dummy_association.spouse.name_changed?).to eq(true)
  end

  it 'should record changes in a has_many association' do
    @dummy_association = DummyAssociation.new(friends: [{ name: 'Yaw' }])
    expect(@dummy_association.friends[0].name_changed?).to eq(false)
    @dummy_association.friends[0].name = 'Biff'
    expect(@dummy_association.friends[0].name_changed?).to eq(true)
  end

  it 'should reset its dirty state when saved' do
    @dummy_class.name = 'Biff'
    @dummy_class.save
    expect(@dummy_class.changed?).to eq(false)
  end

  it 'should not reset its dirty state if validations fail' do
    @dummy_class.name = nil
    @dummy_class.save
    expect(@dummy_class.changed?).to eq(true)
  end

  it 'should record changed made before #save was called in previous_changes' do
    @dummy_class.name = 'Biff'
    @dummy_class.save
    expect(@dummy_class.previous_changes).to_not be_empty
  end
end
