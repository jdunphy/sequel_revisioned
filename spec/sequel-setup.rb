DB = Sequel.sqlite
 
require File.dirname(__FILE__) + '/migrations'
CreatePosts.apply(DB, :up)

class Post < Sequel::Model
  is :revisioned, :watch => [:body]
end