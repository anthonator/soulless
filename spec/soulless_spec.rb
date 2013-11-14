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
  
  it 'should call #persist! when #update_attributes is called' do
    @dummy_class.update_attributes(name: 'Biff')
    @dummy_class.saved.should be_true
  end
  
  it 'should not call #persist! if attributes are invalid' do
    @dummy_class.name = nil
    @dummy_class.save.should be_false
    @dummy_class.saved.should be_false
  end
  
  it '#update_attributes should update multiple attributes and then save' do
    @dummy_class.update_attributes(name: 'Yaw', email: 'yokoono@thebeatles.com')
    @dummy_class.name.should == 'Yaw'
    @dummy_class.email.should == 'yokoono@thebeatles.com'
    @dummy_class.saved?.should be_true
  end
  
  it '#update_attributes should merge new values' do
    @dummy_class.email = 'yokoono@thebeatles.com'
    @dummy_class.update_attributes(name: 'Yaw')
    @dummy_class.name.should == 'Yaw'
    @dummy_class.email.should == 'yokoono@thebeatles.com'
  end
  
  it '#update_attributes should deep merge new values' do
    @dummy_class = DummyAssociation.new(spouse: { name: 'Megan' })
    @dummy_class.update_attributes(spouse: { name: 'Mary Jane Watson' })
    @dummy_class.spouse.name.should == 'Mary Jane Watson'
  end
  
  it '#persisted? should be false' do
    @dummy_class.persisted?.should be_false
  end
end