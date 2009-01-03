require File.dirname(__FILE__) + '/spec_helper.rb'

describe Sequel::Plugins::Revisioned do
  it "should be a sequel plugin" do
    defined?(Sequel::Plugins::Revisioned).should == 'constant'
  end
  
  #There's a Post class in sequel-setup
  describe "applied to a model" do
    it "should generate a [Model]Version class"
    it "should generate a [Model]Versions table"
    it "should add an instance method to access versions"
    it "should create a new version if an object is saved"
  end
end
