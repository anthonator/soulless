require 'spec_helper'

describe Soulless::Inheritance do
  describe DummyModelInheritance do
    before(:each) do
      @dummy_inheritance = DummyModelInheritance.new
    end

    it 'should inherit the name attribute' do
      @dummy_inheritance.attributes.keys.should include(:name)
    end

    it 'should inherit the default value for the name attribute' do
      @dummy_inheritance.attributes[:name].should == 'Anthony'
    end

    it 'should not inhert the email attribute when added as exclude option' do
      @dummy_inheritance.attributes.keys.should_not include(:email)
    end

    it 'should validate presence of name' do
      @dummy_inheritance.name = nil
      @dummy_inheritance.valid?
      @dummy_inheritance.errors[:name].should include("can't be blank")
    end

    it 'should not validate email' do
      @dummy_inheritance.class.validators.each do |validator|
        validator.attributes.should_not include(:email)
      end
    end
  end

  describe DummySoullessInheritance do
    before(:each) do
      @dummy_inheritance = DummySoullessInheritance.new
    end

    it 'should inherit the name attribute' do
      @dummy_inheritance.attributes.keys.should include(:name)
    end

    it 'should inherit the default value for the name attribute' do
      @dummy_inheritance.attributes[:name].should == 'Anthony'
    end

    it 'should not inhert the email attribute when added as exclude option' do
      @dummy_inheritance.attributes.keys.should_not include(:email)
    end
  end
end
