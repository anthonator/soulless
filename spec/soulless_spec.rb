require 'spec_helper'

describe Soulless do
  before(:each) do
    @dummy_class = DummyClass.new
  end

  it 'should validate name' do
    @dummy_class.name = nil
    @dummy_class.valid?.should == false
    expect(@dummy_class.errors[:name]).to_not be_empty
  end

  it 'should call #persist! when #save is called' do
    @dummy_class.save
    expect(@dummy_class.saved).to eq(true)
  end

  it 'should call #persist! when #update_attributes is called' do
    @dummy_class.update_attributes(name: 'Biff')
    expect(@dummy_class.saved).to eq(true)
  end

  it 'should not call #persist! if attributes are invalid' do
    @dummy_class.name = nil
    expect(@dummy_class.save).to eq(false)
    expect(@dummy_class.saved).to eq(false)
  end

  it '#update_attributes should not save' do
    @dummy_class.assign_attributes(name: 'Yaw', email: 'yokoono@thebeatles.com')
    expect(@dummy_class.saved?).to eq(false)
  end

  it '#assign_attributes should merge new values' do
    @dummy_class.email = 'yokoono@thebeatles.com'
    @dummy_class.assign_attributes(name: 'Yaw')
    expect(@dummy_class.name).to eq('Yaw')
    expect(@dummy_class.email).to eq('yokoono@thebeatles.com')
  end

  it '#assign_attributes should deep merge new values' do
    @dummy_class = DummyAssociation.new(spouse: { name: 'Megan' })
    @dummy_class.assign_attributes(spouse: { name: 'Mary Jane Watson' })
    expect(@dummy_class.spouse.name).to eq('Mary Jane Watson')
  end

  it '#update_attributes should save' do
    @dummy_class.update_attributes(name: 'Yaw', email: 'yokoono@thebeatles.com')
    expect(@dummy_class.saved?).to eq(true)
  end

  it '#persisted? should be false' do
    expect(@dummy_class.persisted?).to eq(false)
  end

  it 'should call the before_validation callback' do
    @dummy_class.save
    expect(@dummy_class.validation_callback).to eq(true)
  end
end
