class CreatePosts < ActiveRecord::Migration

  def change
    create_table :posts do |t|
      t.string :content_url
      t.text :text
      t.integer :created_time
      t.float :lat
      t.float :lng
      t.string :location_name
      t.string :instagram_post_id
      t.integer :user_id
    end
  end

end