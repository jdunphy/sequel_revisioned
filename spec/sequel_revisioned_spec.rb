require File.dirname(__FILE__) + '/spec_helper.rb'

describe Sequel::Plugins::Revisioned do
  it "should be a sequel plugin" do
    defined?(Sequel::Plugins::Revisioned).should == 'constant'
  end
  
  #There's a Post class in sequel-setup
  describe "applied to a Post model" do
    
    it "should generate a PostRevision class" do
      defined?(PostRevision).should == 'constant'
      PostRevision.superclass.should == Sequel::Model
    end
    
    it "should generate a post_revisions table" do
      PostRevision.table_exists?.should == true 
      PostRevision.columns.should include(:id)
      PostRevision.columns.should include(:post_id)
    end
    
    it "should add an instance method to access revisions" do
      post = Post.new
      post.save
      post.methods.should include('revisions')
      post.revisions.should be_is_a(Array)
    end
        
    it "should create a new revision if an object is saved"
  end
end
