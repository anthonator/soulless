describe 'Soulless::Dirty' do
  before(:each) do
    @model = SoullessModel.new
  end

  it 'should support dirty attributes' do
    expect(@model.respond_to?(:changed?)).to eq(true)
  end

  it 'should record attribute changes' do
    @model.name = 'Yaw'

    expect(@model.name_changed?).to eq(true)
  end

  it 'should correctly record changes to objects with initialized values' do
    @model = SoullessModel.new(name: 'Yaw')

    @model.name = 'Anthony'

    expect(@model.name_changed?).to eq(true)
  end

  it 'should not reset the dirty state if validations fail' do
    @model.name = 'Yaw'

    @model.valid?

    expect(@model.changed?).to eq(true)
  end

  it 'should reset the dirty state if #apply_changes is called' do
    @model.name = 'Yaw'

    @model.apply_changes

    expect(@model.changed?).to eq(false)
  end

  it 'should set value for #previous_changes if #apply_changes is called' do
    @model.name = 'Yaw'

    @model.apply_changes

    expect(@model.previous_changes).to_not be_empty
  end

  it 'should clear change values if #reload_changes! is called' do
    @model.name = 'Yaw'

    @model.reload_changes!

    expect(@model.changes).to be_empty
  end

  it 'should set values to previous values when #rollback_changes! is called' do
    @model.name = 'Yaw'

    @model.rollback_changes!

    expect(@model.name).to eq('Anthony')
  end
end
