describe 'Soulless::Serialization' do
  before(:each) do
    @model = DummyModel.new
  end

  it 'should serialize a string into a Soulless model' do
    @model.soulless = { name: 'Anthony' }

    expect(@model.soulless.class).to eq(SoullessModel)
  end
end
