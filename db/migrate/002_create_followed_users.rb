class CreateFollowedUsers < ActiveRecord::Migration
  
  def change
    create_table :followed_users do |t|
      t.integer :user_id
      t.integer :followed_user_id
    end
  end

end