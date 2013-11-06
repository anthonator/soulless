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
  
  it '#persisted? should be false' do
    @dummy_class.persisted?.should be_false
  end
  
  describe 'has_one' do
    it 'should allow hash values' do
      @dummy_class.spouse = { name: 'Megan' }
      @dummy_class.spouse.name.should == 'Megan'
    end
    
    it 'should allow a class type to be defined' do
      @dummy_class.dummy_clone = { name: 'Megan' }
      @dummy_class.dummy_clone.class.name.should match(/\ADummyClass::DummyClone/)
    end
    
    it 'should properly pull down error translations' do
      @dummy_class.dummy_clone = { name: nil }
      @dummy_class.dummy_clone.save
      @dummy_class.dummy_clone.errors[:name][0].should == "can't be blank"
    end
    
    it 'should properly pull down custom error translations' do
      I18n.load_path += Dir.glob(File.dirname(__FILE__) + '/support/en.yml')
      I18n.backend.load_translations
      @dummy_class.dummy_clone = { name: nil }
      @dummy_class.dummy_clone.save
      @dummy_class.dummy_clone.errors[:name][0].should == "this is a test"
    end
  end
  
  describe 'has_many' do
    it 'should allow array values' do
      @dummy_class.friends = [{ name: 'Biff' }]
      @dummy_class.friends[0].name.should == 'Biff'
    end
    
    it 'should allow a class type to be defined' do
      @dummy_class.dummy_clones = [{ name: 'Biff' }]
      @dummy_class.dummy_clones[0].class.name.should match(/\ADummyClass::DummyClone/)
    end
  end
end