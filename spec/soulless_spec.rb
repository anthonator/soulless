require 'spec_helper'

describe Soulless do
  it 'has a version number' do
    expect(Soulless::VERSION).not_to be nil
  end

  it 'should initialize without changes' do
    model = SoullessModel.new(email: 'anthony@sticksnleaves.com')

    expect(model.changed?).to be_falsey
  end

  it 'should be equal if attributes are the same' do
    model_1 = SoullessModel.new(email: 'anthony@sticksnleaves.com')
    model_2 = SoullessModel.new(email: 'anthony@sticksnleaves.com')

    expect(model_1).to eq model_2
  end
end
