require 'spec_helper'

describe Soulless::Validations::UniquenessValidator do
  it 'should validate uniqueness on model' do
    DummyModel.create!(name: 'Anthony')
    model = DummyModel.new(name: 'Anthony')
    expect(model.valid?).to eq(false)
    model.errors[:name].should include('has already been taken')
  end

  it 'should validate uniqueness on form' do
    DummyModel.create!(name: 'Anthony')
    form = DummyForm.new(name: 'Anthony')
    expect(form.valid?).to eq(false)
    form.errors[:name].should include('has already been taken')
  end
end
