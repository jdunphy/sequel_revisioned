require File.dirname(__FILE__) + '/spec_helper.rb'

describe Sequel::Plugins::Revisioned do
  it "should be a sequel plugin" do
    defined?(Sequel::Plugins::Revisioned).should == 'constant'
  end
  
  #There's a Post class in sequel-setup
  # class Post < Sequel::Model
  #   is :revisioned
  # end
  describe "applied to a Post model" do
    
    it "should generate a PostRevision class" do
      defined?(PostRevision).should == 'constant'
      PostRevision.superclass.should == Sequel::Model
    end
    
    it "should add an instance method to access revisions" do
      post = Post.new
      post.save
      post.methods.should include('revisions')
      post.revisions.should be_is_a(Array)
    end
    
    it "should create a new revision if an object is saved" do
      post = Post.new
      post.save
      post.revisions.length.should eql(1)
    end
    
    it "should create a new revision if an object is updated" do 
      post = Post.new
      post.body = "Foo"
      post.save
      post.body = "boo"
      post.save
      post.revisions.length.should eql(2)
    end
     
    it "should provide a method to roll_back to a previous version"
    it "calling roll_back without a version number should raise an error"
    it "calling roll_back with an invalid revision version should raise an error"
  end
  
  describe "the generated PostRevision" do
    
    it "should generate a post_revisions table" do
      PostRevision.table_exists?.should == true 
      PostRevision.columns.should include(:id)
      PostRevision.columns.should include(:post_id)
      PostRevision.columns.should include(:version)
    end
    
    it "should have a created_at timestamp" do
      PostRevision.columns.should include(:created_at)
    end
    
    it "should have appropriate getters and setters" do
      pr = PostRevision.new
      pr.post_id.should be_nil
      pr.post_id = 1
      pr.post_id.should eql(1)
    end
    
    it "should have addtional fields for watched columns"
    
    it "should set :created_at when a revision is created" do
      post = Post.create
      pr = PostRevision.new
      pr.post_id = post.pk
      pr.save
      pr.created_at.should_not be_nil
    end

    it 'should be able to find a previous revision' do
      post = Post.create
      pr2 = PostRevision.create(:post_id => post.pk, :version => 2)
      pr3 = PostRevision.create(:post_id => post.pk, :version => 3)
      pr3.previous_revision.should eql(pr2)
    end
    
    it 'should be able to find the next revision' do
      post = Post.create
      pr2 = PostRevision.create(:post_id => post.pk, :version => 2)
      pr3 = PostRevision.create(:post_id => post.pk, :version => 3)
      pr2.next_revision.should eql(pr3)
    end

    it "should set initial revisions version to 1" do
      post = Post.new
      post.save
      post.revisions.first.version.should eql(1)
    end
    
    it "should set :version to the next sequential number when a revision is created" do
      pending
    end
    
  end
end
