require 'spec_helper'

describe Soulless::Validations::UniquenessValidator do
  it 'should validate uniqueness on model' do
    DummyModel.create!(name: 'Anthony')
    model = DummyModel.new(name: 'Anthony')
    model.valid?.should be_false
    model.errors[:name].should include('has already been taken')
  end
  
  it 'should validate uniqueness on form' do
    DummyModel.create!(name: 'Anthony')
    form = DummyForm.new(name: 'Anthony')
    form.valid?.should be_false
    form.errors[:name].should include('has already been taken')
  end
end