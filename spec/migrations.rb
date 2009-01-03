class CreatePosts < Sequel::Migration
  def up
    create_table :posts do
      primary_key :id
      varchar     :title
      text        :body
    end
  end

  def down
    drop_table :posts
  end
end