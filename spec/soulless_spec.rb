require 'spec_helper'

describe Soulless do
  before(:each) do
    @dummy_class = DummyClass.new
  end
  
  it 'should validate name' do
    @dummy_class.name = nil
    @dummy_class.valid?.should == false
    @dummy_class.errors[:name].should_not be_empty
  end
  
  it 'should call #persist! when #save is called' do
    @dummy_class.save
    @dummy_class.saved.should be_true
  end
end