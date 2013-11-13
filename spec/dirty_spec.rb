require 'spec_helper'

describe Soulless::Dirty do
  before(:each) do
    @dummy_class = DummyClass.new
  end
  
  it 'should support dirty attributes' do
    defined?(:changed?).should be_true
  end
  
  it 'should record attribute changes' do
    @dummy_class.name_changed?.should be_false
    @dummy_class.name = 'Yaw'
    @dummy_class.name_changed?.should be_true
  end
  
  it 'should correctly record changes to objects with initialized values' do
    @dummy_class = DummyClass.new(name: 'Biff')
    @dummy_class.name_changed?.should be_false
    @dummy_class.name = 'Anthony'
    @dummy_class.name_changed?.should be_true
  end
  
  it 'should record changes in a has_one association' do
    @dummy_association = DummyAssociation.new(spouse: { name: 'Megan' })
    @dummy_association.spouse.name_changed?.should be_false
    @dummy_association.spouse.name = 'Megan Jr'
    @dummy_association.spouse.name_changed?.should be_true
  end
  
  it 'should record changes in a has_many association' do
    @dummy_association = DummyAssociation.new(friends: [{ name: 'Yaw' }])
    @dummy_association.friends[0].name_changed?.should be_false
    @dummy_association.friends[0].name = 'Biff'
    @dummy_association.friends[0].name_changed?.should be_true
  end
  
  it 'should reset its dirty state when saved' do
    @dummy_class.name = 'Biff'
    @dummy_class.save
    @dummy_class.changed?.should be_false
  end
  
  it 'should not reset its dirty state if validations fail' do
    @dummy_class.name = nil
    @dummy_class.save
    @dummy_class.changed?.should be_true
  end
  
  it 'should record changed made before #save was called in previous_changes' do
    @dummy_class.name = 'Biff'
    @dummy_class.save
    @dummy_class.previous_changes.should_not be_empty
  end
end