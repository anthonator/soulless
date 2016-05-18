describe 'Soulless::Validations::UniquenessValidator' do
  before(:each) do
    DummyModel.create!(name: 'Anthony')
  end

  it 'should raise an error if model param was not passed' do
    model = SoullessBrokenUniqueModel.new

    expect{ model.valid? }.to raise_error(ArgumentError, 'Missing required argument "model"')
  end

  it 'should validate uniqueness on the model' do
    model = SoullessUniqueModel.new(name: 'Anthony')

    model.valid?

    expect(model.errors[:name]).to include('has already been taken')
  end
end
