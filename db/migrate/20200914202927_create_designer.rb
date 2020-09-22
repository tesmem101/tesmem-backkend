class CreateDesigner < ActiveRecord::Migration[5.1]
  def change
    create_table :designers do |t|
      t.integer :design_id
      t.integer :category_id
      t.integer :sub_category_id
      t.boolean :approved, default: false
      t.boolean :private, default: false

      t.timestamps
    end
  end
end
