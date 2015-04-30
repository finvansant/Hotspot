class CreateUsers < ActiveRecord::Migration
  
  def change
    create_table :users do |t|
      t.string :name
      t.string :instagram_username
      t.integer :instagram_id
      t.datetime :last_update
    end
  end

end