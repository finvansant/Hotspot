class CreateCats < ActiveRecord::Migration
  
  def change
    create_table :cats do |t|
      t.string :name
    end

    add_column :users, :cat_id, :integer
    add_column :locations, :cat_id, :integer
  end

end