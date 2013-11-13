require 'spec_helper'

describe Soulless::Validations::AssociatedValidator do
  it 'should not be valid if has_one associations are invalid' do
    dummy_association = DummyAssociation.new
    dummy_association.spouse = { name: nil }
    dummy_association.valid?.should be_false
    dummy_association.errors[:spouse].should include('is invalid')
    dummy_association.spouse.errors[:name].should include("can't be blank")
  end
  
  it 'should be valid if has_one associations are valid' do
    dummy_association = DummyAssociation.new
    dummy_association.spouse = { name: 'Megan' }
    dummy_association.valid?.should be_true
  end
  
  it 'should not be valid if has_many associations are invalid' do
    dummy_association = DummyAssociation.new
    dummy_association.friends = [{ name: nil }, { name: nil }]
    dummy_association.valid?.should be_false
    dummy_association.errors[:friends].should include('is invalid')
    dummy_association.friends[0].errors[:name].should include("can't be blank")
  end
  
  it 'should be valid if has_many associations are valid' do
    dummy_association = DummyAssociation.new
    dummy_association.friends = [{ name: 'Yaw' }, { name: 'Biff' }]
    dummy_association.valid?.should be_true
  end
end