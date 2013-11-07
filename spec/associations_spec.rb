require 'spec_helper'

describe Soulless::Associations do
  before(:each) do
    @dummy_class = DummyAssociation.new
  end
  
  describe 'has_one' do
    it 'should allow hash values' do
      @dummy_class.spouse = { name: 'Megan' }
      @dummy_class.spouse.name.should == 'Megan'
    end
    
    it 'should allow a class type to be defined' do
      @dummy_class.dummy_clone = { name: 'Megan' }
      @dummy_class.dummy_clone.class.name.should match(/\ADummyAssociation::DummyClone/)
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
      @dummy_class.dummy_clone.errors[:name][0].should == 'this is a test'
    end
  end
  
  describe 'has_many' do
    it 'should allow array values' do
      @dummy_class.friends = [{ name: 'Biff' }]
      @dummy_class.friends[0].name.should == 'Biff'
    end
    
    it 'should allow a class type to be defined' do
      @dummy_class.dummy_clones = [{ name: 'Biff' }]
      @dummy_class.dummy_clones[0].class.name.should match(/\ADummyAssociation::DummyClone/)
    end
  end
end