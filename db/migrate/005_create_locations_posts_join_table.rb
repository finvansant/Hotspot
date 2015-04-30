class CreateLocationsPostsJoinTable < ActiveRecord::Migration
  def change
    create_table :locations_posts, id: false do |t|
      t.integer :location_id
      t.integer :post_id
    end
  end
end